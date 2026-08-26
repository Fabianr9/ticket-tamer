import RealityKit
import simd
import Spatial
import SwiftUI

// MARK: - Ziel-ID → TicketPriority Mapping (Modul 008 — F-08 / AK-08)

/// Zentrale Zuordnung der drei technischen Ziel-IDs auf `TicketPriority`-Werte.
///
/// `internal` (kein expliziter Modifier), damit automatisierte Tests das Mapping
/// direkt prüfen können. Nutzerinnen und Nutzer sehen ausschließlich
/// `TicketPriority.displayName` (deutsche Labels). Technische IDs sind nie sichtbar.
enum PriorityTargetMapping {

    // MARK: - Ziel-Descriptor

    struct TargetDefinition {
        /// Fachlich neutrale technische Ziel-ID (erscheint nie in der UI).
        let id: String
        /// Fachlicher Prioritätswert.
        let priority: TicketPriority
        /// Räumliche Position im Volume-Koordinatensystem.
        let position: SIMD3<Float>
    }

    // MARK: - Vollständige Zielliste

    /// Genau drei Prioritätsziele — nicht mehr, nicht weniger.
    ///
    /// Positionen aus `PrioritizationConstants`: Abstand jeweils 0.32 m >
    /// 2 × `InteractionConstants.dropTargetRadius` (0.30 m), keine Überschneidung.
    static let allTargets: [TargetDefinition] = [
        .init(id: "priority_normal",   priority: .normal,   position: PrioritizationConstants.targetPositionNormal),
        .init(id: "priority_wichtig",  priority: .wichtig,  position: PrioritizationConstants.targetPositionWichtig),
        .init(id: "priority_kritisch", priority: .kritisch, position: PrioritizationConstants.targetPositionKritisch),
    ]

    // MARK: - Mapping

    /// Gibt die `TicketPriority` für eine technische Ziel-ID zurück, oder `nil` bei
    /// unbekannter ID.
    static func priority(for targetID: String) -> TicketPriority? {
        allTargets.first { $0.id == targetID }?.priority
    }
}

// MARK: - Priorisierungsansicht (Modul 008 — F-08 / AK-08 / AK-10)

/// Räumliche Priorisierungsansicht für `GamePhase.priorisieren`.
///
/// Zeigt das Monster des aktuellen Tickets und drei klar mit deutschen Bezeichnungen
/// beschriftete Prioritätsziele (Normal, Wichtig, Kritisch). Das Monster ist per
/// Blickfokus, Pinch und Drag interaktiv.
///
/// - Gültiger Drop: `SessionModel.savePriority(_:)` speichert die Priorität genau einmal.
/// - Ungültiger Drop: Monster kehrt zur Ausgangsposition zurück, kein Zustandswechsel.
/// - Keine automatische Phasenweiterleitung (Modul 010 / F-13).
/// - Keine Bewertung gegen `referencePriority` (Modul 010).
@MainActor
struct PrioritizationView: View {

    // MARK: - Environment

    @Environment(SessionModel.self) private var model

    // MARK: - Scene State

    @State private var monsterEntity: Entity? = nil
    @State private var targetEntities: [Entity] = []
    @State private var originTransform: Transform? = nil
    @State private var loadError: String? = nil

    // MARK: - Modul 010: Feedback-Zustand

    /// Verhindert mehrfachen Task-Start bei View-Refresh nach gespeicherter Priorität.
    @State private var feedbackTaskStarted: Bool = false
    /// Lokale Audio-Kapselung — kein globaler Service-Locator.
    @State private var audioService = AudioService()

    /// Tatsächlich gemessene Höhe des geladenen Modells in Metern.
    ///
    /// Stammt aus `MonsterAssetProvider.fit` und ist je Asset leicht unterschiedlich.
    /// Grundlage für den Sichtabstand zur Label-Zeile — dadurch passt der Abstand
    /// automatisch zu höheren wie flacheren Monstern.
    @State private var monsterHeight: Float = LayoutConstants.monsterDragDropTargetSize

    /// Position des Monsters zu Beginn der laufenden Zieh-Geste.
    ///
    /// Die Bewegung wird relativ zu diesem Wert berechnet (`PlanarDrag`), damit die
    /// Tiefenebene erhalten bleibt. `nil`, solange keine Geste läuft.
    @State private var dragStartPosition: SIMD3<Float>? = nil

    // MARK: - Modul 013: gemessene Drag-/Drop-Geometrie

    /// Gemeinsame Geometriequelle beider Zieh-Phasen — gemessenes Volume, gemessene
    /// Monster-Bounds, daraus abgeleiteter sicherer Bereich und die an den sichtbaren
    /// Labels ausgerichteten Zielflächen.
    @State private var geometry = MonsterDragGeometry()

    /// Rahmen der sichtbaren Prioritäts-Labels in Punkten, je Ziel-ID.
    @State private var labelFrames: [String: CGRect] = [:]

    /// Verhindert, dass die Grenz-Debugausgabe während einer Geste in jedem Frame erscheint.
    @State private var clampLogged: Bool = false

    /// Benannter Koordinatenraum, in dem die Label-Rahmen gemessen werden.
    ///
    /// Muss derselbe Raum sein, dessen Ausdehnung `VolumeMetrics.layoutFrame` beschreibt —
    /// sonst stimmen die abgeleiteten Zielflächen nicht mit den sichtbaren Labels überein.
    private static let layoutSpace = "prioritizationLayout"

    // MARK: - Body

    var body: some View {
        // `GeometryReader3D` liefert den tatsächlichen Layoutrahmen; zusammen mit
        // `content.convert(_:from:to:)` ergibt sich daraus die echte Volume-Größe in
        // Metern. Damit entfällt die Annahme, das Volume habe exakt die Maße aus
        // `LayoutConstants.centralVolume*` — genau diese Annahme war die gemeinsame
        // Ursache des Beschnitts in beiden Zieh-Phasen.
        GeometryReader3D { proxy in
        ZStack(alignment: .top) {
            // 3D-Szene
            // update: liest monsterEntity und targetEntities direkt — notwendig damit
            // RealityKit den Closure nach @State-Änderungen erneut ausführt (AK-08 Fix).
            RealityView { content in
                measureVolume(proxy: proxy, content: content)
            } update: { content in
                // Direkte Reads stellen SwiftUI-Dependency-Tracking sicher.
                let currentMonster  = monsterEntity
                let currentTargets  = targetEntities

                for entity in currentTargets where entity.scene == nil {
                    content.add(entity)
                }
                if let monster = currentMonster, monster.scene == nil {
                    content.add(monster)
                }

                measureVolume(proxy: proxy, content: content)
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in handleDragChanged(value: value) }
                    .onEnded { value in handleDragEnded(value: value) }
            )

            // Deutsche Labels für die drei Prioritätsziele.
            // Als ZStack-Overlay — zuverlässig ohne Attachment-API.
            // Visuell mit den drei Zielkugeln ausgerichtet (links / Mitte / rechts).
            HStack(spacing: LayoutConstants.targetLabelRowSpacing) {
                ForEach(PriorityTargetMapping.allTargets, id: \.id) { target in
                    priorityLabel(for: target)
                }
            }
            .padding(.top, LayoutConstants.targetLabelTopPadding)
            .padding(.horizontal, LayoutConstants.targetLabelRowHorizontalPadding)

            // DEBUG-Einstieg in die Teamphase — nur für Entwicklung/Simulator-Prüfung.
            // Nicht im Release-Build, nicht als F-09-Nutzerfunktion (AK-09).
            // Modul 010 übernimmt den normalen zeitgesteuerten Übergang (F-13).
            #if DEBUG
            if model.selectedPriority != nil {
                VStack {
                    Spacer()
                    Button("🔧 Team [DEV]") {
                        model.beginTeamAssignmentPhase()
                        DebugManager.log(.state, "[DEV] beginTeamAssignmentPhase manuell ausgeloest")
                    }
                    .font(.caption)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 12)
                }
            }
            #endif
            // Hinweis: Hier stand eine eingeblendete Messwertanzeige
            // („x 0.011  Δy -0.101 (Grenze ±0.10 / Lift 0.04)"). Sie ist entfernt.
            // Dieselben Werte gehen jetzt ausschließlich per DebugManager.log(.physics, …)
            // in die Konsole und erscheinen nie in der Benutzeroberfläche.

            // Ladeindikator — liest monsterEntity im Body (SwiftUI-Dependency-Tracking).
            if monsterEntity == nil && loadError == nil {
                ProgressView()
                    .controlSize(.large)
                    .padding(.top, 100)
            }

            // Fehlermeldung bei Ladefehlern (kein Crash, kein Auto-Wechsel).
            if let error = loadError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 80)
            }
        }
        .coordinateSpace(.named(Self.layoutSpace))
        .onPreferenceChange(TargetFramePreferenceKey.self) { frames in
            Task { @MainActor in
                labelFrames = frames
                syncTargetGeometry()
            }
        }
        .task {
            await setupScene()
        }
        .onAppear {
            // Eingabe nur freigeben, wenn noch keine Entscheidung getroffen wurde.
            // Kein Unlock nach View-Refresh bei bereits gespeicherter Priorität (AK-10).
            if model.selectedPriority == nil {
                model.unlockInput()
                feedbackTaskStarted = false
                DebugManager.log(.state, "PrioritizationView erschienen, Input freigegeben")
            } else {
                DebugManager.log(.state, "PrioritizationView erschienen, Prioritaet bereits gespeichert: \(model.selectedPriority!.rawValue)")
            }
        }
        // MARK: Modul 010 — Prioritätsfeedback und automatischer Übergang (F-11 / F-12 / F-13)
        .onChange(of: model.selectedPriority) { _, newPriority in
            guard newPriority != nil, !feedbackTaskStarted else { return }
            feedbackTaskStarted = true
            Task { @MainActor in
                // 1. Genau einmal bewerten.
                guard let isCorrect = model.evaluatePriority() else {
                    DebugManager.log(.state, "Prioritaetsbewertung war No-Op — Task beendet")
                    return
                }
                // 2. Genau einen Sound abspielen.
                audioService.play(isCorrect ? .correct : .incorrect)
                // 3. Eingabe bleibt gesperrt; Szene steht (kein visuelles Feedback-Label).
                // 4. Warten.
                try? await Task.sleep(for: .seconds(FeedbackConstants.feedbackTransitionDelay))
                // 5. Guard: Phase darf sich nicht unerwartet geändert haben.
                guard model.currentPhase == .priorisieren else {
                    DebugManager.log(.state, "Prioritaets-Task: Phase hat sich geaendert, kein Uebergang")
                    return
                }
                // 6. In Teamphase wechseln.
                model.beginTeamAssignmentPhase()
                DebugManager.log(.state, "Prioritaets-Feedbacktask abgeschlossen → teamZuordnen")
            }
        }
        }
    }

    // MARK: - Label-Subview

    /// Sichtbares deutsches Label für ein Prioritätsziel.
    ///
    /// `lineLimit(1)` + `minimumScaleFactor` verhindern die Silbentrennung („Nor-mal",
    /// „Wich-tig", „Kri-tisch"), die in schmalen Spalten entstand: statt umzubrechen,
    /// verkleinert sich die Schrift.
    @ViewBuilder
    private func priorityLabel(for target: PriorityTargetMapping.TargetDefinition) -> some View {
        Text(target.priority.displayName)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(LayoutConstants.targetLabelMinimumScaleFactor)
            .allowsTightening(true)
            .padding(.horizontal, LayoutConstants.targetLabelHorizontalPadding)
            .padding(.vertical, LayoutConstants.targetLabelVerticalPadding)
            .background(
                labelColor(for: target.priority).opacity(LayoutConstants.targetLabelBackgroundOpacity),
                in: RoundedRectangle(cornerRadius: LayoutConstants.targetLabelCornerRadius)
            )
            // Bewusst **vor** `.frame(maxWidth: .infinity)`: gemeldet werden soll der
            // Rahmen der sichtbaren farbigen Fläche, nicht der der unsichtbaren
            // Spaltenbreite. Die Beschriftung selbst wird dadurch nicht bewegt — nur das
            // technische DropTarget richtet sich anschließend darauf aus (Aufgabe 8).
            .reportTargetFrame(id: target.id, in: .named(Self.layoutSpace))
            .frame(maxWidth: .infinity)
    }

    /// Hintergrundfarbe je Priorität — visuell unterscheidbar, semantisch passend.
    private func labelColor(for priority: TicketPriority) -> Color {
        switch priority {
        case .normal:   return .green
        case .wichtig:  return .orange
        case .kritisch: return .red
        }
    }

    // MARK: - Szenenaufbau

    /// Erzeugt die drei Prioritätsziele und lädt das Monster asynchron.
    private func setupScene() async {
        // Drei Prioritätsziele aufbauen.
        for targetDef in PriorityTargetMapping.allTargets {
            let entity = Entity()
            entity.name = "priorityTarget_\(targetDef.id)"
            entity.position = targetDef.position
            entity.components.set(
                DropTargetComponent(
                    id: targetDef.id,
                    radius: InteractionConstants.dropTargetRadius,
                    debugName: targetDef.priority.displayName
                )
            )

            // Bewusst KEINE sichtbare Zielkugel.
            //
            // Hier hing zuvor ein `ModelEntity` mit `MeshResource.generateSphere(...)` und
            // halbtransparentem `SimpleMaterial` in Prioritätsfarbe. Genau dieses Element war
            // der „orangene Halbkreis" unter „Wichtig": eine durchscheinende Kugel, die von den
            // Volume-Grenzen angeschnitten wurde. Die seitlichen Kugeln (grün/rot) lagen so weit
            // außen, dass sie ganz weggeschnitten wurden — sichtbar blieb nur die mittlere.
            //
            // Die drei Ziele bleiben als reine Trefferbereiche bestehen: `DropTargetComponent`
            // ist unverändert gesetzt, `DropEvaluator` arbeitet rein positionsbasiert. Sichtbare
            // Orientierung geben ausschließlich die drei Labels Normal / Wichtig / Kritisch.
            targetEntities.append(entity)
            DebugManager.log(.spawning, "Prioritaetsziel bereit: \(targetDef.id) an \(targetDef.position)")
        }

        // Monster laden.
        guard let ticket = model.currentTicket else {
            DebugManager.log(.spawning, "Kein aktives Ticket — Monster-Load abgebrochen")
            loadError = "Kein aktives Ticket."
            return
        }

        do {
            let entity = try await MonsterAssetProvider.loadMonster(assetID: ticket.monsterAssetId)
            // Größe aus den tatsächlichen Modellmaßen ableiten statt aus einem festen Faktor —
            // sonst ist die physische Größe je Blender-Export unterschiedlich.
            let fitted = MonsterAssetProvider.fit(
                entity,
                toMaxExtent: LayoutConstants.monsterDragDropTargetSize
            )
            // Gemessene Höhe merken — Grundlage für den Sichtabstand zur Label-Zeile.
            monsterHeight = fitted.y
            entity.position = PrioritizationConstants.monsterStartPosition
            originTransform = entity.transform
            MonsterInteractionConfigurator.configure(entity, mode: .dragDrop)
            monsterEntity = entity

            // Tatsächliche sichtbare Hülle messen — Grundlage für den sicheren
            // Zieh-Bereich und für die Überlappungsprüfung beim Loslassen.
            geometry.measureMonster(entity, assetID: ticket.monsterAssetId)
            syncTargetGeometry()

            DebugManager.log(.spawning, "Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // Hinweis: `uiColor(for:)` ist entfallen. Die Funktion lieferte ausschließlich den
    // Tint für das `SimpleMaterial` der entfernten Zielkugeln und wird nicht mehr benötigt.
    // Die sichtbaren Prioritätsfarben kommen aus `labelColor(for:)`.

    // MARK: - Geometrie (Modul 013 — Drag-/Drop-Randfix)

    /// Misst das tatsächliche Volume und die Layoutebene.
    ///
    /// Wird sowohl beim Aufbau als auch bei jedem `RealityView`-Update aufgerufen, damit
    /// eine Größenänderung des Volumes sofort in die Zieh-Grenzen einfließt. Der Zustand
    /// wird nur geschrieben, wenn sich die Messung tatsächlich geändert hat — sonst
    /// entstünde eine Update-Schleife.
    private func measureVolume(proxy: GeometryProxy3D, content: RealityViewContent) {
        let localFrame = proxy.frame(in: .local)

        // Entities werden über `content.add(_:)` direkt an der Szenenwurzel eingehängt;
        // `entity.position` und `.scene` beschreiben deshalb denselben Raum.
        let volume = content.convert(localFrame, from: .local, to: .scene)

        let measured = VolumeMetrics(
            volume: volume,
            layoutFrame: CGRect(
                x: localFrame.origin.x,
                y: localFrame.origin.y,
                width: localFrame.size.width,
                height: localFrame.size.height
            )
        )

        guard measured.isUsable, geometry.metrics != measured else { return }

        Task { @MainActor in
            geometry.update(metrics: measured)
            syncTargetGeometry()
        }
    }

    /// Richtet die technischen DropTargets auf die gemessenen Rahmen der sichtbaren
    /// Labels aus.
    ///
    /// Die Labels selbst bleiben unverändert an ihrer Layoutposition; verschoben wird
    /// ausschließlich die Trefferfläche — und zwar **auf** die sichtbare Box, nicht zur
    /// Mitte hin.
    private func syncTargetGeometry() {
        geometry.updateTargets(
            labelFrames: labelFrames,
            entities: targetEntities,
            dropPlaneZ: PrioritizationConstants.monsterStartPosition.z
        )
    }

    // MARK: - Gesture-Handler

    private func handleDragChanged(value: EntityTargetValue<DragGesture.Value>) {
        guard !model.isInputLocked else {
            DebugManager.log(.input, "Drag ignoriert: Input gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Position bei Gestenbeginn merken — Grundlage für die relative Bewegung.
        //
        // Bewusst `entity.position` (lokal, also relativ zur Elternentity) statt
        // `position(relativeTo: nil)` (Weltraum). Lokal ist der Raum, in dem sämtliche
        // Konstanten dieser Phase formuliert sind: Start- und Zielpositionen werden über
        // `entity.position = …` gesetzt. Die frühere Mischung aus Weltraum beim Ziehen und
        // lokalem Raum beim Speichern des Ursprungs war die Ursache des fehlerhaften
        // Rücksprungs.
        let start = dragStartPosition ?? entity.position
        if dragStartPosition == nil {
            dragStartPosition = start
            DebugManager.log(.input, "[Monster Transform BEFORE DRAG] \(entity.dragStateSummary)")
            // Kontrollausgabe: lokale und Weltposition müssen übereinstimmen, sonst ist die
            // Annahme falsch, dass `content.add(_:)` an der Szenenwurzel einhängt — und die
            // gemessenen Volume-Grenzen lägen in einem anderen Raum als `entity.position`.
            DebugManager.log(
                .physics,
                "Raumprobe: local=\(entity.position) world=\(entity.position(relativeTo: nil))"
            )
        }

        // Planare Bewegung: X/Y folgen der Geste, Z bleibt auf der Starttiefe.
        // Siehe PlanarDrag zur Begründung — die frühere Übernahme der absoluten
        // Zeigerposition verursachte Tiefensprung, Zurückwandern und zu kurze X-Wege.
        //
        // Die Grenzen halten die Modellhülle samt Sicherheitsabstand innerhalb des Volumes.
        // Ohne sie konnte das Monster beim Ziehen zu den Prioritätsfeldern über die obere
        // Volume-Kante hinauslaufen und wurde dort beschnitten.
        // Nur die Translation wird geschrieben — Rotation und Scale der Entity bleiben
        // unangetastet. Die Blender-Y-up-Korrektur und die Einpassung aus
        // `MonsterAssetProvider` überstehen das Ziehen dadurch unverändert.
        let requested = PlanarDrag.requestedPosition(
            from: start,
            translation: value.gestureValue.translation
        )

        if let allowed = geometry.clamped(requested) {
            // Einmal je Geste protokollieren, sobald die Grenze tatsächlich greift.
            if !clampLogged, simd_distance(allowed, requested) > 0.0005 {
                clampLogged = true
                DebugManager.log(
                    .physics,
                    "Requested drag position: \(requested) | Clamped drag position: \(allowed)"
                )
                if let safe = geometry.safeBounds {
                    DebugManager.log(.physics, safe.debugSummary)
                }
            }

            // Regulärer Weg: Grenze aus gemessenem Volume minus gemessener Monsterhülle
            // minus Padding. Sie wirkt an allen vier Rändern und achsenweise unabhängig,
            // sodass das Monster an einer Ecke entlang der jeweils freien Achse
            // weitergleitet.
            //
            // Die frühere Obergrenze `PrioritizationConstants.monsterCeiling(...)` ist hier
            // bewusst entfallen: sie hielt das Monster unterhalb der Label-Zeile — genau
            // dort, wo die Ziele liegen. Mit ihr wäre keine Zielbox mehr erreichbar.
            // Dass das Monster oben nicht abgeschnitten wird, sichert jetzt der gemessene
            // sichere Bereich.
            entity.position = allowed
        } else {
            // Rückfallebene, solange Volume oder Monster noch nicht vermessen sind
            // (erster Layoutdurchlauf). Verhält sich wie bisher.
            entity.position = PlanarDrag.position(
                from: start,
                translation: value.gestureValue.translation,
                limits: PlanarDrag.playAreaLimits(
                    forEntityOfSize: LayoutConstants.monsterDragDropTargetSize
                ),
                maximumY: PrioritizationConstants.monsterCeiling(forMonsterHeight: monsterHeight)
            )
        }
    }

    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Immer zuerst: die Geste ist beendet, der gemerkte Startpunkt gilt nicht mehr.
        dragStartPosition = nil
        clampLogged = false

        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Überlappungsbasierte Auswertung.
        //
        // Zuvor entschied `evaluateColumn` allein über die geringste X-Abweichung. Das
        // machte zwar alle drei Ziele erreichbar, teilte aber die gesamte Fläche unter
        // ihnen auf: jede Ablage oberhalb der Lift-Schwelle traf zwangsläufig irgendein
        // Ziel, auch eine Ablage genau zwischen zwei Boxen.
        //
        // `evaluateOverlap` prüft stattdessen, ob die **sichtbare** Monsterhülle die
        // **sichtbare** Zielfläche ausreichend überdeckt. Der Monster-Root muss dafür kein
        // Ziel-Zentrum erreichen — was bei randnahen Zielen mit korrektem sicheren
        // Zieh-Bereich auch gar nicht möglich wäre — und eine Ablage im Freiraum trifft
        // nichts.
        let origin = originTransform?.translation ?? PrioritizationConstants.monsterStartPosition
        let dropped = entity.position

        DebugManager.log(.physics, "[Monster Transform AT RELEASE] \(entity.dragStateSummary)")
        DebugManager.log(
            .physics,
            "Drop bei \(dropped), Start \(origin), Anhebung \(dropped.y - origin.y)"
        )

        let hit: String?
        if geometry.canEvaluateOverlap {
            hit = geometry.hitTarget(at: dropped)
        } else {
            // Rückfallebene, solange die Label-Rahmen noch nicht gemessen sind.
            let descriptors: [DropEvaluator.TargetDescriptor] = targetEntities.compactMap { e in
                guard let comp = e.components[DropTargetComponent.self] else { return nil }
                return DropEvaluator.TargetDescriptor(
                    id: comp.id,
                    position: e.position,
                    radius: comp.radius
                )
            }
            hit = DropEvaluator.evaluateColumn(
                entityPosition: dropped,
                origin: origin,
                targets: descriptors,
                minimumLift: PrioritizationConstants.minimumDropLift
            )
            DebugManager.log(.physics, "Fallback-Auswertung (Geometrie noch nicht vermessen)")
        }

        if let hitID = hit {
            DebugManager.log(.physics, "Gueltiger Drop: Ziel=\(hitID)")
            if let priority = PriorityTargetMapping.priority(for: hitID) {
                model.savePriority(priority)
                DebugManager.log(.state, "Prioritaet gespeichert: \(priority.rawValue), isInputLocked=\(model.isInputLocked)")
            } else {
                DebugManager.log(.physics, "Unbekannte Ziel-ID: \(hitID)")
                returnMonsterToOrigin(entity: entity)
            }
        } else {
            returnMonsterToOrigin(entity: entity)
            DebugManager.log(.physics, "Ungueltiger Drop: Monster kehrt zurueck")
        }
    }

    /// Stellt nach einem ungültigen Drop exakt den Zustand vom Phasenbeginn wieder her.
    ///
    /// `originTransform` ist der **lokale** Transform, wie er in `setupScene` gesichert wurde
    /// (Position, Rotation, Skalierung). Deshalb muss auch relativ zur Elternentity
    /// zurückgesetzt werden — vorher stand hier `relativeTo: nil`, also der Weltraum. Ein
    /// lokaler Transform, als Welt-Transform angewendet, ergibt eine andere Platzierung und
    /// bei skalierter Elternentity zusätzlich eine andere sichtbare Größe.
    ///
    /// `move(to:)` überträgt Translation, Rotation und Scale gemeinsam — es wird kein neuer
    /// `Transform(translation:)` gebaut, bei dem Rotation oder Scale verloren gingen.
    private func returnMonsterToOrigin(entity: Entity) {
        guard let origin = originTransform else { return }
        entity.move(
            to: origin,
            relativeTo: entity.parent,
            duration: InteractionConstants.monsterReturnDuration,
            timingFunction: .easeInOut
        )
        DebugManager.log(
            .physics,
            "[Monster Transform AFTER SNAPBACK] Ziel pos=\(origin.translation) scale=\(origin.scale)"
        )
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    let model = SessionModel()
    model.setTicketCount(1)
    model.startSession(using: { $0 })
    model.beginPrioritizationPhase()
    return PrioritizationView()
        .environment(model)
}
