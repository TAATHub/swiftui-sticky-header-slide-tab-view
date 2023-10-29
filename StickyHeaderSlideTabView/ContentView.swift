import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SlideTabBarViewModel()
    @State private var offset: CGFloat = .zero
    
    private let headerHeight: CGFloat = 200
    private let slideTabBarHeight: CGFloat = 48
    
    let slideTabContents = [
        SlideTabContent(id: 0, title: "Page1", content: ListView(viewModel: ListViewModel(id: 0, color: .red, pageSize: 5))),
        SlideTabContent(id: 1, title: "Page2", content: ListView(viewModel: ListViewModel(id: 1, color: .green, pageSize: 3))),
        SlideTabContent(id: 2, title: "Page3", content: ListView(viewModel: ListViewModel(id: 2, color: .blue, pageSize: 10)))
    ]
    
    private var topAreaHeight: CGFloat {
        headerHeight + slideTabBarHeight
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                SlideTabView<ListView>(tabContents: slideTabContents, offset: $offset, topAreaHeight: topAreaHeight) { offset in
                    updateOffset(offset, safeAreaInsetsTop: proxy.safeAreaInsets.top)
                }
                
                VStack(alignment: .center, spacing: 0) {
                    Color.gray
                        .frame(maxWidth: .infinity)
                        .frame(height: headerHeight)
                    
                    SlideTabBarView(tabBars: [(id: 0, title: "Page1"),
                                              (id: 1, title: "Page2"),
                                              (id: 2, title: "Page3")],
                                    color: .black)
                    .background(Color.white)
                    .frame(height: slideTabBarHeight)
                }
                .offset(y: offset) // 取得したスクロール量でヘッダー部分を動かす
            }
            .ignoresSafeArea(edges: .bottom)
            .environmentObject(viewModel)
        }
    }

    // ヘッダーの動く範囲を決めて、sticky headerを実現する
    private func updateOffset(_ newOffset: CGFloat, safeAreaInsetsTop: CGFloat) {
        if newOffset <= -topAreaHeight + safeAreaInsetsTop {
            offset = -topAreaHeight + safeAreaInsetsTop
        } else if newOffset >= 0.0 {
            offset = 0
        } else {
            offset = newOffset
        }
    }
}

#Preview {
    ContentView()
}
