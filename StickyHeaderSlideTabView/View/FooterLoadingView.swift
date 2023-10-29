import SwiftUI

struct FooterLoadingView: View {
    let isVisible: Bool
    let isLoading: Bool
    let onTask: () async -> Void

    init(isVisible: Bool, isLoading: Bool = true, onTask: @escaping () async -> Void) {
        self.isVisible = isVisible
        self.isLoading = isLoading
        self.onTask = onTask
    }

    var body: some View {
        Group {
            if isVisible {
                VStack(alignment: .center) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task {
                    await onTask()
                }
            } else {
                EmptyView()
            }
        }
    }
}
