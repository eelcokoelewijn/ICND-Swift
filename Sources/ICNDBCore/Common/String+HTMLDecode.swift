import Foundation

public extension String {
    func htmlDecode() -> String {
        guard self != "" else { return self }
        var decodedString = self

        let htmlEntities = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">"
        ]

        for (entity, replacement) in htmlEntities {
            decodedString = decodedString.replacingOccurrences(of: entity, with: replacement)
        }
        return decodedString
    }
}
