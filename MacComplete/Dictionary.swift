//
//  Dictionary.swift
//  MacComplete
//
//  Created by Iain Munro on 28/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Foundation
import CoreServices

func getAvailableDictionaries() -> [String : DCSDictionary] {
    var result = [String : DCSDictionary]()
    let availableDictionaries = DCSCopyAvailableDictionaries().takeUnretainedValue() as NSArray
    for dictionary in availableDictionaries {
        let dict = dictionary as! DCSDictionary
        let name: String = DCSDictionaryGetName(dict).takeUnretainedValue() as String
        
        result[name] = dict
    }
    return result
}

func removeDuplicateStrings(_ values: [String]) -> [String] {
    // Convert array into a set to get unique values.
    let uniques = Set<String>(values)
    // Convert set back into an Array of strings.
    let result = Array<String>(uniques)
    return result
}

func lookUp(search: String, dictionaries: [DCSDictionary]) -> [String] {
    var results = [String]()
    for dictionary in dictionaries {
        let dictResults = DCSCopyRecordsForSearchString(dictionary, search as CFString, nil, nil)
        
        if dictResults == nil {
            continue
        }
        
        for dictResult in dictResults?.takeUnretainedValue() as! NSArray {
            let head = DCSRecordGetHeadword(dictResult as CFTypeRef!)
            
            if let headValue = head?.takeRetainedValue() {
                if search.caseInsensitiveCompare(headValue as String) != ComparisonResult.orderedSame {
                    continue
                }
            } else {
                continue
            }
            
            let title = DCSRecordGetTitle(dictResult as CFTypeRef!)
            if let value = title?.takeRetainedValue() {
                results.append(value as! String)
            }
        }
    }
    return removeDuplicateStrings(results)
}
