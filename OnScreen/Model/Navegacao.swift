import Foundation

struct Opcao: Hashable, Identifiable {
    let id: String
    let titulo: String
}

enum Catalogo {
    static let generos: [String: Genero] = [
        "acao": Genero(id: 28, name: "Ação"),
        "comedia": Genero(id: 35, name: "Comédia"),
        "drama": Genero(id: 18, name: "Drama"),
        "terror": Genero(id: 27, name: "Terror"),
        "ficcao": Genero(id: 878, name: "Ficção científica")
    ]
}

enum Secao: String, CaseIterable, Identifiable, Hashable {
    case cinema, hollywood, generos

    var id: String { rawValue }

    var titulo: String {
        switch self {
        case .cinema: return "Cinema"
        case .hollywood: return "Hollywood"
        case .generos: return "Gêneros"
        }
    }

    var icone: String {
        switch self {
        case .cinema: return "film"
        case .hollywood: return "sparkles"
        case .generos: return "theatermasks"
        }
    }

    var opcoes: [Opcao] {
        switch self {
        case .cinema:
            return [
                Opcao(id: "cartaz", titulo: "Em cartaz"),
                Opcao(id: "alta", titulo: "Em alta"),
                Opcao(id: "melhores", titulo: "Mais bem avaliados")
            ]
        case .hollywood:
            return [
                Opcao(id: "estreias", titulo: "Estreias e premieres"),
                Opcao(id: "esperados", titulo: "Mais esperados"),
                Opcao(id: "desenvolvimento", titulo: "Em desenvolvimento")
            ]
        case .generos:
            return [
                Opcao(id: "acao", titulo: "Ação"),
                Opcao(id: "comedia", titulo: "Comédia"),
                Opcao(id: "drama", titulo: "Drama"),
                Opcao(id: "terror", titulo: "Terror"),
                Opcao(id: "ficcao", titulo: "Ficção"),
            ]
        }
    }
}

struct RotaCarrossel: Hashable {
    let secao: Secao
    let opcao: Opcao
}

enum ItemRota: Hashable {
    case filme(Filme)
}

struct CardItem: Identifiable, Hashable {
    let id: String
    let titulo: String
    let subtitulo: String?
    let imagemPath: String?
    let rota: ItemRota
}

enum Datas {
    static func texto(diasAPartirDeHoje dias: Int) -> String {
        let formatador = DateFormatter()
        formatador.locale = Locale(identifier: "en_US_POSIX")
        formatador.dateFormat = "yyyy-MM-dd"
        let data = Calendar.current.date(byAdding: .day, value: dias, to: Date()) ?? Date()
        return formatador.string(from: data)
    }
}
