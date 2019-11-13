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
}
