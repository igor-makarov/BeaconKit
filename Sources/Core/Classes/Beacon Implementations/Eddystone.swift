//
//  Eddystone.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public class EddystoneBeacon: Beacon {
    override open class var serviceUuid: CBUUID? { return CBUUID(string: "FEAA") }
    override open class var advertisementType: AdvertisementType { return .service }
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

    override public var identifiers: [String] { return [self.url?.absoluteString ?? ""] }
    
    static let _schemePrefixes = [
        "http://www.",
        "https:/www.",
        "http://",
        "https://"
    ]
    
    static let _urlEncodings = [
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
        let url = self.url?.absoluteString ?? "(null)"
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) Eddystone URL: \(url)"
    }
    
    public required init(_ advertisement: BluetoothAdvertisement, rssi: Int, identifier: UUID) throws {
        try super.init(advertisement, rssi: rssi, identifier: identifier)
    }
    
    
    public private(set) lazy var url: URL? = {
        guard let data = self.beaconData.identifiers.first else {  fatalError() }
        var urlString = ""

        for (offset, byte) in data.enumerated() {
            switch offset {
            case 0:
                if Int(byte) < EddystoneUrlBeacon._schemePrefixes.count {
                    urlString += EddystoneUrlBeacon._schemePrefixes[Int(byte)]
                }
            case 1...data.count-1:
                if Int(byte) < EddystoneUrlBeacon._urlEncodings.count {
                    urlString += EddystoneUrlBeacon._urlEncodings[Int(byte)]
                } else {
                    let unicode = UnicodeScalar(byte)
                    let character = Character(unicode)
                    urlString.append(character)
                }
            default:
                break
            }
        }
        
        return URL(string: urlString)
    }()
}
