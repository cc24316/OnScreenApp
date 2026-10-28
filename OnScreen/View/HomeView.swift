import SwiftUI

struct HomeView: View {
    @State private var secao: Secao = .cinema

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    cabecalho
                    seletor
                    opcoes
                }
                .padding(24)
            }
            .background(Tema.fundo.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: RotaCarrossel.self) { rota in
                CarrosselView(rota: rota)
            }
            .navigationDestination(for: ItemRota.self) { rota in
                switch rota {
                case .filme(let filme):
                    DetalheFilmeView(filme: filme)
                }
            }
        }
    }

    private var cabecalho: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("OnScreen")
                .font(.system(size: 52, weight: .heavy, design: .default))
                .tracking(-1)
                .foregroundStyle(
                    LinearGradient(colors: [.white, Tema.quartzo], startPoint: .leading, endPoint: .trailing)
                )
        }
        .padding(.top, 24)
    }

    private var seletor: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(Secao.allCases) { item in
                    Button {
                        withAnimation(.snappy) { secao = item }
                    } label: {
                        Label(item.titulo, systemImage: item.icone)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                secao == item ? Tema.bordo : Tema.superficie,
                                in: Capsule()
                            )
                            .overlay(
                                Capsule().stroke(secao == item ? Tema.quartzo.opacity(0.7) : .clear, lineWidth: 1)
                            )
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var opcoes: some View {
        VStack(spacing: 12) {
            ForEach(secao.opcoes) { opcao in
                NavigationLink(value: RotaCarrossel(secao: secao, opcao: opcao)) {
                    HStack(spacing: 14) {
                        Rectangle()
                            .fill(Tema.bordo)
                            .frame(width: 4)
                        Text(opcao.titulo)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Tema.quartzo)
                            .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Tema.superficie, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
