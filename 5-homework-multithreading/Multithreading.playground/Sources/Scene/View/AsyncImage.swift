import SwiftUI

public struct AsyncImage: View {
    private let named: String
    private let provider: ProvidesImage
    
    @State private var image: UIImage?
    
    public var body: some View {
        HStack(spacing: 16) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear {
                        provider.fetchImage(named: named) { image in
                            assert(
                                Thread.current == Thread.main,
                                "Main Thread Checker: UI API called on a background thread"
                            )
                            self.image = image
                        }
                    }
            }
        }
        .frame(width: 36, height: 36)
    }
    
    init(named: String, provider: ProvidesImage) {
        self.named = named
        self.provider = provider
    }
}
