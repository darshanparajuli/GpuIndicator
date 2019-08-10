//
//  AppDelegate.swift
//  GpuIndicator
//
//  Created by Darshan Parajuli on 8/8/19.
//  Copyright © 2019 Darshan Parajuli. All rights reserved.
//

import Cocoa
import MetalKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var removableGpuImage: NSImage? = nil
    private var integratedGpuImage: NSImage? = nil
    private var discreteGpuImage: NSImage? = nil
    
    private let gpuLabel = NSMenuItem(title: "Active GPU: n/a", action: nil, keyEquivalent: "")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenu()
        menu.addItem(gpuLabel)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(onClickPreferences), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(onClickQuit), keyEquivalent: ""))
        statusItem.menu = menu
        
        statusItem.button?.imageScaling = .scaleProportionallyUpOrDown
        
        integratedGpuImage = createStatusIcon(color: Preferences.getColor(gpuType: .Integrated));
        discreteGpuImage = createStatusIcon(color: Preferences.getColor(gpuType: .Discrete))
        removableGpuImage = createStatusIcon(color: Preferences.getColor(gpuType: .Removable))
        
        updateGpuIndicator()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func updateGpuIndicatorColor(gpuType: GpuType, color: NSColor, save: Bool = true) {
        switch (gpuType) {
        case .Integrated:
            integratedGpuImage = createStatusIcon(color: color)
        case .Discrete:
            discreteGpuImage = createStatusIcon(color: color)
        case .Removable:
            removableGpuImage = createStatusIcon(color: color)
        }
        
        if (save) {
            Preferences.setColor(gpuType: gpuType, color: color)
        }
        
        updateGpuIndicator()
    }
    
    @objc
    private func onClickQuit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc
    private func onClickPreferences() {
        let preferencesStoryBoard = NSStoryboard.init(name: "Preferences", bundle: nil)
        let nc = preferencesStoryBoard.instantiateController(withIdentifier: "Preferences") as! NSWindowController
        nc.showWindow(self)
    }
    
    private func setButtonTitle(_ title: String) {
        statusItem.button?.title = title
    }
    
    private func updateGpuIndicator() {
        let screenId = NSScreen.main?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
        let device = CGDirectDisplayCopyCurrentMetalDevice(screenId)!
        gpuLabel.title = "Active GPU: \(device.name)"
        if (device.isRemovable) {
            statusItem.button?.image = removableGpuImage
        } else if (device.isLowPower) {
            statusItem.button?.image = integratedGpuImage
        } else {
            statusItem.button?.image = discreteGpuImage
        }
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        updateGpuIndicator()
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
