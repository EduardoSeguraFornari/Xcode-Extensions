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
                endFile += 1
                waitingEnfIf = true
            } else if waitingEnfIf && !containsEndIf && !containsPrint {
                invocation.buffer.lines.insert(leftWhiteSpace + endIf, at: lineIndex)
                endFile += 1
                waitingEnfIf = false
                leftWhiteSpace = ""
            } else if containsIfDebug {
                waitingEnfIf = true
            } else if containsEndIf {
                waitingEnfIf = false
            } else if containsPrint {
                invocation.buffer.lines[lineIndex] = "\t" + line
            }

            lineIndex += 1
        }

        completionHandler(nil)
    }
    
}
