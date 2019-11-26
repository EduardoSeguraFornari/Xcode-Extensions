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
    var spaceRegex: String {
        return "( |\t)*"
    }

    var propertyNameRegex: String {
        return "[a-zA-Z_][0-9a-zA-Z_]*"
    }

    var propertyPrefixRegex: String {
        return "(public|open|private|internal)?\(spaceRegex)((private|internal)\\(set\\))?\(spaceRegex)(var|let)\(spaceRegex)\(propertyNameRegex)"
    }

    // String
    var stringRegex: String {
        return "\".*\""
    }

    var isStringPropertyRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)\(stringRegex)"
    }

    var stringPropertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(stringRegex)"
    }

    var isStringProperty: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: isStringPropertyRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var stringProperty: String? {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newValue.isStringProperty {
            if let range = self.range(from: stringPropertyRegex) {
                let property =  self.substring(from: range)
                if let name = property.propertyName {
                    return name + ": String"
                }
            }
        }
        return nil
    }

    // Bool
    var boolRegex: String {
        return "(true|false)"
    }

    var isBoolPropertyRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)\(boolRegex)"
    }

    var boolPropertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(boolRegex)"
    }

    var isBoolProperty: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: isBoolPropertyRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var boolProperty: String? {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newValue.isBoolProperty {
            if let range = self.range(from: boolPropertyRegex) {
                let property =  self.substring(from: range)
                if let name = property.propertyName {
                    return name + ": Bool"
                }
            }
        }
        return nil
    }

    // Int
    var intRegex: String {
        return "[0-9]+(_[0-9]|[0-9])*"
    }

    var isIntPropertyRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)\(intRegex)"
    }

    var intPropertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(intRegex)"
    }

    var isIntProperty: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: isIntPropertyRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var intProperty: String? {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newValue.isIntProperty {
            if let range = self.range(from: intPropertyRegex) {
                let property =  self.substring(from: range)
                if let name = property.propertyName {
                    return name + ": Int"
                }
            }
        }
        return nil
    }

    // Double
    var doubleRegex: String {
        return "\(intRegex).\(intRegex)"
    }

    var isDoublePropertyRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)\(doubleRegex)"
    }

    var doublePropertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(doubleRegex)"
    }

    var isDoubleProperty: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: isDoublePropertyRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var doubleProperty: String? {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newValue.isDoubleProperty {
            if let range = self.range(from: doublePropertyRegex) {
                let property =  self.substring(from: range)
                if let name = property.propertyName {
                    return name + ": Double"
                }
            }
        }
        return nil
    }

    // Enum
    var enumRegex: String {
        return ".[a-zA-Z_][0-9a-zA-Z_]*"
    }

    // Custom Object
    var customObjectRegex: String {
        return "[a-zA-Z_][0-9a-zA-Z_]*"
    }

    var customObjectInitializedRegex: String {
        return "\(customObjectRegex)\\(.*\\)"
    }

    var customObjectWithoutInitRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(customObjectRegex)"
    }

    var isCustomObjectPropertyRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)\(customObjectInitializedRegex)"
    }

    var customObjectPropertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex)=\(spaceRegex)\(customObjectInitializedRegex)"
    }

    var isCustomObjectProperty: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: isCustomObjectPropertyRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var customObjectProperty: String? {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newValue.isCustomObjectProperty {
            if let range = self.range(from: customObjectPropertyRegex) {
                let property =  self.substring(from: range)
                if let range = property.range(from: customObjectWithoutInitRegex) {
                    return property.substring(from: range).replacingOccurrences(of: "=", with: ":")
                }
            }
        }
        return nil
    }

    var singlePropertyWithTypeDefinitionRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex):\(spaceRegex)\(customObjectRegex)(\(spaceRegex)=\(spaceRegex)(\(stringRegex)|\(boolRegex)|\(doubleRegex)|\(intRegex)|\(customObjectInitializedRegex)))?"
    }

    var singlePropertyWithOnlyValueDefinitionRegex: String {
        return "\(propertyPrefixRegex)\(spaceRegex)=\(spaceRegex)(\(stringRegex)|\(boolRegex)|\(doubleRegex)|\(intRegex)|\(customObjectInitializedRegex))"
    }

    var propertyRegex: String {
        return "\(propertyNameRegex)\(spaceRegex):\(spaceRegex)\(customObjectRegex)"
    }

    var isSinglePropertyWithOnlyTypeDefinition: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: singlePropertyWithTypeDefinitionRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }

    var isSinglePropertyWithOnlyValueDefinition: Bool {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = newValue.range(from: singlePropertyWithOnlyValueDefinitionRegex) {
            return newValue.startIndex == range.lowerBound && newValue.endIndex == range.upperBound
        }
        return false
    }


    var property: String? {
        if self.isSinglePropertyWithOnlyTypeDefinition {
            if let range = self.range(from: propertyRegex) {
                return self.substring(from: range)
            }
        } else if self.isSinglePropertyWithOnlyValueDefinition {
            if let property = self.stringProperty {
                return property
            } else if let property = self.boolProperty {
                return property
            } else if let property = self.intProperty {
                return property
            } else if let property = self.doubleProperty {
                return property
            } else if let property = self.customObjectProperty {
                return property
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
