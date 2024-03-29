import SwiftUI

struct SlideTabContent<Content: View>: Identifiable {
    var id: Int
    var title: String
    var content: Content
}

struct SlideTabView<Content: View>: View {
    @State var tabContents: [SlideTabContent<Content>]
    @Binding var offset: CGFloat
    @EnvironmentObject var viewModel: SlideTabBarViewModel
    
    let topAreaHeight: CGFloat
    let onChangeOffset: (CGFloat) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let safeAreaInsetsLeading = geometry.safeAreaInsets.leading
                
            TabView(selection: $viewModel.selection) {
                ForEach(tabContents) { tabContent in
                    // スクロール量を取得するViewでContentをラップする
                    OffsetReadableTabContentScrollView(tabType: tabContent.id, selection: viewModel.selection, onChangeOffset: onChangeOffset) {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: topAreaHeight)
                            
                            tabContent.content
                        }
                        
                        .tag(tabContent.id)
                        .overlay {
                            GeometryReader{ proxy in
                                Color.clear
                                    .onChange(of: proxy.frame(in: .global), perform: { value in
                                        // 表示中のタブをスワイプした時のみ処理する
                                        guard viewModel.selection == tabContent.id else { return }
                                        
                                        // 対象タブのスワイプ量をTabBarの比率に変換して、インジケーターのoffsetを計算する
                                        let offset = -(value.minX - safeAreaInsetsLeading - (screenWidth * CGFloat(viewModel.selection))) / tabCount
                                        
                                        if viewModel.selection == tabContents.first?.id {
                                            // 最初のタブの場合、offsetが0以上の時のみ位置を更新する
                                            if offset >= 0 {
                                                viewModel.indicatorPosition = offset
                                            } else {
                                                return
                                            }
                                        }
                                        
                                        if viewModel.selection == tabContents.last?.id {
                                            // 最後のタブの場合、offsetがscreenWidth以下の時のみ位置を更新する
                                            if offset + screenWidth/tabCount <= screenWidth {
                                                viewModel.indicatorPosition = offset
                                            } else {
                                                return
                                            }
                                        }
                                        
                                        viewModel.indicatorPosition = offset
                                    })
                            }
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    private var tabCount: CGFloat {
        CGFloat(tabContents.count)
    }
}
