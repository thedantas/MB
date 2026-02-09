//
//  DateFormatter+.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

extension DateFormatter {
    nonisolated(unsafe) static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    nonisolated(unsafe) static let iso8601WithoutMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension DateFormatter {
    nonisolated static func parseISO8601(_ dateString: String) -> Date? {
        if let date = iso8601.date(from: dateString) {
            return date
        }
        
        if let date = iso8601WithoutMilliseconds.date(from: dateString) {
            return date
        }
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        return iso8601Formatter.date(from: dateString)
    }
}
