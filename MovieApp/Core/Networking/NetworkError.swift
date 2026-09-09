import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(statusCode: Int)
    case decodingError
    case encodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is incorrect."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .unauthorized:
            return "The API token is invalid, or you do not have permission."

        case .serverError(let statusCode):
            return "A server error occurred. Status code: \(statusCode)"

        case .decodingError:
            return "The data received from the server could not be decoded."
        case .encodingError:
            return "The data to be sent could not be encoded."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
