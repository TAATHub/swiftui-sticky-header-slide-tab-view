import SwiftUI

struct SlideTabBarView: View {
    let tabBars: [(id: Int, title: String)]
    let color: Color
    
    @EnvironmentObject var viewModel: SlideTabBarViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(tabBars, id: \.id) { tabBar in
                    Button {
                        viewModel.selection = tabBar.id
                        viewModel.indicatorPosition = indicationPosition(size: geometry.size, selection: viewModel.selection)
                    } label: {
                        Text(tabBar.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(color)
                            .padding(8)
                    }
                }
            }
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size) { size in
                            // 画面回転などで画面サイズが変化した時に、インジケーター位置を調整する
                            viewModel.indicatorPosition = indicationPosition(size: size, selection: viewModel.selection)
                        }
                }
            }
            .overlay(alignment: .bottomLeading) {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(color)
                        .frame(width: tabBarIndicatorWidth(width: geometry.size.width))
                    Spacer()
                }
                .frame(width: tabBarWidth(width: geometry.size.width), height: 4)
                .offset(x: viewModel.indicatorPosition, y: 0)
            }
        }
    }
    
    private var tabBarCount: CGFloat {
        CGFloat(tabBars.count)
    }
    
    private func tabBarWidth(width: CGFloat) -> CGFloat {
        width / CGFloat(tabBars.count)
    }

    private func tabBarIndicatorWidth(width: CGFloat) -> CGFloat {
        width / CGFloat(tabBars.count)
    }
    
    private func indicationPosition(size: CGSize, selection: Int) -> CGFloat {
        return tabBarWidth(width: size.width) * CGFloat(selection)
    }
}

final class SlideTabBarViewModel: ObservableObject {
    @Published var selection: Int = 0
    @Published var indicatorPosition: CGFloat = 0
}
