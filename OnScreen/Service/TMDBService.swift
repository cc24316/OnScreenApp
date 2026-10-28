import Foundation

struct TMDBService: Sendable {
    private func buscar<T: Decodable & Sendable>(_ caminho: String, _ extras: [URLQueryItem] = []) async throws -> T {
        var componentes = URLComponents(string: Config.baseURL + caminho)
        var itens = [
            URLQueryItem(name: "api_key", value: Config.apiKey),
            URLQueryItem(name: "language", value: Config.idioma)
        ]
        itens.append(contentsOf: extras)
        componentes?.queryItems = itens
        guard let url = componentes?.url else { throw ErroApp.urlInvalida }
        let (dados, resposta) = try await URLSession.shared.data(from: url)
        guard let http = resposta as? HTTPURLResponse else { throw ErroApp.servidor }
        if http.statusCode == 401 { throw ErroApp.chaveInvalida }
        guard (200..<300).contains(http.statusCode) else { throw ErroApp.servidor }
        do {
            return try JSONDecoder().decode(T.self, from: dados)
        } catch {
            throw ErroApp.decodificacao
        }
    }

    private func seguros(_ filmes: [Filme], exigirPoster: Bool = true) -> [Filme] {
        filmes.filter {
            $0.adult != true
                && ($0.posterPath != nil || !exigirPoster)
                && !($0.genreIds ?? []).contains(Config.generoGuerra)
        }
    }

    private func descobrir(_ extras: [URLQueryItem], exigirPoster: Bool = true) async throws -> [Filme] {
        var itens = [
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "without_genres", value: "\(Config.generoGuerra)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        itens.append(contentsOf: extras)
        let pagina: Pagina<Filme> = try await buscar("/discover/movie", itens)
        return seguros(pagina.results, exigirPoster: exigirPoster)
    }

    func filmes(opcao: String) async throws -> [Filme] {
        switch opcao {
        case "alta":
            let pagina: Pagina<Filme> = try await buscar("/trending/movie/day")
            return seguros(pagina.results)
        case "melhores":
            let pagina: Pagina<Filme> = try await buscar("/movie/top_rated", regiao)
            return seguros(pagina.results)
        case "estreias":
            let pagina: Pagina<Filme> = try await buscar("/movie/upcoming", regiao)
            return seguros(pagina.results)
        case "esperados":
            return try await descobrir([
                URLQueryItem(name: "region", value: Config.regiao),
                URLQueryItem(name: "primary_release_date.gte", value: Datas.texto(diasAPartirDeHoje: 1)),
                URLQueryItem(name: "primary_release_date.lte", value: Datas.texto(diasAPartirDeHoje: 365))
            ])
        case "desenvolvimento":
            return try await emDesenvolvimento()
        default:
            let pagina: Pagina<Filme> = try await buscar("/movie/now_playing", regiao)
            return seguros(pagina.results)
        }
    }

    private var regiao: [URLQueryItem] {
        [URLQueryItem(name: "region", value: Config.regiao)]
    }

    private func emDesenvolvimento() async throws -> [Filme] {
        let candidatos = try await descobrir([
            URLQueryItem(name: "primary_release_date.gte", value: Datas.texto(diasAPartirDeHoje: 90)),
            URLQueryItem(name: "primary_release_date.lte", value: Datas.texto(diasAPartirDeHoje: 1095))
        ], exigirPoster: false)
        let escolhidos = Array(candidatos.prefix(15))
        let situacoes: [String?] = try await withThrowingTaskGroup(of: (Int, String?).self) { grupo in
            for (indice, filme) in escolhidos.enumerated() {
                grupo.addTask {
                    let detalhe: FilmeDetalhe = try await self.buscar("/movie/\(filme.id)")
                    return (indice, detalhe.status)
                }
            }
            var acumulado: [(Int, String?)] = []
            for try await item in grupo {
                acumulado.append(item)
            }
            return acumulado.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
        let validos: Set<String> = ["In Production", "Post Production", "Planned"]
        return zip(escolhidos, situacoes).filter { validos.contains($0.1 ?? "") }.map { $0.0 }
    }

    func filmesPorGenero(_ genero: Genero?) async throws -> [Filme] {
        var extras = [
            URLQueryItem(name: "vote_count.gte", value: "200"),
            URLQueryItem(name: "certification_country", value: Config.regiao),
            URLQueryItem(name: "certification.lte", value: "PG-13")
        ]
        if let genero {
            extras.append(URLQueryItem(name: "with_genres", value: "\(genero.id)"))
        }
        return try await descobrir(extras)
    }

    func detalheFilme(id: Int) async throws -> FilmeDetalhe {
        try await buscar("/movie/\(id)", [URLQueryItem(name: "append_to_response", value: "credits")])
    }
}
