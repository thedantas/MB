//
//  DateFormatter+.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

extension DateFormatter {
    // These formatters are nonisolated to allow use in background contexts (e.g., DTO decoding)
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
    /// Parse ISO8601 date string with multiple format support
    /// This method is nonisolated to allow use in background contexts (e.g., DTO decoding)
    nonisolated static func parseISO8601(_ dateString: String) -> Date? {
        // Try with milliseconds and Z
        if let date = iso8601.date(from: dateString) {
            return date
        }
        
        // Try without milliseconds but with Z
        if let date = iso8601WithoutMilliseconds.date(from: dateString) {
            return date
        }
        
        // Try with ISO8601DateFormatter as fallback
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        
        // Try without fractional seconds
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        return iso8601Formatter.date(from: dateString)
    }
}
