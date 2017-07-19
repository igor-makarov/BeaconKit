//
//  ParserTests.swift
//  BeaconKitTests
//
//  Created by Igor Makarov on 19/07/2017.
//

import XCTest
@testable import BeaconKit

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

class ParserTests: XCTestCase {
    func testExample() throws {
        Beacon.recognizedBeaconTypes = [EddystoneUIDBeacon.self]
        let data = Data.from(hex: "00e70001020304050607080901020304050A000000000000000000000000000000000000000000000000000000000000000000")
        let rssi = -25
        let identifier = UUID()
        let beacons = try Beacon.beacons(advertisements: [data], rssi: rssi, identifier: identifier)
        XCTAssertEqual(beacons.count, 1)
        
        let beacon = beacons[0] as! EddystoneUIDBeacon
        XCTAssertEqual(beacon.rssi, rssi)
        XCTAssertEqual(beacon.identifier, identifier)
        XCTAssertEqual(beacon.txPower, -25)
        XCTAssertEqual(beacon.type, 0)
        XCTAssertEqual(beacon.namespace, "00010203040506070809")
        XCTAssertEqual(beacon.instance, "01020304050A")
        XCTAssertEqual(beacon.beaconData.fields, [])
    }
}
