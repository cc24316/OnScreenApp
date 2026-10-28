import Foundation
import Observation

@MainActor
@Observable
final class DetalheFilmeViewModel {
    var estado: EstadoCarga<FilmeDetalhe> = .carregando
    private let servico = TMDBService()
    private var iniciado = false

    func carregar(id: Int) async {
        guard !iniciado else { return }
        iniciado = true
        estado = .carregando
        do {
            estado = .sucesso(try await servico.detalheFilme(id: id))
        } catch {
            iniciado = false
            if ehCancelamento(error) { return }
            estado = .erro(error)
        }
    }
}
