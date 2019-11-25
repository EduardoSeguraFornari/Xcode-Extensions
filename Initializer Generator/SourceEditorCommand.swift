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
            return !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
            }
        }

        completionHandler(nil)
    }

}

extension String {
    var singlePropertyWithTypeDefinitionRegex: String {
        return "(public|open|private|internal)? *((private|internal)\\(set\\))? *(var|let) *[a-zA-Z_][0-9a-zA-Z_]* *: *[a-zA-Z_][0-9a-zA-Z_]*( *= *(\".*\"|true|false|[0-9]+(_[0-9]+)*(\\.[0-9]+(_[0-9]+)*)?|\\.[a-zA-Z_][0-9a-zA-Z_]*|[a-zA-Z_][0-9a-zA-Z_]*\\(.*\\)))?"
    }

    var propertyRegex: String {
        return "[a-zA-Z_][0-9a-zA-Z_]* *: *[a-zA-Z_][0-9a-zA-Z_]*"
    }

    var propertyNameRegex: String {
        return "[a-zA-Z_][0-9a-zA-Z_]*"
    }

    var isSinglePropertyWithOnlyTypeDefinition: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: singlePropertyWithTypeDefinitionRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var property: String? {
        if self.isSinglePropertyWithOnlyTypeDefinition {
            if let range = self.range(from: propertyRegex) {
                return self.substring(from: range)
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
