import SwiftUI

struct DetalheFilmeView: View {
    let filme: Filme
    @State private var viewModel = DetalheFilmeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                MoldeImagem(caminho: filme.posterPath)
                    .frame(maxWidth: 320)
                    .frame(maxWidth: .infinity)
                    .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
                Text(filme.title)
                    .font(.largeTitle.bold())
                switch viewModel.estado {
                case .carregando:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                case .erro(let erro):
                    ErroView(erro: erro) {
                        Task { await viewModel.carregar(id: filme.id) }
                    }
                case .sucesso(let detalhe):
                    conteudo(detalhe)
                }
            }
            .padding(24)
        }
        .background(Tema.fundo.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.carregar(id: filme.id) }
    }

    @ViewBuilder
    private func conteudo(_ detalhe: FilmeDetalhe) -> some View {
        metadados(detalhe)
        if let situacao = detalhe.statusTexto {
            chip(situacao, destaque: true)
        }
        generos(detalhe)
        bloco("Sinopse") {
            Text((detalhe.overview ?? "").isEmpty ? "Sinopse não disponível em português" : detalhe.overview ?? "")
        }
        if let diretor = detalhe.credits?.crew.first(where: { $0.job == "Director" }) {
            bloco("Direção") {
                Text(diretor.name)
            }
        }
        elenco(detalhe)
    }

    private func metadados(_ detalhe: FilmeDetalhe) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 16) {
                if let nota = detalhe.voteAverage, nota > 0 {
                    Label(String(format: "%.1f", nota), systemImage: "star.fill")
                        .foregroundStyle(Tema.quartzo)
                } else {
                    Label("Sem nota ainda", systemImage: "star")
                        .foregroundStyle(.secondary)
                }
                if let minutos = detalhe.runtime, minutos > 0 {
                    Label("\(minutos / 60)h \(minutos % 60)min", systemImage: "clock")
                }
                if let data = detalhe.releaseDate, data.count >= 4 {
                    Label(String(data.prefix(4)), systemImage: "calendar")
                }
            }
            .font(.subheadline.weight(.semibold))
            Text("Nota do público (TMDB)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func generos(_ detalhe: FilmeDetalhe) -> some View {
        if let lista = detalhe.genres, !lista.isEmpty {
            bloco("Gêneros") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(lista) { chip($0.name, destaque: false) }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private func chip(_ texto: String, destaque: Bool) -> some View {
        Text(texto)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(destaque ? Tema.bordo : Color.white.opacity(0.12), in: Capsule())
    }

    @ViewBuilder
    private func elenco(_ detalhe: FilmeDetalhe) -> some View {
        let atores = Array((detalhe.credits?.cast ?? []).prefix(8))
        if !atores.isEmpty {
            bloco("Elenco") {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(atores.enumerated()), id: \.offset) { _, ator in
                        HStack {
                            Text(ator.name).fontWeight(.semibold)
                            if let personagem = ator.character, !personagem.isEmpty {
                                Text("como \(personagem)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
    }

    private func bloco<Conteudo: View>(_ titulo: String, @ViewBuilder _ conteudo: () -> Conteudo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo).font(.headline)
            conteudo()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
