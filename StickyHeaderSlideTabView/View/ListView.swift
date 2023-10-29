import SwiftUI

struct ListView: View {
    @StateObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LazyVStack() {
            ForEach(viewModel.items, id: \.self) { item in
                viewModel.color
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .overlay {
                        Text("\(item)")
                    }
            }
            
            FooterLoadingView(isVisible: true) {
                await viewModel.onPageEnd()
            }
        }
    }
}

@MainActor
final class ListViewModel: ObservableObject {
    @Published private(set) var items: [String]
    
    let id: Int
    let color: Color
    let pageSize: Int
    
    init(id: Int, color: Color, pageSize: Int) {
        self.id = id
        self.color = color
        self.pageSize = pageSize
        self.items = []
        
        for _ in 0..<pageSize {
            self.items.append(UUID().uuidString)
        }
    }
    
    func onPageEnd() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        for _ in 0..<pageSize {
            items.append(UUID().uuidString)
        }
    }
}
