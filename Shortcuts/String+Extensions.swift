//
//  String+Extensions.swift
//  Shortcuts
//
//  Created by Eduardo Fornari on 04/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import Foundation

public extension String {
    func remove(characters: [Character], in range: Range<String.Index>) -> String {
        var cleanString = self
        for char in characters {
            cleanString = cleanString.replacingOccurrences(of: String(char), with: "",
                                                           options: .caseInsensitive,
                                                           range: range)
        }
        return cleanString
    }

    func contains(regex: String) -> Bool {
        return (self.range(of: regex, options:.regularExpression) != nil) ? true : false
    }

    var leftWhiteSpace: String {
        if let range = self.range(of: "[0-9a-zA-Z]\\w+", options:.regularExpression) {
            let indexDistance = distance(from: startIndex, to: range.lowerBound)
            let end = index(startIndex, offsetBy: indexDistance)
            let range = startIndex..<index(before: end)
            return String(self[range])
        }
        return ""
    }

    var withoutDoubleSpaces: String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func range(from regularExpression: String) -> Range<String.Index>? {
        return range(of: regularExpression, options:.regularExpression)
    }

    func removeSubstring(with range: Range<String.Index>) -> String {
        if !(startIndex <= range.lowerBound && endIndex >= range.upperBound) {
            return self
        }

        var distance = self.distance(from: startIndex, to: range.lowerBound)
        let rangeStartIndex = index(startIndex, offsetBy: distance)
        let leftSide = String(self[startIndex..<rangeStartIndex])

        distance = self.distance(from: startIndex, to: range.upperBound)
        let rangeEndIndex = index(startIndex, offsetBy: distance)
        let rightSide = String(self[rangeEndIndex..<endIndex])

        return leftSide + rightSide
    }

    func substring(from range: Range<String.Index>) -> String {
        if !(startIndex <= range.lowerBound && endIndex >= range.upperBound) {
            return ""
        }

        var distance = self.distance(from: startIndex, to: range.lowerBound)
        let rangeStartIndex = index(startIndex, offsetBy: distance)

        distance = self.distance(from: startIndex, to: range.upperBound)
        distance = distance - 1
        if distance < 0 {
            distance = 0
        }
        let rangeEndIndex = index(startIndex, offsetBy: distance)

        return String(self[rangeStartIndex...rangeEndIndex])
    }

}
