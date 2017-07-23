//
//  EddystoneUrlParserTests.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import XCTest
import CoreBluetooth
@testable import BeaconKit

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

class EddystoneUrlParserTests: XCTestCase {
    let beaconParser = BeaconParser([EddystoneUrlBeacon.self])

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testParsingValidBeacon() {
        let data = Data.from(hex: "10E703636F636F61636173747300")
        let rssi = -25
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssertEqual(beacons.count, 1)
        
        let beacon = beacons[0] as! EddystoneUrlBeacon
        XCTAssertEqual(beacon.rssi, rssi)
        XCTAssertEqual(beacon.identifier, identifier)
        XCTAssertEqual(beacon.txPower, -25)
        XCTAssertEqual(beacon.beaconType, 0x10)
        XCTAssertEqual(beacon.url, URL(string: "https://cocoacasts.com/"))
        XCTAssertEqual(beacon.beaconData.fields, [])
    }
    
    func testWrongServiceUuid() {
        let data = Data.from(hex: "00e70001020304050607080901020304050A")
        
        let rssi = -25
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "00FA"), data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssert(beacons.isEmpty)
    }

    func testWrongBeaconType() {
        let data = Data.from(hex: "25e70001020304050607080901020304050A")
        
        let rssi = -25
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssert(beacons.isEmpty)
    }
    
    func testManufacturerData() {
        let data = Data.from(hex: "10e70001020304050607080901020304050A")
        
        let rssi = -25
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.manufacturer(data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssert(beacons.isEmpty)
    }

    func testDataTooSmall() {
        let data = Data.from(hex: "00870869")
        
        let rssi = -25
        let identifier = UUID()
        let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
        let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
        XCTAssert(beacons.isEmpty)
    }
    
    func testRandomNoiseThatResemblesEddystone() {
        for _ in 0...100000 {
            let bytes = (0...20).map { _ in UInt8(arc4random_uniform(256)) }
            let data = Data(bytes: [0x10] + bytes)
            
            let rssi = -25
            let identifier = UUID()
            let advertisement = BluetoothAdvertisement.service(CBUUID(string: "FEAA"), data)
            let beacons = beaconParser.beacons(advertisements: [advertisement], rssi: rssi, identifier: identifier)
            XCTAssertEqual(beacons.count, 0, "failed on data: \(data.toString())")
        }
    }
}
