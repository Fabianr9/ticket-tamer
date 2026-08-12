//
//  TicketCardView.swift
//  Ticket_Tamer
//

import SwiftUI

// MARK: - Ticketkarte (Modul 006 — F-06 / F-07 / AK-06 / AK-07)

/// Vollstaendige, zusammenhaengende Ticketkarte auf einer festen Design-Canvas.
///
/// Die View enthaelt bewusst **keinen** `ScrollView`: alle Informationen aus AK-06
/// (Ticketnummer, Titel, Kurzbeschreibung, User Impact, alle Symptome) und die Schaltflaeche
/// aus F-07 sind gleichzeitig sichtbar. Die Groesse ist fix
/// (`LayoutConstants.ticketCardDesignWidth` × `ticketCardDesignHeight`); das Einpassen in den
/// verfuegbaren Platz uebernimmt ausschliesslich `ScaledToFitView`.
///
/// Referenzprioritaet und Referenzteam werden hier nicht angezeigt (AK-06).
struct TicketCardView: View {

    // MARK: - Eingaben

    /// Anzuzeigendes Ticket. Einzige Datenquelle der Karte.
    let ticket: Ticket

    /// Aktion der Schaltflaeche „Weiter zur Priorisierung" (F-07).
    let onContinue: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.ticketCardSectionSpacing) {
            ticketNumberBadge
            titleText

            Divider()

            shortDescriptionText
            userImpactSection
            symptomsSection

            // Schiebt die Schaltflaeche an den unteren Rand, ohne Inhalte zu strecken.
            Spacer(minLength: 0)

            Divider()

            continueButton
        }
        .padding(LayoutConstants.ticketCardPadding)
        .frame(
            width: LayoutConstants.ticketCardDesignWidth,
            height: LayoutConstants.ticketCardDesignHeight,
            alignment: .topLeading
        )
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: LayoutConstants.ticketCardCornerRadius)
        )
    }

    // MARK: - Ticketnummer

    private var ticketNumberBadge: some View {
        Text(ticket.ticketNumber)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding(.horizontal, LayoutConstants.ticketCardBadgeHorizontalPadding)
            .padding(.vertical, LayoutConstants.ticketCardBadgeVerticalPadding)
            .background(
                .secondary.opacity(LayoutConstants.ticketCardBadgeBackgroundOpacity),
                in: Capsule()
            )
            .accessibilityLabel(Text("investigation.ticketNumber.label") + Text(ticket.ticketNumber))
    }

    // MARK: - Titel

    private var titleText: some View {
        Text(ticket.title)
            .font(.title3)
            .bold()
            .lineLimit(LayoutConstants.ticketCardTitleLineLimit)
            .minimumScaleFactor(LayoutConstants.ticketCardTextMinimumScaleFactor)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Kurzbeschreibung

    private var shortDescriptionText: some View {
        Text(ticket.shortDescription)
            .font(.callout)
            .lineLimit(LayoutConstants.ticketCardBodyLineLimit)
            .minimumScaleFactor(LayoutConstants.ticketCardTextMinimumScaleFactor)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - User Impact

    private var userImpactSection: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.ticketCardLabelSpacing) {
            Text("investigation.userImpact.label")
                .font(.subheadline)
                .bold()
                .lineLimit(1)

            Text(ticket.userImpact)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(LayoutConstants.ticketCardBodyLineLimit)
                .minimumScaleFactor(LayoutConstants.ticketCardTextMinimumScaleFactor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Symptome / Hinweise

    private var symptomsSection: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.ticketCardLabelSpacing) {
            Text("investigation.symptoms.label")
                .font(.subheadline)
                .bold()
                .lineLimit(1)

            VStack(alignment: .leading, spacing: LayoutConstants.ticketCardSymptomSpacing) {
                ForEach(Array(ticket.symptoms.enumerated()), id: \.offset) { _, symptom in
                    Label {
                        Text(symptom)
                            .font(.callout)
                            .lineLimit(LayoutConstants.ticketCardSymptomLineLimit)
                            .minimumScaleFactor(LayoutConstants.ticketCardTextMinimumScaleFactor)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } icon: {
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Schaltflaeche (F-07)

    private var continueButton: some View {
        Button(action: onContinue) {
            Text("investigation.button.nextPhase")
                .lineLimit(1)
                .minimumScaleFactor(LayoutConstants.ticketCardTextMinimumScaleFactor)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Preview

#Preview {
    TicketCardView(
        ticket: Ticket(
            id: "preview",
            ticketNumber: "TT-006",
            title: "Administratorkonto gesperrt",
            shortDescription: "Ein privilegiertes Betriebskonto ist nach mehreren Anmeldeversuchen gesperrt.",
            userImpact: "Der betroffene Standort kann keine Tickets, Bestellungen oder Kundendaten bearbeiten.",
            symptoms: [
                "Anmeldung schlaegt mit Hinweis auf gesperrtes Konto fehl",
                "Betroffen sind mehrere Personen desselben Standorts",
                "Fehler tritt seit heute Morgen dauerhaft auf"
            ],
            referencePriority: .kritisch,
            referenceTeam: .konto,
            monsterAssetId: AssetKeys.Monster.monster01
        ),
        onContinue: {}
    )
}
