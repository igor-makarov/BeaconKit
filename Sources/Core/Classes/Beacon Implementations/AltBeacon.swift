//
//  AltBeacon.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public class AltBeacon: Beacon {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25")
    override open class var layout: ParserLayout { return _layout }
    override open class var serviceUuid: CBUUID { return CBUUID(string: "8C422626-0C6E-4B86-8EC7-9147B233D97E") }
    
    public private(set) lazy var namespace: String = self.identifiers[0]
    public private(set) lazy var major: String = self.identifiers[1]
    public private(set) lazy var minor: String = self.identifiers[2]
    
    override public var description: String {
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) AltBeacon: \(identifiers.joined(separator: ":"))"
    }
}
