import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () async -> Void
    var body: some View {
        ContentUnavailableView {
            Label(
                "Something went wrong",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task {
                    await retryAction()
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}
