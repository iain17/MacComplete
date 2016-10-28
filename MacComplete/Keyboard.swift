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
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
    
    let suggestionWindow: SuggestionWindow
    var realm: Realm
    
    init() {
        realm = try! Realm()
        suggestionWindow = SuggestionWindow(windowNibName: "SuggestionWindow")
    }
    
    private func autoComplete() {
        DispatchQueue.main.async {
            //Only add words that are worthwhile
            if self.keys.count < 2 {
                self.suggestionWindow.close()
                return
            }
            
            let uniqueResults = Word.getWordsLike(search: self.getNewWord().value, realm: self.realm)
            
            if uniqueResults.count > 0 {
                if !(self.suggestionWindow.window?.isVisible)! {
                    self.suggestionWindow.showWindow(nil)
                }
                self.suggestionWindow.suggest(uniqueResults)
            } else {
                self.suggestionWindow.close()
            }
        }
    }
    
    var complete = Timer()
    private var test: String = ""
    @objc
    func doComplete() {
//        let event = CGEvent(keyboardEventSource: nil, virtualKey: KeyCode.BACKSPACE.rawValue, keyDown: true)
//        let event2 = CGEvent(keyboardEventSource: nil, virtualKey: KeyCode.BACKSPACE.rawValue, keyDown: false)
//        event?.post(tap: CGEventTapLocation.cgAnnotatedSessionEventTap)
//        event2?.post(tap: CGEventTapLocation.cgAnnotatedSessionEventTap)
        
        var events = [CGEvent]()
        for key in test.keyCodes {
            let event = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: true)
            let event2 = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: false)
            events.append(event!)
            events.append(event2!)
        }
        test = ""
        
        for event in events {
            event.post(tap: CGEventTapLocation.cgAnnotatedSessionEventTap)
        }
    }
    
    public func complete(fullWord: String) {
        test = fullWord.replacingOccurrences(of: getNewWord().value, with: "")
    }
    
    public func keyUp(event: NSEvent) {
        DispatchQueue.main.async {
            if self.test == "" {
                return
            }
            
            self.complete.invalidate()
            self.complete = Timer.scheduledTimer(timeInterval: 0.100, target: self, selector: #selector(self.doComplete), userInfo: nil, repeats: false)
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
//        print("Cleared all all the keys")
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
        word.save(realm: realm)
    }
    
    public func input(event: NSEvent) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            //If the the location has changed. Ignore the word we're a building.
            if self.location != event.locationInWindow {
                self.clearKeys()
            }
            self.location = event.locationInWindow
            
            
            if event.modifierFlags.rawValue == 0x40101 && KeyCode(rawValue: event.keyCode) == KeyCode.SPACE {
                self.suggestionWindow.wordClick(self)
                self.clearKeys()
                return
            }
            
            //If command button was pressed. Clear keys
            if event.modifierFlags.rawValue == 0x100108 {
                self.addWord()
                self.clearKeys()
                return
            }
            
            if event.modifierFlags.rawValue == 0x100 {
                if let key = KeyCode(rawValue: event.keyCode) {
                    switch( key ) {
                        
    //                case KeyCode.TAB:
    //                    suggestionWindow.wordClick(self)
    //                    clearKeys()
    //                    break
                        
                    case KeyCode.ENTER, KeyCode.SPACE:
                        self.addWord()
                        self.clearKeys()
                        break
                    case KeyCode.BACKSPACE:
                        self.delKey()
                        self.autoComplete()
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
                    
                    if char.rangeOfCharacter(from: self.characterset.inverted) == nil {
                        if(char != "") {
                            self.addKey(char: char)
                            self.autoComplete()
                            return
                        }
                    }
                    
                }
            }
    //        print("Event: \(event) could be used")
        }
        
    }
    
}
