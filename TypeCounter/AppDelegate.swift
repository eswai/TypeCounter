import Foundation
import AppKit
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Capture typing
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: keylogger,
            userInfo: nil)
        else {
            print("failed to create event tap")
            exit(1)
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)

        // Detect input method change
//        NotificationCenter.default.addObserver(forName: NSTextInputContext.keyboardSelectionDidChangeNotification, object: nil, queue: .main) {
//            _ in
//            let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
//            debugPrint(keyboard)
//        }
        
        keystats = CSV.read(filename: "keystats.csv")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        CSV.write(data: keystats, filename: "keystats.csv")
    }
}

func keylogger(proxy: CGEventTapProxy,
               type: CGEventType,
               event: CGEvent,
               refcon: UnsafeMutableRawPointer?)
-> Unmanaged<CGEvent>? {
    var keyCode = -1
    
    if type == .keyDown {
        keyCode = Int(event.getIntegerValueField(.keyboardEventKeycode))
    } else if type == .flagsChanged {
        let flags = event.flags
        
        if flags.contains(.maskShift) {
            keyCode = kVK_Shift
        }
        if flags.contains(.maskControl) {
            keyCode = kVK_Control
        }
        if flags.contains(.maskAlternate) {
            keyCode = kVK_Option
        }
        if flags.contains(.maskCommand) {
            keyCode = kVK_Command
        }
    }
    if keyCode > -1 {
        stat_changed = true
        if let a = keystats[keyCode] {
            keystats.updateValue(a + 1, forKey: keyCode)
        } else {
            keystats.updateValue(1, forKey: keyCode)
        }
    }

    return Unmanaged.passUnretained(event)
}
