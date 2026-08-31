import SwiftUI

@main
struct CharworkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .shareApp("https://charwork.heyitsmejosh.com")
        }
        // ponytail: sized for the default 100x50 grid at the default font size. On iOS
        // it is a no-op, so no #if is needed.
        .defaultSize(width: 1000, height: 760)
    }
}

// MARK: - Share

// ponytail: one overlay rather than a per-screen toolbar button — these root views share no
// navigation container to hang a .toolbar on. Move it into a toolbar per screen if this ever
// covers something that matters.
private struct AppShareOverlay: ViewModifier {
    let link: String

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottomTrailing) {
            if let url = URL(string: link) {
                ShareLink(item: url) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .medium))
                        .padding(10)
                        .background(.regularMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .padding(16)
            }
        }
    }
}

private extension View {
    func shareApp(_ link: String) -> some View { modifier(AppShareOverlay(link: link)) }
}
