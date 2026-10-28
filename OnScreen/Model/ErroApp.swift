import Foundation

enum ErroApp: Error {
    case urlInvalida
    case chaveInvalida
    case servidor
    case decodificacao
}

enum EstadoCarga<Valor> {
    case carregando
    case sucesso(Valor)
    case erro(Error)
}

func ehCancelamento(_ erro: Error) -> Bool {
    if erro is CancellationError { return true }
    if let urlErro = erro as? URLError, urlErro.code == .cancelled { return true }
    return false
}
