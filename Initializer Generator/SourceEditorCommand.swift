//
//  SourceEditorCommand.swift
//  Initializer Generator
//
//  Created by Eduardo Fornari on 19/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        let lines = invocation.selectedLines?.filter({ line -> Bool in
            return !line.isEmpty
        })

        if let lines = lines {
            var properties: [String] = []
            for line in lines {
                if let property = line.property {
                    properties.append(property)
                }
            }

            let propertiesSet = properties.compactMap { property -> String? in
                if let propertyName = property.propertyName {
                    return "\t\tself.\(propertyName) = \(propertyName)"
                }
                return nil
            }.joined(separator: "\n")

            if properties.count == lines.count {
                let pp = properties.joined(separator: ", ")
                let initializer = """
                
                \tinit(\(pp)) {
                \(propertiesSet)
                \t}
                
                """
                print(initializer)
                
                guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
                    return
                }
                let lineIndex = selection.start.line
                
                invocation.buffer.lines.insert(initializer, at: lineIndex + properties.count)
//                invocation.insert(lines: initializer, at: 0)
            }
        }

        completionHandler(nil)
    }

}

extension String {
    var leftPropertyNameRegex: String {
        return "(public|private|internal)? *(private\\(set\\)|internal\\(set\\))? *(var|let) *"
    }

    var propertyRegex: String {
        return "(public|private|internal)? *(private\\(set\\)|internal\\(set\\))? *(var|let) *[0-9a-zA-Z]+ *\\:* *[0-9a-zA-Z_]+\\??"
    }

    var propertyNameRegex: String {
        return "[0-9a-zA-Z_]+"
    }

    var property: String? {
        var newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        newValue = newValue.withoutDoubleSpaces
        if let propertyRange = newValue.range(from: propertyRegex) {
            if newValue.startIndex == propertyRange.lowerBound && newValue.endIndex == propertyRange.upperBound {
                if let range = newValue.range(from: leftPropertyNameRegex) {
                    let property = newValue.removeSubstring(with: range)
                    let sides = property.split(separator: ":")
                    let leftSide = sides[0].trimmingCharacters(in: .whitespaces)
                    let rightSide = sides[1].trimmingCharacters(in: .whitespaces)
                    return leftSide + ": " + rightSide
                }
            }
        }
        return nil
    }

    var propertyName: String? {
        if let range = self.range(from: propertyNameRegex) {
            return self.substring(from: range)
        }
        return nil
    }
}

public extension XCSourceEditorCommandInvocation {
    func updateLines(at indexes: [Int]) {
        if !indexes.isEmpty {
            let updatedSelections: [XCSourceTextRange] = indexes.map { lineIndex in
                let lineSelection = XCSourceTextRange()
                lineSelection.start = XCSourceTextPosition(line: lineIndex, column: 0)
                lineSelection.end = XCSourceTextPosition(line: lineIndex, column: 0)
                return lineSelection
            }
            self.buffer.selections.setArray(updatedSelections)
        }
    }

    var selectedLines: [String]? {
        guard let selection = buffer.selections.firstObject as? XCSourceTextRange else {
            return nil
        }
        let selectedText: [String]
        if selection.start.line == selection.end.line {
            selectedText = [String(
                (buffer.lines[selection.start.line] as! String).utf8
                    .prefix(selection.end.column)
                    .dropFirst(selection.start.column)
                )!]
        } else {
            selectedText = [String((buffer.lines[selection.start.line] as! String).utf8.dropFirst(selection.start.column))!]
                + ((selection.start.line+1)..<selection.end.line).map { buffer.lines[$0] as! String }
                + [String((buffer.lines[selection.end.line] as! String).utf8.prefix(selection.end.column))!]
        }
        return selectedText
    }

}
