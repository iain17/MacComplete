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
    
    static public var dictionaries:[DCSDictionary]? = nil
    
    static private let limit = 100
    
    func save(realm: Realm) {
        DispatchQueue.main.async {
            do {
                try realm.write {
                    realm.add(self)
                    try realm.commitWrite()
                    print("\(self.value) saved")
                }
            } catch let exception {
                print("\(self.value) failed to be saved:")
                print(exception)
            }
        }
    }
    
    static func clearOld(realm: Realm) {
        DispatchQueue.main.async {
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
    }
    
    static private func sortLimitWords(results: Results<Word>, limit: Int) -> [(word: String, amount: Int)] {
        var uniqueResults = [String: Int]()
        var index = 0
        for result in results {
            if index > limit {
                break
            }
            let key = result.value.lowercased().capitalized
            if uniqueResults[key] == nil {
                uniqueResults[key] = 0
            }
            uniqueResults[key]! += 1
            index += 1
        }
        
        return uniqueResults.sorted(by: { (a: (key: String, value: Int), b: (key: String, value: Int)) -> Bool in
            return a.value > b.value
        }) as! [(word: String, amount: Int)]
    }
    
    static func getWordsLike(search: String, realm: Realm) -> [(word: String, amount: Int)] {
        clearOld(realm: realm)
        let predicate = NSPredicate(format: "value BEGINSWITH[c] %@", search)
        let results = realm.objects(Word.self).filter(predicate).sorted(byProperty: "date")
        
        getDictionaryWords(search, realm: realm)
        
        return sortLimitWords(results: results, limit: Word.limit).filter({ (word: String, amount: Int) -> Bool in
            return word != search
        })
    }
    
    //Feed the machine by adding stuff from the dictionary.
    static func getDictionaryWords(_ search: String, realm: Realm) {
        DispatchQueue.main.async {
            if dictionaries != nil {
                let words = lookUp(search: search, dictionaries: dictionaries!)
                
                do {
                    try realm.write {
                        for word in words {
                            
                            //Check if it already exists
                            let predicate = NSPredicate(format: "value = %@", word)
                            if realm.objects(Word.self).filter(predicate).count > 0 {
                                continue
                            }
                            
                            let newWord = Word()
                            newWord.value = word
                            realm.add(newWord)
                            print("\(newWord.value) saved")
                        }
                        try realm.commitWrite()
                    }
                } catch let exception {
                    print("could not add words to our db:")
                    print(exception)
                }
                
            }
        }
    }
    
}


