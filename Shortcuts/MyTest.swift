//
//  MyTest.swift
//  Test
//
//  Created by Eduardo Fornari on 20/11/19.
//  Copyright © 2019 Eduardo Fornari. All rights reserved.
//

import SceneKit
import AVFoundation
import Foundation

class MyTest {
    // single property with type definition

    var test000: String

    public   var test001: String
    open     var test002: String
    private  var test003: String
    internal var test004: String
    
    private(set) var test005: String

    public   private(set)var test006: String
    open     private(set)var test007: String
    internal private(set)var test008: String

    internal(set)var test009: String

    public internal(set) var test010: String

    init(test000: String, test001: String, test002: String, test003: String, test004: String, test005: String, test006: String, test007: String, test008: String, test009: String, test010: String, test011: String, test012: String, test013: String, test014: String, test015: String) {
        self.test000 = test000
        self.test001 = test001
        self.test002 = test002
        self.test003 = test003
        self.test004 = test004
        self.test005 = test005
        self.test006 = test006
        self.test007 = test007
        self.test008 = test008
        self.test009 = test009
        self.test010 = test010
        self.test011 = test011
        self.test012 = test012
        self.test013 = test013
        self.test014 = test014
        self.test015 = test015
    }

    open   internal(set) var test011: String

    let test012: String

    public   let test013: String
    private  let test014: String
    internal let test015: String

    

    // String
    var test016: String = "sdfghjkl"

    public   var test017: String = "sdfghjkl"
    open     var test018: String = "sdfghjkl"
    private  var test019: String = "sdfghjkl"
    internal var test020: String = "sdfghjkl"
    
    private(set) var test021: String = "sdfghjkl"

    public   private(set)var test022: String = "sdfghjkl"
    open     private(set)var test023: String = "sdfghjkl"
    internal private(set)var test024: String = "sdfghjkl"

    internal(set)var test025: String = "sdfghjkl"

    public internal(set) var test026: String = "sdfghjkl"
    open   internal(set) var test027: String = "sdfghjkl"

    let test028: String = "sdfghjkl"

    public   let test029: String = "sdfghjkl"
    private  let test030: String = "sdfghjkl"
    internal let test031: String = "sdfghjkl"

    // Bool true
    var test032: Bool = true

    public   var test033: Bool = true
    open     var test034: Bool = true
    private  var test035: Bool = true
    internal var test036: Bool = true
    
    private(set) var test037: Bool = true

    public   private(set)var test038: Bool = true
    open     private(set)var test039: Bool = true
    internal private(set)var test040: Bool = true

    internal(set)var test041: Bool = true

    public internal(set) var test042: Bool = true
    open   internal(set) var test043: Bool = true

    let test044: Bool = true

    public   let test045: Bool = true
    private  let test046: Bool = true
    internal let test047: Bool = true
    
    // Bool false
    var test048: Bool = false

    public   var test049: Bool = false
    open     var test050: Bool = false
    private  var test051: Bool = false
    internal var test052: Bool = false
    
    private(set) var test053: Bool = false

    public   private(set)var test054: Bool = false
    open     private(set)var test055: Bool = false
    internal private(set)var test056: Bool = false

    internal(set)var test057: Bool = false

    public internal(set) var test058: Bool = false
    open   internal(set) var test059: Bool = false

    let test060: Bool = false

    public   let test061: Bool = false
    private  let test062: Bool = false
    internal let test063: Bool = false

    // Int
    var test064: Int = 0

    public   var test065: Int = 0
    open     var test066: Int = 0
    private  var test067: Int = 0
    internal var test068: Int = 0
    
    private(set) var test069: Int = 0

    public   private(set)var test070: Int = 0
    open     private(set)var test071: Int = 0
    internal private(set)var test072: Int = 0

    internal(set)var test073: Int = 0

    public internal(set) var test074: Int = 0
    open   internal(set) var test075: Int = 0

    let test076: Int = 0

    public   let test077: Int = 0
    private  let test078: Int = 0
    internal let test079: Int = 0

    // Double
    var test080: Double = 0.0

    public   var test081: Double = 0.0
    open     var test082: Double = 0.0
    private  var test083: Double = 0.0
    internal var test084: Double = 0.0
    
    private(set) var test085: Double = 0.0

    public   private(set)var test086: Double = 0.0
    open     private(set)var test087: Double = 0
    internal private(set)var test088: Double = 0

    internal(set)var test089: Double = 0.0

    public internal(set) var test090: Double = 0.0
    open   internal(set) var test091: Double = 0.0

    let test092: Double = 0.0

    public   let test093: Double = 0.0
    private  let test094: Double = 0.0
    internal let test095: Double = 0.0
    
    // single property without type definition
    
    var test096 = 0
    var test097 = 0.0
    var test098 = 1_000.0
    var test099 = false
    var test100 = true
    var test101 = ""
    var test102 = MyClass(with: 102)


    func testClearClosure() {
        let _ = [1 ,2 , 3, 4, 5].compactMap { (value) -> Double? in
            return Double(value)
        }
    }

    func testPrintOnlyInDebug() {
        print("teste")
        print("teste")

        print("teste")

        print("teste")
        print("teste")
    }
}



class MyClass {
    init(with value: Int) {
        
    }
}

func myClass(with value: Int) -> MyClass {
    return MyClass(with: value)
}

var myClassA = MyClass(with: 1)
var myClassB = myClass(with: 1)
