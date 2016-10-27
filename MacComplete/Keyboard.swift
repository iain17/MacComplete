//
//  Keyboard.swift
//  MacComplete
//
//  Created by Iain Munro on 27/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

public enum KeyCode : UInt16 {
    case ENTER = 36
    case TAB = 48
    case SPACE = 49
    case BACKSPACE = 51
}

class Keyboard {
    
    var keys: [String] = [String]()
    var location:NSPoint? = nil
    static let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
    
    let suggestionWindow: SuggestionWindow
    var realm: Realm
    
    init() {
        realm = try! Realm()
        suggestionWindow = SuggestionWindow(windowNibName: "SuggestionWindow")
    }
    
    private func autoComplete() {
        //Only add words that are worthwhile
        if keys.count < 2 {
            return
        }
        
        let uniqueResults = Word.getWordsLike(value: getNewWord().value, realm: realm)
        
        if uniqueResults.count > 0 {
            suggestionWindow.showWindow(nil)
            suggestionWindow.suggest(uniqueResults)
        }
    }
    
    private func addKey(char: String) {
        keys.append(char)
    }
    
    private func delKey() {
        if keys.count == 0 {
            return
        }
        
        keys.removeLast()
    }
    
    private func clearKeys() {
        print("Cleared all all the keys")
        keys.removeAll()
    }
    
    private func getNewWord()-> Word {
        let word = Word()
        word.value = keys.map({"\($0)"}).joined(separator: "")
        return word
    }
    
    private func addWord() {
        //Only add words that are worthwhile
        if keys.count < 4 {
            return
        }
        
        let word = getNewWord()
        do {
            try realm.write {
                realm.add(word)
                try realm.commitWrite()
                print("\(word.value) saved")
            }
        } catch let exception {
            print("\(word.value) failed to be saved:")
            print(exception)
        }
        
    }
    
    public func input(event: NSEvent) {
        
        suggestionWindow.close()
        
        //If the the location has changed. Ignore the word we're a building.
        if location != event.locationInWindow {
            clearKeys()
        }
        location = event.locationInWindow
        
        //If command button was pressed. Clear keys
        if event.modifierFlags.rawValue == 0x100108 {
            clearKeys()
            return
        }
        
        if event.modifierFlags.rawValue == 0x100 {
            if let key = KeyCode(rawValue: event.keyCode) {
                switch( key ) {
                    
                case KeyCode.TAB:
                    print("tab")
                    clearKeys()
                    break
                case KeyCode.ENTER, KeyCode.SPACE:
                    addWord()
                    clearKeys()
                    break
                case KeyCode.BACKSPACE:
                    delKey()
                    break
                default:
                    print("\(key) is not mapped")
                    break
                }
                return
            }
        }
        
        if event.modifierFlags.rawValue == 0x100 || event.modifierFlags.rawValue == 0x20102 {
            
            if let char = event.characters {
                
                if char.rangeOfCharacter(from: Keyboard.characterset.inverted) == nil {
                    if(char != "") {
                        addKey(char: char)
                        autoComplete()
                        return
                    }
                }
                
            }
        }
        print("Event: \(event) could be used")
    }
    
}
