import SwiftUI

struct ImagemRemota: View {
    let url: URL?

    var body: some View {
        if let url {
            AsyncImage(url: url) { fase in
                switch fase {
                case .empty:
                    ProgressView()
                case .success(let imagem):
                    imagem
                        .resizable()
                        .scaledToFill()
                case .failure:
                    iconeErro
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            iconeErro
        }
    }

    private var iconeErro: some View {
        Image(systemName: "photo.badge.exclamationmark")
            .font(.largeTitle)
            .foregroundStyle(.secondary)
    }
}

struct MoldeImagem: View {
    let caminho: String?
    var proporcao: CGFloat = 2.0 / 3.0
    var raio: CGFloat = 24

    var body: some View {
        Color.white.opacity(0.08)
            .aspectRatio(proporcao, contentMode: .fit)
            .overlay { ImagemRemota(url: Config.urlImagem(caminho)) }
            .clipShape(RoundedRectangle(cornerRadius: raio, style: .continuous))
    }
}
