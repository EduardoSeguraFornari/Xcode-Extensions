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
        for lineIndex in 0 ..< invocation.buffer.lines.count {
            let line = invocation.buffer.lines[lineIndex] as! String
            if let range = line.range(of: "\\{.*\\(.+\\).+in", options:.regularExpression) {
                // 2. When a closure is found, clean up its syntax
                let cleanLine = line.remove(characters: ["(", ")"], in: range)
                updatedLineIndexes.append(lineIndex)
                invocation.buffer.lines[lineIndex] = cleanLine
            }
        }
        completionHandler(nil)
    }

}
