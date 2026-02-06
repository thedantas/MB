//
//  MarkdownFormatter.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

struct MarkdownFormatter {
    
    /// Converts markdown text to NSAttributedString with proper styling
    static func attributedString(from markdown: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        
        // Split by paragraphs (handle both \n\n and single \n)
        var paragraphs = markdown.components(separatedBy: "\n\n")
        if paragraphs.count == 1 {
            paragraphs = markdown.components(separatedBy: "\n")
        }
        
        for (index, paragraph) in paragraphs.enumerated() {
            let trimmed = paragraph.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                let attributedParagraph = formatParagraphWithMarkdown(trimmed)
                
                mutableString.append(attributedParagraph)
                
                if index < paragraphs.count - 1 {
                    mutableString.append(NSAttributedString(string: "\n\n", attributes: [
                        .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                        .foregroundColor: UIColor.label
                    ]))
                }
            }
        }
        
        return mutableString
    }
    
    /// Formats a paragraph with markdown processing and proper styling
    private static func formatParagraphWithMarkdown(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = DSTheme.Spacing.xs + DSTheme.Spacing.xs
        paragraphStyle.paragraphSpacing = DSTheme.Spacing.xs
        paragraphStyle.alignment = .left
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: DSTypography.body(),
            .foregroundColor: DSColor.textPrimary,
            .paragraphStyle: paragraphStyle
        ]
        
        // Clean markdown syntax
        var cleaned = text
        
        // Remove markdown headers (##, ###, etc.)
        cleaned = cleaned.replacingOccurrences(
            of: #"^#{1,6}\s+"#,
            with: "",
            options: [.regularExpression, .anchored]
        )
        
        // Remove markdown links: [text](url) -> text
        cleaned = cleaned.replacingOccurrences(
            of: #"\[([^\]]+)\]\([^\)]+\)"#,
            with: "$1",
            options: .regularExpression
        )
        
        // Remove markdown bold markers: **text** -> text (we'll keep it as regular text for simplicity)
        cleaned = cleaned.replacingOccurrences(
            of: #"\*\*([^\*]+)\*\*"#,
            with: "$1",
            options: .regularExpression
        )
        
        // Remove markdown italic markers: *text* -> text
        cleaned = cleaned.replacingOccurrences(
            of: #"(?<!\*)\*([^\*]+)\*(?!\*)"#,
            with: "$1",
            options: .regularExpression
        )
        
        // Clean up multiple spaces
        cleaned = cleaned.replacingOccurrences(
            of: #"\s+"#,
            with: " ",
            options: .regularExpression
        )
        
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return NSAttributedString(string: cleaned, attributes: baseAttributes)
    }
}
