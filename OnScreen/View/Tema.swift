import SwiftUI

enum Tema {
    static let bordo = Color(red: 0.43, green: 0.06, blue: 0.11)
    static let bordoEscuro = Color(red: 0.22, green: 0.03, blue: 0.07)
    static let quartzo = Color(red: 0.89, green: 0.71, blue: 0.69)
    static let preto = Color(red: 0.045, green: 0.045, blue: 0.05)
    static let superficie = Color.white.opacity(0.07)

    static let fundo = LinearGradient(
        colors: [bordoEscuro, preto],
        startPoint: .top,
        endPoint: .center
    )
}
