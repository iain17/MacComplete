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
    
    static let limit = 100
    
    static func clearOld(realm: Realm) {
        let expireTime = NSDate(timeIntervalSinceNow:-(12*60*60))
        let predicate = NSPredicate(format: "date < %@", expireTime)
        do {
            try realm.write {
                let itemsToDelete = realm.objects(Word.self).filter(predicate)
                realm.delete(itemsToDelete)
                try realm.commitWrite()
                print("\(itemsToDelete.count) deleted")
            }
        } catch let exception {
            print("Failed to delete old items")
            print(exception)
        }
        
        
    }
    
    static private func sortLimitWords(results: Results<Word>, limit: Int) -> [(word: String, amount: Int)] {
        var uniqueResults = [String: Int]()
        var index = 0
        for result in results {
            if index > limit {
                break
            }
            if uniqueResults[result.value] == nil {
                uniqueResults[result.value] = 0
            }
            uniqueResults[result.value]! += 1
            index += 1
        }
        func backward(a: (key: String, value: Int), b: (key: String, value: Int)) -> Bool {
            return a.value > b.value
        }
        return uniqueResults.sorted(by: backward) as! [(word: String, amount: Int)]
    }
    
    static func getWordsLike(value: String, realm: Realm) -> [(word: String, amount: Int)] {
        clearOld(realm: realm)
        let predicate = NSPredicate(format: "value BEGINSWITH %@", value)
        let results = realm.objects(Word.self).filter(predicate).sorted(byProperty: "date")
        return sortLimitWords(results: results, limit: Word.limit)
    }
}


