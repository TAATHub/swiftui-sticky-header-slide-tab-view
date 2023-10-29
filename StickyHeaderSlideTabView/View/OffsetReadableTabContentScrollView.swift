import SwiftUI

struct OffsetReadableTabContentScrollView<TabType: Hashable, Content: View>: View {
    let tabType: TabType
    var selection: TabType
    let onChangeOffset: (CGFloat) -> Void
    let content: () -> Content

    @State private var currentOffset: CGFloat = .zero

    public var body: some View {
        OffsetReadableVerticalScrollView(
            onChangeOffset: { offset in
                currentOffset = offset
                if tabType == selection {
                    onChangeOffset(offset)
                }
            },
            content: content
        )
        .onChange(of: selection) { selection in
            if tabType == selection {
                onChangeOffset(currentOffset)
            }
        }
    }
}
