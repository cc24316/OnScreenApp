import SwiftUI

@main
struct OnScreenApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark)
                .tint(Tema.quartzo)
        }
    }
}
