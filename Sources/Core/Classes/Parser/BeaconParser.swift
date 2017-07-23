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
        do {
            let advertisementsFound = try advertisements(from: advertisementData)
            return beacons(advertisements: advertisementsFound, rssi: rssi, identifier: identifier)
        } catch {
            return []
        }
    }
    
    func beacons(advertisements: [BluetoothAdvertisement], rssi: Int, identifier: UUID) -> [Beacon] {
//        for i in 0...10000 {
//            _ = i*i
//        }
        return advertisements.flatMap { advertisement -> Beacon? in
            for beaconType in self.recognizedBeaconTypes {
                do {
                    return try beaconType.init(advertisement, rssi: rssi, identifier: identifier)
                } catch { }
            }
            return nil
        }
    }
}

public enum BluetoothAdvertisement: CustomStringConvertible {
    case service(CBUUID, Data)
    case manufacturer(Data)
    
    public var description: String {
        switch self {
        case .service(let identifier, let data):
            return "Service: \(identifier) data: \(data.toString())"
        case .manufacturer(let data):
            return "Manufacturer data: \(data.toString())"
        }
    }
}

fileprivate func advertisements(from advertisementData: [AnyHashable: Any]) throws -> [BluetoothAdvertisement] {
    var result = [BluetoothAdvertisement]()

    let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
    if let manufacturerData = manufacturerData {
        result.append(.manufacturer(manufacturerData))
    }
    
    if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable: Any] {
        result += serviceData.flatMap { key, value -> BluetoothAdvertisement? in
            if let key = key as? CBUUID, let value = value as? Data {
                return .service(key, value)
            }
            return nil
        }
    }
    
    return result    
}
