//
//  Eddystone.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public class EddystoneBeacon: Beacon {
    override open class var serviceUuid: CBUUID? { return CBUUID(string: "FEAA") }
    override open class var advertisementType: AdvertisementType { return .service }
    // Eddystone TX value is zeroed at 0m so need to subtract 41dB
    // to get 1m TX power
    // [reference]: https://github.com/google/eddystone/tree/master/eddystone-uid#tx-power
    override public var txPower: Int { return super.txPower - 41 }
}

public class EddystoneUidBeacon: EddystoneBeacon {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:0-0=00,p:1-1,i:2-11,i:12-17")
    override open class var layout: ParserLayout { return _layout }

    public private(set) lazy var namespace: String = self.identifiers[0]
    public private(set) lazy var instance: String = self.identifiers[1]

    override public var description: String {
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) Eddystone UID: \(namespace) \(instance)"
    }
}

public class EddystoneUrlBeacon: EddystoneBeacon {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:0-0=10,p:1-1,i:2-19")
    override open class var layout: ParserLayout { return _layout }

    override public var identifiers: [String] { return [self.url.absoluteString] }
    // swiftlint:disable:next force_try
    public private(set) lazy var url: URL = try! self.urlGenerated()
    
    static let _validEncodingCharacters = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=`".characters)
    
    static let _schemePrefixes = [
        "http://www.",
        "https://www.",
        "http://",
        "https://"
    ]
    
    static let _urlExpansions = [
        ".com/",
        ".org/",
        ".edu/",
        ".net/",
        ".info/",
        ".biz/",
        ".gov/",
        ".com",
        ".org",
        ".edu",
        ".net",
        ".info",
        ".biz",
        ".gov"
    ]

    override public var description: String {
        let url = self.url.absoluteString
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) Eddystone URL: \(url)"
    }
    
    public required init(_ advertisement: BluetoothAdvertisement, rssi: Int, identifier: UUID) throws {
        try super.init(advertisement, rssi: rssi, identifier: identifier)
        _ = try self.urlGenerated()
    }
    
    
    private func urlGenerated() throws -> URL {
        guard let data = self.beaconData.identifiers.first, data.count > 1 else { throw BeaconParsingError.parseError }
        
        let prefix = try urlPrefix()
        let subsequentData = data.subdata(in: 1..<data.count)
        let subsequentCharacters = try subsequentData.map { (byte: UInt8) -> String in
            let character = Character(UnicodeScalar(byte))
            if EddystoneUrlBeacon._validEncodingCharacters.contains(character) {
                return String(character)
            }
            switch Int(byte) {
            case 0..<EddystoneUrlBeacon._urlExpansions.count:
                return EddystoneUrlBeacon._urlExpansions[Int(byte)]
            default:
                throw BeaconParsingError.parseError
            }
        }
        
        let result = prefix + subsequentCharacters.joined()
        
        guard let url = URL(string: result) else { throw BeaconParsingError.parseError }
        return url
    }
    
    private func urlPrefix() throws -> String {
        guard let data = self.beaconData.identifiers.first else { throw BeaconParsingError.parseError }
        guard let prefix = data.first else { throw BeaconParsingError.parseError }
        switch Int(prefix) {
        case 0..<EddystoneUrlBeacon._schemePrefixes.count:
            return EddystoneUrlBeacon._schemePrefixes[Int(prefix)]
        default:
            throw BeaconParsingError.parseError
        }
    }
}
