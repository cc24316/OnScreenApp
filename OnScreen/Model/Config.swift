import Foundation

enum Config {
    static let apiKey = ""
    static let baseURL = "https://api.themoviedb.org/3"
    static let imagemBase = "https://image.tmdb.org/t/p/w500"
    static let idioma = "pt-BR"
    static let regiao = "US"
    static let generoGuerra = 10752

    static func urlImagem(_ caminho: String?) -> URL? {
        guard let caminho else { return nil }
        return URL(string: imagemBase + caminho)
    }
}
