//
//  AppDelegate.swift
//  GpuIndicator
//
//  Created by Darshan Parajuli on 8/8/19.
//  Copyright © 2019 Darshan Parajuli. All rights reserved.
//

import Cocoa
import MetalKit
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var removableImage: NSImage? = nil
    private var lowPowerImage: NSImage? = nil
    private var discreteImage: NSImage? = nil
    
    private let gpuLabel = NSMenuItem(title: "GPU", action: nil, keyEquivalent: "")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenu()
        menu.addItem(gpuLabel)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: ""))
        statusItem.menu = menu
        
        statusItem.button?.imageScaling = .scaleProportionallyUpOrDown
        
        removableImage = createStatusIcon(color: NSColor.systemGreen)
        lowPowerImage = createStatusIcon();
        discreteImage = createStatusIcon(color: NSColor.systemBlue)
        
        checkGpuAndSetTitle()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc
    private func onQuit() {
        exit(0)
    }
    
    private func setButtonTitle(_ title: String) {
        statusItem.button?.title = title
    }
    
    private func checkGpuAndSetTitle() {
        let screenId = NSScreen.main?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
        let device = CGDirectDisplayCopyCurrentMetalDevice(screenId)!
        gpuLabel.title = "Active GPU: \(device.name)"
        if (device.isRemovable) {
            statusItem.button?.image = removableImage
        } else if (device.isLowPower) {
            statusItem.button?.image = lowPowerImage
        } else {
            statusItem.button?.image = discreteImage
        }
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        checkGpuAndSetTitle()
    }
    
    private func createStatusIcon(color: NSColor? = nil) -> NSImage? {
        let image = NSImage(named: "StatusIcon")
        if let color = color {
            return image?.tint(color: color)
        } else {
            return image;
        }
    }
}

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        return image
    }
}

extension NSColor {
    class func fromHex(hex: Int) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
}
