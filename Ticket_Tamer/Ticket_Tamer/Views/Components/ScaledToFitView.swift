//
//  ScaledToFitView.swift
//  Ticket_Tamer
//

import SwiftUI

// MARK: - Fit-to-Space Container

/// Layoutet beliebigen Inhalt auf einer festen Design-Canvas und passt ihn anschliessend
/// gleichmaessig in den tatsaechlich verfuegbaren Bereich ein.
///
/// Prinzip „fit to available space":
/// Der Inhalt wird immer mit exakt `designSize` gelayoutet — Schriftgroessen, Abstaende und
/// Zeilenumbrueche sind damit stabil und unabhaengig von der Fenstergroesse. Erst danach wird
/// die fertige Flaeche mit **einem einzigen** Faktor skaliert (`scaleEffect`), der fuer Breite
/// und Hoehe identisch ist.
///
/// Daraus folgt:
/// - kein Stretching und keine Verzerrung, da X und Y denselben Faktor verwenden,
/// - konstantes Seitenverhaeltnis bei jeder Fenster- und Bildschirmgroesse,
/// - proportionale Anpassung von Schriftgroessen und Abstaenden „gratis",
///   weil die gesamte Flaeche skaliert wird und nicht einzelne Werte,
/// - kein Scrollen, weil der Inhalt nicht in den Bereich gedraengt, sondern eingepasst wird.
///
/// Da `scaleEffect` die Layoutgroesse nicht veraendert, wird die skalierte Flaeche anschliessend
/// ueber ein zweites `frame` korrekt im Layout gemeldet und im verfuegbaren Bereich zentriert.
struct ScaledToFitView<Content: View>: View {

    // MARK: - Eingaben

    /// Feste Bezugsgroesse, in der der Inhalt gelayoutet wird.
    let designSize: CGSize

    /// Untere Grenze des Skalierungsfaktors — schuetzt die Lesbarkeit.
    let minScale: Double

    /// Obere Grenze des Skalierungsfaktors — verhindert sichtbar weichen, hochskalierten Text.
    let maxScale: Double

    /// Auf der Design-Canvas gelayouteter Inhalt.
    @ViewBuilder var content: () -> Content

    // MARK: - Init

    init(
        designSize: CGSize,
        minScale: Double = LayoutConstants.ticketCardMinScale,
        maxScale: Double = LayoutConstants.ticketCardMaxScale,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.designSize = designSize
        self.minScale = minScale
        self.maxScale = maxScale
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let scale = CGFloat(fittingScale(for: proxy.size))

            content()
                // 1. Inhalt immer in der festen Bezugsgroesse layouten.
                .frame(width: designSize.width, height: designSize.height)
                // 2. Fertige Flaeche mit einem gemeinsamen Faktor gleichmaessig skalieren.
                .scaleEffect(scale, anchor: .center)
                // 3. Skalierte Groesse dem Layout melden (scaleEffect tut das nicht selbst).
                .frame(width: designSize.width * scale, height: designSize.height * scale)
                // 4. Im verfuegbaren Bereich zentrieren.
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    // MARK: - Skalierung

    /// Groesster Faktor, bei dem die Design-Canvas vollstaendig in `available` passt.
    ///
    /// `min` ueber beide Achsen entspricht `ContentMode.fit`: die knappere Achse bestimmt den
    /// Faktor, die andere erhaelt Rand. Anschliessend wird auf `[minScale, maxScale]` begrenzt.
    private func fittingScale(for available: CGSize) -> Double {
        guard designSize.width > 0, designSize.height > 0 else { return minScale }

        let widthRatio = Double(available.width / designSize.width)
        let heightRatio = Double(available.height / designSize.height)
        let raw = min(widthRatio, heightRatio)

        // Waehrend des ersten Layoutdurchlaufs kann die Groesse 0 oder nicht endlich sein.
        guard raw.isFinite, raw > 0 else { return minScale }

        return min(max(raw, minScale), maxScale)
    }
}

// MARK: - Preview

#Preview {
    ScaledToFitView(
        designSize: CGSize(
            width: LayoutConstants.ticketCardDesignWidth,
            height: LayoutConstants.ticketCardDesignHeight
        )
    ) {
        RoundedRectangle(cornerRadius: LayoutConstants.ticketCardCornerRadius)
            .fill(.blue.opacity(0.3))
            .frame(
                width: LayoutConstants.ticketCardDesignWidth,
                height: LayoutConstants.ticketCardDesignHeight
            )
    }
}
