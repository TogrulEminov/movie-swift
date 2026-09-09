import Foundation

enum MockNetworkError: LocalizedError {
    case forcedFailure
    case unsupportedEndpoint
    case invalidResponseType

    var errorDescription: String? {
        switch self {
        case .forcedFailure:
            return "The preview request failed."

        case .unsupportedEndpoint:
            return "This endpoint is not supported by the mock service."

        case .invalidResponseType:
            return "The mock response type is incorrect."
        }
    }
}
