//
//  BeaconTests.swift
//
//  Created by Igor Makarov on 25/07/2017.
//  
//

import XCTest
import CoreBluetooth
@testable import BeaconKit

class BeaconTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_when_RSSIZero_then_distanceInfinite() {
        let data = Data.from(hex: "00010001020304050607080901020304050A")
        let rssi = 0
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
        let beaconParser = BeaconParser([EddystoneUidBeacon.self])
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssertEqual(beacons.count, 1)
        
        let beacon = beacons[0] as! EddystoneUidBeacon
        XCTAssertEqual(beacon.rssi, 0)
        XCTAssertEqual(beacon.distanceMeters, .infinity)
    }
    
    func test_when_dataIsShort_then_doesNotCrash() {
        let data = Data.from(hex: "00")
        let rssi = 0
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.manufacturer(data)
        let beaconParser = BeaconParser([AltBeacon.self])

        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssertEqual(beacons.count, 0)        
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
