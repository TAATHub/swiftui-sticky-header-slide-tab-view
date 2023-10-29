import SwiftUI

struct OffsetReadableVerticalScrollView<Content: View>: View {
    private struct CoordinateSpaceName: Hashable {}

    private let showsIndicators: Bool
    private let onChangeOffset: (CGFloat) -> Void
    private let content: () -> Content

    public init(
        showsIndicators: Bool = true,
        onChangeOffset: @escaping (CGFloat) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.onChangeOffset = onChangeOffset
        self.content = content
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            ZStack(alignment: .top) {
                GeometryReader { geometryProxy in
                    Color.clear.preference(
                        key: ScrollViewOffsetYPreferenceKey.self,
                        value: geometryProxy.frame(in: .named(CoordinateSpaceName())).minY
                    )
                }
                .frame(width: 1, height: 1)
                content()
            }
        }
        .coordinateSpace(name: CoordinateSpaceName())
        .onPreferenceChange(ScrollViewOffsetYPreferenceKey.self) { offset in
            onChangeOffset(offset)
        }
    }
}

struct ScrollViewOffsetYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
