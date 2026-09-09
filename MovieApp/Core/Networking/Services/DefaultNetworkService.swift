import Foundation

final class DefaultNetworkService: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T>(_ endpoint: any Endpoint) async throws -> T
    where T: Decodable {
        do {
            let request = try endpoint.makeRequest()
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(
                    statusCode: httpResponse.statusCode
                )
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch is CancellationError {
            throw CancellationError()
        } catch let urlErr as URLError where urlErr.code == .cancelled {
            throw CancellationError()
        } catch let networkErr as NetworkError {
            throw networkErr
        } catch {
            throw NetworkError.unknown(error)
        }
    }

}
