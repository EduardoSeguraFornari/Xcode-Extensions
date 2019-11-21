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

        invocation.sortImportDeclarations()

        completionHandler(nil)
    }

}

public extension XCSourceEditorCommandInvocation {

    func sortImportDeclarations() {
        var indexesToSort: [Int] = []
        for lineIndex in 0 ..< buffer.lines.count {
            let line = buffer.lines[lineIndex] as! String
            if line.isImport() {
                indexesToSort.append(lineIndex)
            } else {
                sortLines(at: indexesToSort)
                indexesToSort = []
            }
        }

        sortLines(at: indexesToSort)
    }

    func sortLines(at indexes: [Int]) {
        if !indexes.isEmpty {
            let linesSorted = indexes.compactMap { index -> String? in
                return buffer.lines[index] as? String
            }.sorted()
            var lineIndex = 0
            for index in indexes {
                self.buffer.lines[index] = linesSorted[lineIndex]
                lineIndex += 1
            }
        }
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
