//
//  AppDelegate.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSApp.windows.first
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
