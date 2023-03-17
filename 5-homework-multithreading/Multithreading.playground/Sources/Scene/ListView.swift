import SwiftUI

public struct ListView: View {
    let viewModel: ProvidesImage
    
    public var body: some View {
        List {
            ForEach(0..<1000) { counter in
                HStack(spacing: 16) {
                    AsyncImage(named: "\(counter % 8)", provider: viewModel)
                    Text("Картинка №\(counter)")
                        .font(.body)
                }
                .frame(height: 48)
            }
        }
    }
    
    public init(viewModel: ProvidesImage) {
        self.viewModel = viewModel
    }
}
