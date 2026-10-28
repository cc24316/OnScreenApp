import Foundation

struct Pagina<Item: Decodable & Sendable>: Decodable, Sendable {
    let results: [Item]
}

struct Genero: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
}

struct Filme: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let genreIds: [Int]?
    let adult: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }

    var ano: String {
        guard let releaseDate, releaseDate.count >= 4 else { return "" }
        return String(releaseDate.prefix(4))
    }
}

struct Pessoa: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let profilePath: String?
    let knownForDepartment: String?
    let adult: Bool?
    let character: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id, name, adult, character, job
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
    }
}

struct Creditos: Codable, Hashable, Sendable {
    let cast: [Pessoa]
    let crew: [Pessoa]
}

struct FilmeDetalhe: Codable, Hashable, Sendable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genero]?
    let credits: Creditos?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits, status
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }

    var statusTexto: String? {
        switch status {
        case "Planned": return "Planejado"
        case "In Production": return "Em produção"
        case "Post Production": return "Pós-produção"
        case "Canceled": return "Cancelado"
        default: return nil
        }
    }
}
