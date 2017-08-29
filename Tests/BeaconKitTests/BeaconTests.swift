//
//  BeaconTests.swift
//
//  Created by Igor Makarov on 25/07/2017.
//  
//

import XCTest
import CoreBluetooth
@testable import BeaconKit

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

class BeaconTests: XCTestCase {
    let beaconParser = BeaconParser([EddystoneUidBeacon.self])
    
    override func setUp() {
        print("Swift version running: \(swiftVersion)")

        super.setUp()
        continueAfterFailure = false
    }
    
    func test_when_RSSIZero_then_distanceInfinite() {
        let data = Data.from(hex: "00010001020304050607080901020304050A")
        let rssi = 0
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssertEqual(beacons.count, 1)
        
        let beacon = beacons[0] as! EddystoneUidBeacon
        XCTAssertEqual(beacon.rssi, 0)
        XCTAssertEqual(beacon.distanceMeters, .infinity)
    }

    // for debug purposes
    #if swift(>=3.2)
    #if swift(>=4.0)
    let swiftVersion = "4.0"
    #else
    let swiftVersion = "3.2"
    #endif
    #else
    let swiftVersion = "3.1"
    #endif
    
}
