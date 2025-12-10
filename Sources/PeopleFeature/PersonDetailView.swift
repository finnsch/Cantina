import SharedModels
import Styleguide
import SwiftUI

struct PersonDetailView: View {
    let person: Person

    init(person: Person) {
        self.person = person
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                statsSection
                detailsSection
                relatedSection
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.app.background)
    }

    @ViewBuilder
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            AppGradient.default
                .frame(height: 320)

            AsyncImage(url: person.imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                case .failure:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
            .frame(width: 200, height: 280)
            .padding(.bottom, 24)
        }

        VStack(spacing: 8) {
            Text(person.name)
                .font(.largeTitle.bold())
                .foregroundStyle(Color.app.primaryLabel)

            Text(person.birthYear)
                .font(.subheadline)
                .foregroundStyle(Color.app.secondaryLabel)
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
    }

    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.app.cardBackground)
            .frame(width: 200, height: 280)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.app.tertiaryLabel)
            }
    }

    private var statsSection: some View {
        HStack(spacing: 0) {
            StatItemView(
                icon: Image(systemName: "ruler"),
                title: "Height",
                value: person.formattedHeight,
            )

            Divider()
                .frame(height: 40)
                .background(Color.app.separator)

            StatItemView(
                icon: Image(systemName: "scalemass"),
                title: "Mass",
                value: person.formattedMass,
            )

            Divider()
                .frame(height: 40)
                .background(Color.app.separator)

            StatItemView(
                icon: Image(systemName: "person"),
                title: "Gender",
                value: person.gender.capitalized,
            )
        }
        .padding(.vertical, 24)
        .background(Color.app.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Physical Attributes")

            VStack(spacing: 12) {
                DetailRowView(
                    icon: Image(systemName: "eye.fill"),
                    label: "Eye Color",
                    value: person.eyeColor.capitalized,
                )
                DetailRowView(
                    icon: Image(systemName: "comb.fill"),
                    label: "Hair Color",
                    value: person.hairColor.capitalized,
                )
                DetailRowView(
                    icon: Image(systemName: "hand.raised.fill"),
                    label: "Skin Color",
                    value: person.skinColor.capitalized,
                )
            }
            .padding(16)
            .background(Color.app.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Appearances & Affiliations")

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12,
            ) {
                RelatedCountCardView(
                    icon: Image(systemName: "film"),
                    title: "Films",
                    count: person.films.count,
                )
                RelatedCountCardView(
                    icon: Image(systemName: "airplane"),
                    title: "Starships",
                    count: person.starships.count,
                )
                RelatedCountCardView(
                    icon: Image(systemName: "car.fill"),
                    title: "Vehicles",
                    count: person.vehicles.count,
                )
                RelatedCountCardView(
                    icon: Image(systemName: "person.3.fill"),
                    title: "Species",
                    count: person.species.count,
                )
            }
        }
        .padding(EdgeInsets(
            top: 24,
            leading: 16,
            bottom: 32,
            trailing: 16,
        ))
    }
}

private struct StatItemView: View {
    let icon: Image
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            icon
                .font(.title3)
                .foregroundStyle(Color.app.brand)

            Text(value)
                .font(.headline.bold())
                .foregroundStyle(Color.app.primaryLabel)

            Text(title)
                .font(.caption)
                .foregroundStyle(Color.app.secondaryLabel)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title3.bold())
            .foregroundStyle(Color.app.primaryLabel)
    }
}

private struct DetailRowView: View {
    let icon: Image
    let label: String
    let value: String

    var body: some View {
        LabeledContent {
            Text(value)
                .foregroundStyle(Color.app.primaryLabel)
        } label: {
            HStack {
                icon
                    .foregroundStyle(Color.app.brand)
                    .frame(width: 24)

                Text(label)
                    .foregroundStyle(Color.app.secondaryLabel)
            }
        }
    }
}

private struct RelatedCountCardView: View {
    let icon: Image
    let title: String
    let count: Int

    var body: some View {
        VStack(spacing: 12) {
            icon
                .font(.title)
                .foregroundStyle(Color.app.brand)

            VStack(spacing: 4) {
                Text("\(count)")
                    .font(.title.bold())
                    .foregroundStyle(Color.app.primaryLabel)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.app.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.app.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#if DEBUG
    #Preview {
        PersonDetailView(person: .lukeSkywalker)
    }
#endif
