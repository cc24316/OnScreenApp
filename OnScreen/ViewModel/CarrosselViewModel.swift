import Foundation
import Observation

@MainActor
@Observable
final class CarrosselViewModel {
    var estado: EstadoCarga<[CardItem]> = .carregando
    private let servico = TMDBService()
    private var iniciado = false

    func carregar(_ rota: RotaCarrossel) async {
        guard !iniciado else { return }
        iniciado = true
        estado = .carregando
        do {
            estado = .sucesso(try await montar(rota))
        } catch {
            iniciado = false
            if ehCancelamento(error) { return }
            estado = .erro(error)
        }
    }

    private func montar(_ rota: RotaCarrossel) async throws -> [CardItem] {
        let opcao = rota.opcao.id
        switch rota.secao {
        case .cinema, .hollywood:
            return Self.cartoes(try await servico.filmes(opcao: opcao))
        case .generos:
            return Self.cartoes(try await servico.filmesPorGenero(Catalogo.generos[opcao]))
        }
    }

    private static func cartoes(_ filmes: [Filme]) -> [CardItem] {
        filmes.prefix(5).map {
            CardItem(
                id: "f\($0.id)",
                titulo: $0.title,
                subtitulo: $0.ano.isEmpty ? nil : $0.ano,
                imagemPath: $0.posterPath,
                rota: .filme($0)
            )
        }
    }
}
