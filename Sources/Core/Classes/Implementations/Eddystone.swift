//
//  Eddystone.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public class EddystoneUidBeacon: Beacon, CustomStringConvertible {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:0-0=00,p:1-1,i:2-11,i:12-17")
    override open class var layout: ParserLayout { return _layout }
    override open class var serviceUuid: CBUUID { return CBUUID(string: "FEAA") }
    
    public var namespace: String {
        guard let string = beaconData.identifiers.first?.toString() else {  fatalError() }
        return string
    }
    
    public var instance: String {
        guard let string = beaconData.identifiers.last?.toString() else {  fatalError() }
        return string
    }
    
    public var description: String {
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) Eddystone UID: \(namespace) \(instance)"
    }
}

public class EddystoneUrlBeacon: Beacon, CustomStringConvertible {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:0-0=10,p:1-1,i:2-19")
    override open class var layout: ParserLayout { return _layout }
    override open class var serviceUuid: CBUUID { return CBUUID(string: "FEAA") }
    
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

    public var description: String {
        let url = self.url?.absoluteString ?? "(null)"
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) Eddystone URL: \(url)"
    }
    
    public required init(_ data: Data, rssi: Int, identifier: UUID) throws {
        try super.init(data, rssi: rssi, identifier: identifier)
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

