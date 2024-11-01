import Foundation

extension DateFormatter {
    private static var dateFormatterCache: [String: DateFormatter] = [:]

    static func dateFormatter(withFormat format: String) -> DateFormatter {
        if let cachedFormatter = dateFormatterCache[format] {
            return cachedFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            dateFormatterCache[format] = formatter
            return formatter
        }
    }

    static var shortDate: DateFormatter {
        return dateFormatter(withFormat: "MM/dd/yy") // Adjust format as needed
    }

    static var longDate: DateFormatter {
        return dateFormatter(withFormat: "MMMM dd, yyyy") // Example for long date format
    }
}
