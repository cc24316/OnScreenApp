import SwiftUI

struct ErroView: View {
    let erro: Error
    let acao: () -> Void

    private var semInternet: Bool { erro is URLError }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: semInternet ? "wifi.slash" : "exclamationmark.triangle")
                .font(.system(size: 52))
                .foregroundStyle(Tema.quartzo)
            Text(semInternet ? "Sem internet" : "Algo deu errado")
                .font(.title2.bold())
            Text(semInternet
                 ? "Verifique sua rede e tente novamente."
                 : "Não foi possível carregar. Tente novamente.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Tentar novamente", action: acao)
                .buttonStyle(.borderedProminent)
                .tint(Tema.bordo)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
    }
}
