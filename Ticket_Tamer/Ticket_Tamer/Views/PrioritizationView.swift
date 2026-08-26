import RealityKit
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

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            // 3D-Szene
            // update: liest monsterEntity und targetEntities direkt — notwendig damit
            // RealityKit den Closure nach @State-Änderungen erneut ausführt (AK-08 Fix).
            RealityView { _ in
                // Szene wird via update: aufgebaut, nachdem Entities asynchron bereit sind.
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
                    priorityLabel(target.priority.displayName, priority: target.priority)
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

    // MARK: - Label-Subview

    /// Sichtbares deutsches Label für ein Prioritätsziel.
    ///
    /// `lineLimit(1)` + `minimumScaleFactor` verhindern die Silbentrennung („Nor-mal",
    /// „Wich-tig", „Kri-tisch"), die in schmalen Spalten entstand: statt umzubrechen,
    /// verkleinert sich die Schrift.
    @ViewBuilder
    private func priorityLabel(_ text: String, priority: TicketPriority) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(LayoutConstants.targetLabelMinimumScaleFactor)
            .allowsTightening(true)
            .padding(.horizontal, LayoutConstants.targetLabelHorizontalPadding)
            .padding(.vertical, LayoutConstants.targetLabelVerticalPadding)
            .background(
                labelColor(for: priority).opacity(LayoutConstants.targetLabelBackgroundOpacity),
                in: RoundedRectangle(cornerRadius: LayoutConstants.targetLabelCornerRadius)
            )
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
            DebugManager.log(.spawning, "Monster bereit: \(ticket.monsterAssetId), Modus: dragDrop")
        } catch {
            DebugManager.log(.spawning, "Monster-Load fehlgeschlagen: \(error.localizedDescription)")
            loadError = "Monster konnte nicht geladen werden."
        }
    }

    // Hinweis: `uiColor(for:)` ist entfallen. Die Funktion lieferte ausschließlich den
    // Tint für das `SimpleMaterial` der entfernten Zielkugeln und wird nicht mehr benötigt.
    // Die sichtbaren Prioritätsfarben kommen aus `labelColor(for:)`.

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
        entity.position = PlanarDrag.position(
            from: start,
            translation: value.gestureValue.translation,
            limits: PlanarDrag.playAreaLimits(
                forEntityOfSize: LayoutConstants.monsterDragDropTargetSize
            ),
            // Obergrenze aus der gemessenen Modellhöhe: das Monster bleibt auch am
            // höchsten Zieh-Punkt sichtbar unterhalb der Auswahlflächen.
            maximumY: PrioritizationConstants.monsterCeiling(forMonsterHeight: monsterHeight)
        )
    }

    private func handleDragEnded(value: EntityTargetValue<DragGesture.Value>) {
        // Immer zuerst: die Geste ist beendet, der gemerkte Startpunkt gilt nicht mehr.
        dragStartPosition = nil

        guard !model.isInputLocked else {
            DebugManager.log(.input, "Release ignoriert: Input bereits gesperrt (AK-10)")
            return
        }
        guard let entity = monsterEntity, value.entity === entity else { return }

        // Spaltenbasierte Auswertung statt Radiusprüfung.
        //
        // Vorher entschied `DropEvaluator.evaluate(entity:targets:)` über einen absoluten
        // Radius um absolute Meterpositionen. Die tatsächlich per Drag erreichbare Strecke
        // hängt aber von der Fenster-/Volumegröße ab: „Wichtig" lag 0.21 m entfernt (ab
        // 0.06 m Bewegung erreichbar), „Normal" und „Kritisch" 0.38 m (0.23 m Bewegung
        // nötig). Deshalb ließ sich ausschließlich „Wichtig" zuweisen, alles andere fiel in
        // den Ungültig-Zweig und sprang zurück.
        //
        // `evaluateColumn` teilt den erreichbaren Bereich stattdessen unter den drei Zielen
        // auf: es gewinnt das Ziel mit der geringsten X-Abweichung. Alle drei Prioritäten
        // sind damit gleichwertig erreichbar.
        let descriptors: [DropEvaluator.TargetDescriptor] = targetEntities.compactMap { e in
            guard let comp = e.components[DropTargetComponent.self] else { return nil }
            return DropEvaluator.TargetDescriptor(
                id: comp.id,
                // Lokal wie das Monster — beide sind Kinder derselben Wurzelentity und
                // wurden über `entity.position = …` aus denselben Konstanten gesetzt.
                position: e.position,
                radius: comp.radius
            )
        }

        let origin = originTransform?.translation ?? PrioritizationConstants.monsterStartPosition
        let dropped = entity.position

        DebugManager.log(.physics, "[Monster Transform AT RELEASE] \(entity.dragStateSummary)")
        DebugManager.log(
            .physics,
            "Drop bei \(dropped), Start \(origin), Anhebung \(dropped.y - origin.y)"
        )

        if let hitID = DropEvaluator.evaluateColumn(
            entityPosition: dropped,
            origin: origin,
            targets: descriptors,
            minimumLift: PrioritizationConstants.minimumDropLift
        ) {
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
