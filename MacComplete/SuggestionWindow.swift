//
//  SuggestionWindow.swift
//  MacComplete
//
//  Created by Iain Munro on 27/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Cocoa
import RealmSwift

class SuggestionWindow: NSWindowController {

    @IBOutlet weak var WordCells: NSSegmentedCell!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.isOpaque = false
        self.window?.isMovableByWindowBackground = true
        self.window?.backgroundColor = NSColor(hue: 0, saturation: 1, brightness: 0, alpha: 0.0)//0.7
        self.window?.styleMask = NSWindowStyleMask.borderless
        self.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
    }
    
    private func focus() {
//        NSApp.activate(ignoringOtherApps: true)
        self.window?.makeKeyAndOrderFront(nil)
        
        //Make it so that the window uses 100% the width of the screen.
        let scrn: NSScreen = NSScreen.main()!
        let rect: NSRect = scrn.frame
        let location = NSRect(origin: CGPoint(x:0, y: 0), size: CGSize(width: rect.size.width, height: 24))
        self.window?.setFrame(location, display: true)
        
        let margin = CGFloat(100)
        let width = (rect.size.width - margin) / CGFloat(WordCells.segmentCount)
        
        for segment in 0..<WordCells.segmentCount {
            WordCells.setWidth(width, forSegment: segment)
        }
        
    }
    
    func suggest(_ results: [(word: String, amount: Int)]) {
        //Reset segments
        for segment in 0..<WordCells.segmentCount {
            WordCells.setEnabled(false, forSegment: segment)
            WordCells.setLabel("          ", forSegment: segment)
        }
        
        var segment = 0
        for result in results {
            //out of segments?
            if segment >= results.count {
                break
            }
            
            WordCells.setEnabled(true, forSegment: segment)
            WordCells.setLabel("\(result.word) (\(result.amount))", forSegment: segment)
            segment += 1
        }
        
    }
    
    @IBAction func wordClick(_ sender: AnyObject) {
        let label = WordCells.label(forSegment: WordCells.selectedSegment)
        print(label)
    }
    
}
