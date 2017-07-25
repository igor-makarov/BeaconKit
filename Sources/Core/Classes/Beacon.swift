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

@objc
open class Beacon: NSObject {
    public enum AdvertisementType {
        case service
        case manufacturer
    }

    open class var layout: ParserLayout { fatalError() }
    open class var advertisementType: AdvertisementType { fatalError() }
    open class var serviceUuid: CBUUID? { return nil }

    public let rssi: Int
    public let identifier: UUID
    public let beaconData: BeaconRawData
    public var beaconType: Int { return beaconData.type }
    public var txPower: Int { return beaconData.txPower }

    private lazy var _identifiers: [String] = self.beaconData.identifiers.map { $0.toString() }
    public var identifiers: [String] { return _identifiers }

    public required init(_ advertisement: BluetoothAdvertisement, rssi: Int, identifier: UUID) throws {
        self.rssi = rssi
        self.identifier = identifier
        let instanceType = type(of: self)
        let data = try instanceType.validateAndGetData(advertisement: advertisement)
        self.beaconData = try instanceType.layout.parse(data)
    }

    class func validateAndGetData(advertisement: BluetoothAdvertisement) throws -> Data {
        switch advertisement {
        case .manufacturer(let data) where advertisementType == .manufacturer:
            return data
        case .service(let serviceUuid, let data) where serviceUuid == self.serviceUuid && advertisementType == .service:
            return data
        default:
            throw BeaconParsingError.unrecognizedBeaconType
        }
    }
    
    public var distanceMeters: Double {
        if rssi >= 0 {
            return .infinity
        }
        
        let ratio = Double(rssi) / Double(txPower)
        if ratio < 1 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
    }
}
