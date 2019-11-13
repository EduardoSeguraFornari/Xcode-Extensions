//
//  SourceEditorCommand.swift
//  Print only in Debug
//
//  Created by Eduardo Fornari on 04/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    private let ifDebug = "#if debug"
    private let endIf = "#endif"

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        var updatedLineIndexes = [Int]()
        var endFile = invocation.buffer.lines.count
        var lineIndex = 0
        var waitingEnfIf = false

        var leftWhiteSpace = ""
        while lineIndex < endFile {
            let line = invocation.buffer.lines[lineIndex] as! String
            let containsIfDebug = line.contains(regex: ifDebug)
            let containsPrint = line.contains(regex: "print(.+)")
            let containsEndIf = line.contains(regex: endIf)

            if !waitingEnfIf && containsPrint {
                leftWhiteSpace = line.leftWhiteSpace
                invocation.buffer.lines.insert(leftWhiteSpace + ifDebug, at: lineIndex)
                updatedLineIndexes.append(lineIndex)
                endFile += 1
                waitingEnfIf = true
            } else if waitingEnfIf && !containsEndIf && !containsPrint {
                invocation.buffer.lines.insert(leftWhiteSpace + endIf, at: lineIndex)
                updatedLineIndexes.append(lineIndex)
                endFile += 1
                waitingEnfIf = false
                leftWhiteSpace = ""
            } else if containsIfDebug {
                waitingEnfIf = true
            } else if containsEndIf {
                waitingEnfIf = false
            } else if containsPrint {
                invocation.buffer.lines[lineIndex] = "\t" + line
                updatedLineIndexes.append(lineIndex)
            }

            lineIndex += 1
        }

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
