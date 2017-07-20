//
//  Beacon.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public struct BeaconRawData {
    let type: Int
    let txPower: Int
    let identifiers: [Data]
    let fields: [Data]
}

open class Beacon {

    open class var layout: ParserLayout { fatalError() }
    open class var serviceUuid: CBUUID { fatalError() }

    public let rssi: Int
    public let identifier: UUID
    public let beaconData: BeaconRawData
    public var beaconType: Int { return beaconData.type }
    public var txPower: Int { return beaconData.txPower }
  
    public required init(_ data: Data, rssi: Int, identifier: UUID) throws {
        self.rssi = rssi
        self.identifier = identifier
        self.beaconData = try type(of: self).layout.parse(data)
    }
}
