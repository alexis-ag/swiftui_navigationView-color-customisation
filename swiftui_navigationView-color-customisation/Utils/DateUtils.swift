import Foundation

enum DateFormat: String {
    case defaultDate = "dd/mm/yy"
    case defaultTime = "HH:mm:ss"
}

extension Date {
    func toString(as format: DateFormat, timezone: TimeZone? = nil) -> String {
        let formatter = DateFormatter()

        formatter.timeZone = timezone ?? TimeZone(secondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale

        formatter.dateFormat = format.rawValue

        return formatter.string(from: self)
    }

    func toString(as format: DateFormat, timezone: String) -> String {
        if let tzone = TimeZone(identifier: timezone) {
            return toString(as: format, timezone: tzone)
        }

        return toString(as: format)
    }
}

extension String {
    static let timeZoneRegex = "[+-]\\d{2}[:]\\d{2}"

    func asDate(format: DateFormat = DateFormat.defaultDate) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale
        guard let result = formatter.date(from: self) else {
            return nil
        }

        return result
    }

    var asDateIgnoreTimeZone: Date? {
        let dateStringIgnoringTimeZone =
                self.replacingOccurrences(of: String.timeZoneRegex, with: "", options: .regularExpression)
                        .replacingOccurrences(of: " AM", with: "")
                        .replacingOccurrences(of: " PM", with: "")
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = DateFormat.defaultDate.rawValue

        return formatter.date(from: dateStringIgnoringTimeZone)
    }
}