//
//  BeaconParser.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public enum BeaconParsingError: Error {
    case dataNotFound
    case unrecognizedBeaconType
    case incorrectFragmentSpecification
    case fieldDoesNotMatch
    case parseError
}

class BeaconParser {
    let recognizedBeaconTypes: [Beacon.Type]
    
    init(_ recognizedBeaconTypes: [Beacon.Type]) {
        self.recognizedBeaconTypes = recognizedBeaconTypes
    }

    func beacons(from advertisementData: [AnyHashable: Any], rssi: Int, identifier: UUID) throws -> [Beacon] {
        let advertisementsFound = try advertisements(from: advertisementData)
        return try beacons(advertisements: advertisementsFound, rssi: rssi, identifier: identifier)
    }
    
    func beacons(advertisements: [Data], rssi: Int, identifier: UUID) throws -> [Beacon] {
        return advertisements.flatMap { data -> Beacon? in
            for beaconType in self.recognizedBeaconTypes {
                do {
                    return try beaconType.init(data, rssi: rssi, identifier: identifier)
                } catch { }
            }
            return nil
        }
    }
}


fileprivate func advertisements(from advertisementData: [AnyHashable: Any]) throws -> [Data] {
    let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable: Any] ?? [:]
    let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
    let manufacturerDataArray: [Data]
    if let manufacturerData = manufacturerData {
        manufacturerDataArray = [manufacturerData]
    } else {
        manufacturerDataArray = []
    }
    return serviceData
        .filter { $1 is Data }
        .flatMap { _, value -> Data? in
            return value as? Data
    } + manufacturerDataArray
}
