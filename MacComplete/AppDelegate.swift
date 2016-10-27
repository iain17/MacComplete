//
//  AppDelegate.swift
//  MacComplete
//
//  Created by Iain Munro on 27/10/2016.
//  Copyright © 2016 iMunro. All rights reserved.
//

import Cocoa

func acquirePrivileges() -> Bool {
    let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    
    let accessEnabled = AXIsProcessTrustedWithOptions(options)
    return accessEnabled == true
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = "MacComplete"
        statusItem.menu = statusMenu
        
        if let button = statusItem.button {
            button.image = NSImage(named: "TranslateStatusBarButtonImage")
            button.image?.isTemplate = true //So that the image doesn't hide when the screen is in focus.
//            button.action = Selector("togglePopover:")
        }
        
        while(!acquirePrivileges()) {
            print("You need to enable the keylogger in the System Preferences")
            sleep(1000)
        }
        
        let keyboard = Keyboard()
        // keyboard listeners
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyDown, handler: keyboard.input)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
}

