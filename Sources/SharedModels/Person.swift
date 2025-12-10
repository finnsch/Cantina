import Foundation

public struct Person: Codable, Sendable, Identifiable, Equatable {
    public var id: String {
        url.lastPathComponent
    }

    public let name: String
    public let birthYear: String
    public let eyeColor: String
    public let gender: String
    public let hairColor: String
    public let height: String
    public let mass: String
    public let skinColor: String
    public let homeworld: String
    public let films: [URL]
    public let species: [URL]
    public let starships: [URL]
    public let vehicles: [URL]
    let url: URL

    public var imageUrl: URL? {
        let id = url.lastPathComponent
        return URL(
            string: "https://raw.githubusercontent.com/breatheco-de/swapi-images/master/public/images/people/\(id).jpg",
        )
    }

    public var formattedHeight: String {
        guard let centimeters = Double(height) else { return height }

        return Measurement(value: centimeters, unit: UnitLength.centimeters).formatted()
    }

    public var formattedMass: String {
        guard let kilograms = Double(mass) else { return mass }

        return Measurement(value: kilograms, unit: UnitMass.kilograms).formatted()
    }
}

public struct PeopleResponse: Codable, Sendable {
    public let next: URL?
    public let results: [Person]

    public init(next: URL? = nil, results: [Person]) {
        self.next = next
        self.results = results
    }
}

#if DEBUG
    public extension Person {
        static let lukeSkywalker = Person(
            name: "Luke Skywalker",
            birthYear: "19 BBY",
            eyeColor: "Blue",
            gender: "Male",
            hairColor: "Blond",
            height: "172",
            mass: "77",
            skinColor: "Fair",
            homeworld: "https://swapi.dev/api/planets/1/",
            films: [
                URL(string: "https://swapi.dev/api/films/1/")!,
                URL(string: "https://swapi.dev/api/films/2/")!,
                URL(string: "https://swapi.dev/api/films/3/")!,
                URL(string: "https://swapi.dev/api/films/6/")!,
            ],
            species: [
                URL(string: "https://swapi.dev/api/species/1/")!,
            ],
            starships: [
                URL(string: "https://swapi.dev/api/starships/12/")!,
                URL(string: "https://swapi.dev/api/starships/22/")!,
            ],
            vehicles: [
                URL(string: "https://swapi.dev/api/vehicles/14/")!,
                URL(string: "https://swapi.dev/api/vehicles/30/")!,
            ],
            url: URL(string: "https://swapi.dev/api/people/1/")!,
        )

        static var mocks: [Person] {
            [
                lukeSkywalker,
            ]
        }
    }
#endif
