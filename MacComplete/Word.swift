//
//  Word.swift
//  MacComplete
//
//  Created by Iain Munro on 27/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

class Word : Object {
    dynamic var value: String = ""
    dynamic var date: Date = Date()
    
    static func getWordsLike(value: String) {
        
    }
    
}


