//
//  SourceEditorCommand.swift
//  Sort Import Declarations
//
//  Created by Eduardo Fornari on 11/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {

        var firstIndex: Int? = nil
        var lastIndex: Int? = nil
        for lineIndex in 0 ..< invocation.buffer.lines.count {
            let line = invocation.buffer.lines[lineIndex] as! String
            if line.isImport() && firstIndex == nil {
                firstIndex = lineIndex
            } else if line.isImport() {
                lastIndex = lineIndex
            } else if let indexA = firstIndex, let indexB = lastIndex {
                invocation.sortLines(from: indexA, to: indexB)
                firstIndex = nil
                lastIndex = nil
            }
        }

        if let firstIndex = firstIndex, let lastIndex = lastIndex {
            invocation.sortLines(from: firstIndex, to: lastIndex)
        }

        completionHandler(nil)
    }

}

extension String {
    func isImport() -> Bool {
        let swiftImport = "import "
        let objectiveCImport = "#import "
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newValue.starts(with: swiftImport) || newValue.starts(with: objectiveCImport)
    }
}

public extension XCSourceEditorCommandInvocation {
    func sortLines(from firstIndex: Int, to lastIndex: Int) {
        if firstIndex >= 0 && lastIndex < buffer.lines.count && firstIndex < lastIndex {
            let indexSet: IndexSet = [firstIndex, lastIndex]
            let linesSorted = indexSet.map({ buffer.lines[$0] as! String }).sorted()
            var updatedLineIndexes: [Int] = []
            var lineIndex = 0
            for indexToUpdate in firstIndex...lastIndex {
                updatedLineIndexes.append(indexToUpdate)
                self.buffer.lines[indexToUpdate] = linesSorted[lineIndex]
                lineIndex += 1
            }

            self.updateLines(at: updatedLineIndexes)
        }
    }

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

}
