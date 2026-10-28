import SwiftUI

struct CardView: View {
    let item: CardItem

    var body: some View {
        MoldeImagem(caminho: item.imagemPath)
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.titulo)
                        .font(.title3.bold())
                        .lineLimit(2)
                    if let subtitulo = item.subtitulo {
                        Text(subtitulo)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .foregroundStyle(.white)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .shadow(color: .black.opacity(0.4), radius: 12, y: 6)
    }
}
