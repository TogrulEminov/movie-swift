
import Foundation

enum TMDBImageURL {
    static func make(path: String?, size: TMDBImageSize) -> URL? {
        guard let path, !path.isEmpty else {
            return nil
        }
        let urlString = "\(APIConfig.imageBaseUrl)/\(size.rawValue)\(path)"
        return URL(string: urlString)
    }
}
