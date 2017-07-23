//
//  AppDelegate.swift
//
//  Created by Igor Makarov on 23/07/2017.
//  
//

import Cocoa
import BeaconKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, BeaconScannerDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        BeaconScanner.shared.recognizedBeaconTypes = [AltBeacon.self]
        BeaconScanner.shared.recognizedBeaconTypes += [iBeacon.self]
        BeaconScanner.shared.delegate = self
        BeaconScanner.shared.start()
    }
    
    func beaconScanner(_ beaconScanner: BeaconScanner, didDiscover beacon: Beacon) {
        print("Discovered beacon: \(beacon)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}
