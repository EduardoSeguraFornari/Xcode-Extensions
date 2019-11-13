//
//  SourceEditorCommand.swift
//  Clear Closure
//
//  Created by Eduardo Fornari on 07/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        var updatedLineIndexes = [Int]()
        // 1. Find lines that contain a closure syntax
        for lineIndex in 0 ..< invocation.buffer.lines.count {
            let line = invocation.buffer.lines[lineIndex] as! String
            if let range = line.range(of: "\\{.*\\(.+\\).+in", options:.regularExpression) {
                // 2. When a closure is found, clean up its syntax
                let cleanLine = line.remove(characters: ["(", ")"], in: range)
                updatedLineIndexes.append(lineIndex)
                invocation.buffer.lines[lineIndex] = cleanLine
            }
        }
        // 3. If at least a line was changed, create an array of changes and pass it to the buffer selections
        if !updatedLineIndexes.isEmpty {
            invocation.updateLines(at: updatedLineIndexes)
        }
        completionHandler(nil)
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

}
