//
//  iBeacon+AltBeacon.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public class ThreePartIdentifierBeacon: Beacon {
    override open class var advertisementType: AdvertisementType { return .manufacturer }
    
    public private(set) lazy var namespace: String = self.identifiers[0]
    public private(set) lazy var major: String = self.identifiers[1]
    public private(set) lazy var minor: String = self.identifiers[2]
    
    override public var description: String {
        let typeString = String(describing: type(of: self))
        return "\(identifier) RX/TX:\(-rssi)/\(-txPower) \(typeString): \(identifiers.joined(separator: ":"))"
    }

}


public class AltBeacon: ThreePartIdentifierBeacon {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25")
    override open class var layout: ParserLayout { return _layout }
}

// swiftlint:disable:next type_name
public class iBeacon: ThreePartIdentifierBeacon {
    // swiftlint:disable:next force_try
    static let _layout = try! ParserLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24")
    override open class var layout: ParserLayout { return _layout }
}
