import SwiftUI

struct CarrosselView: View {
    let rota: RotaCarrossel
    @State private var viewModel = CarrosselViewModel()

    var body: some View {
        Group {
            switch viewModel.estado {
            case .carregando:
                VStack(spacing: 12) {
                    ProgressView()
                        .controlSize(.large)
                    Text("Carregando…")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .erro(let erro):
                ErroView(erro: erro) {
                    Task { await viewModel.carregar(rota) }
                }
                .frame(maxHeight: .infinity)
            case .sucesso(let itens):
                if itens.isEmpty {
                    vazio
                } else {
                    carrossel(itens)
                }
            }
        }
        .navigationTitle(rota.opcao.titulo)
        .background(Tema.fundo.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.carregar(rota) }
    }

    private var vazio: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.system(size: 52))
                .foregroundStyle(Tema.quartzo)
            Text("Nada encontrado nesta categoria no momento")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func carrossel(_ itens: [CardItem]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(itens) { item in
                    NavigationLink(value: item.rota) {
                        CardView(item: item)
                            .containerRelativeFrame(.horizontal) { largura, _ in
                                largura * 0.75
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 24, for: .scrollContent)
        .scrollIndicators(.hidden)
        .frame(maxHeight: .infinity)
    }
}
