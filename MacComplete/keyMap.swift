//
//  keyMap.swift
//  MacComplete
//
//  Created by Iain Munro on 28/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Foundation

extension String {

    private func getKeyCode(keyString: Character) -> CGKeyCode {
        
        if (keyString == "a") {
            return 0
        }
        if (keyString == "s") {
            return 1
        }
        if (keyString == "d") {
            return 2
        }
        if (keyString == "f") {
            return 3
        }
        if (keyString == "h") {
            return 4
        }
        if (keyString == "g") {
            return 5
        }
        if (keyString == "z") {
            return 6
        }
        if (keyString == "x") {
            return 7
        }
        if (keyString == "c") {
            return 8
        }
        if (keyString == "v") {
            return 9
        }
        // what is 10?
        if (keyString == "b") {
            return 11
        }
        if (keyString == "q") {
            return 12
        }
        if (keyString == "w") {
            return 13
        }
        if (keyString == "e") {
            return 14
        }
        if (keyString == "r") {
            return 15
        }
        if (keyString == "y") {
            return 16
        }
        if (keyString == "t") {
            return 17
        }
        if (keyString == "1") {
            return 18
        }
        if (keyString == "2") {
            return 19
        }
        if (keyString == "3") {
            return 20
        }
        if (keyString == "4") {
            return 21
        }
        if (keyString == "6") {
            return 22
        }
        if (keyString == "5") {
            return 23
        }
        if (keyString == "=") {
            return 24
        }
        if (keyString == "9") {
            return 25
        }
        if (keyString == "7") {
            return 26
        }
        if (keyString == "-") {
            return 27
        }
        if (keyString == "8") {
            return 28
        }
        if (keyString == "0") {
            return 29
        }
        if (keyString == "]") {
            return 30
        }
        if (keyString == "o") {
            return 31
        }
        if (keyString == "u") {
            return 32
        }
        if (keyString == "[") {
            return 33
        }
        if (keyString == "i") {
            return 34
        }
        if (keyString == "p") {
            return 35
        }
//        if (keyString == "RETURN") {
//            return 36
//        }
        if (keyString == "l") {
            return 37
        }
        if (keyString == "j") {
            return 38
        }
        if (keyString == "'") {
            return 39
        }
        if (keyString == "k") {
            return 40
        }
        if (keyString == ";") {
            return 41
        }
        if (keyString == "\\") {
            return 42
        }
        if (keyString == ",") {
            return 43
        }
        if (keyString == "/") {
            return 44
        }
        if (keyString == "n") {
            return 45
        }
        if (keyString == "m") {
            return 46
        }
        if (keyString == ".") {
            return 47
        }
//        if (keyString == "TAB") {
//            return 48
//        }
//        if (keyString == "SPACE") {
//            return 49
//        }
//        if (keyString == "`") {
//            return 50
//        }
//        if (keyString == "DELETE") {
//            return 51
//        }
//        if (keyString == "ENTER") {
//            return 52
//        }
//        if (keyString == "ESCAPE") {
//            return 53
//        }
        // some more missing codes abound, reserved I presume, but it would
        // have been helpful for Apple to have a document with them all listed
        if (keyString == ".") {
            return 65
        }
        if (keyString == "*") {
            return 67
        }
        if (keyString == "+") {
            return 69
        }
//        if (keyString == "CLEAR") {
//            return 71
//        }
        if (keyString == "/") {
            return 75
        }
//        if (keyString == "ENTER") {
//            return 76
//        }
        // numberpad on full kbd
        if (keyString == "=") {
            return 78
        }
        if (keyString == "=") {
            return 81
        }
        if (keyString == "0") {
            return 82
        }
        if (keyString == "1") {
            return 83
        }
        if (keyString == "2") {
            return 84
        }
        if (keyString == "3") {
            return 85
        }
        if (keyString == "4") {
            return 86
        }
        if (keyString == "5") {
            return 87
        }
        if (keyString == "6") {
            return 88
        }
        if (keyString == "7") {
            return 89
        }
        if (keyString == "8") {
            return 91
        }
        if (keyString == "9") {
            return 92
        }
//        if (keyString == "F5") {
//            return 96
//        }
//        if (keyString == "F6") {
//            return 97
//        }
//        if (keyString == "F7") {
//            return 98
//        }
//        if (keyString == "F3") {
//            return 99
//        }
//        if (keyString == "F8") {
//            return 100
//        }
//        if (keyString == "F9") {
//            return 101
//        }
//        if (keyString == "F11") {
//            return 103
//        }
//        if (keyString == "F13") {
//            return 105
//        }
//        if (keyString == "F14") {
//            return 107
//        }
//        if (keyString == "F10") {
//            return 109
//        }
//        if (keyString == "F12") {
//            return 111
//        }
//        if (keyString == "F15") {
//            return 113
//        }
//        if (keyString == "HELP") {
//            return 114
//        }
//        if (keyString == "HOME") {
//            return 115
//        }
//        if (keyString == "PGUP") {
//            return 116
//        }
//        if (keyString == "DELETE") {
//            return 117
//        }
//        if (keyString == "F4") {
//            return 118
//        }
//        if (keyString == "END") {
//            return 119
//        }
//        if (keyString == "F2") {
//            return 120
//        }
//        if (keyString == "PGDN") {
//            return 121
//        }
//        if (keyString == "F1") {
//            return 122
//        }
//        if (keyString == "LEFT") {
//            return 123
//        }
//        if (keyString == "RIGHT") {
//            return 124
//        }
//        if (keyString == "DOWN") {
//            return 125
//        }
//        if (keyString == "UP") {
//            return 126
//        }
        return 0
    }
    
    var keyCodes: [CGKeyCode] {
        return self.characters.map{
            return getKeyCode(keyString: $0)
        }
    }
    
}
