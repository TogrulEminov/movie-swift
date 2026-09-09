import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var httpBody: (any Encodable)? { get }
}

extension Endpoint {
    var baseURL: String {
        return APIConfig.baseUrl
    }
    var method: HttpMethod {
        return .get
    }

    var headers: [String: String]? {
        [
            HTTPHeader.authorization: "Bearer \(APIConfig.accessToken)",
            HTTPHeader.contentType: ContentType.applicationJson,
        ]
    }

    var queryItems: [URLQueryItem]? {
        nil
    }
    var httpBody: (any Encodable)? {
        nil
    }
}

extension Endpoint {
    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        components.path += path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let httpBody {
            do {
                request.httpBody = try JSONEncoder().encode(httpBody)
            } catch {
                throw NetworkError.encodingError
            }
        }
        return request
    }
}
