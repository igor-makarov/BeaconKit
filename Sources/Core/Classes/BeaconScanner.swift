//
//  BeaconScanner.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

@objc
public protocol BeaconScannerDelegate: class {
    func beaconScanner(_ beaconScanner: BeaconScanner, didDiscover beacon: Beacon)
}

@objc
public class BeaconScanner: NSObject {
    public static let shared = BeaconScanner()
    
    public var recognizedBeaconTypes: [Beacon.Type] = [EddystoneUidBeacon.self, EddystoneUrlBeacon.self, AltBeacon.self] {
        didSet {
            _beaconParser = BeaconParser(recognizedBeaconTypes)
        }
    }
    
    public weak var delegate: BeaconScannerDelegate?

    fileprivate var _beaconParser: BeaconParser
    fileprivate var _centralManager: CBCentralManager?

    override init() {
        _beaconParser = BeaconParser(recognizedBeaconTypes)
    }
    
    public func start(restoreIdentifier: String? = nil) {
        if let restoreIdentifier = restoreIdentifier {
//            guard #available(OSX 10.13, *) else {
//                fatalError("Cannot use restore identifiers on macOS < 10.13")
//            }
//            _centralManager = CBCentralManager(delegate: self, queue: nil,
//                                               options: [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifier])
        } else {
            _centralManager = CBCentralManager(delegate: self, queue: nil,
                                               options: nil)
        }
    }
    
    public func stop() {
        _centralManager?.stopScan()
        _centralManager = nil
    }
}

// MARK: CBCentralManagerDelegate
extension BeaconScanner: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
//            let beaconServiceIds = self.recognizedBeaconTypes.map { $0.serviceUuid }
            central.scanForPeripherals(withServices: nil, options:nil)
//            central.scanForPeripherals(withServices: beaconServiceIds, options:nil)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let identifier: UUID
        if #available(OSX 10.13, *) {
            identifier = peripheral.identifier
        } else {
            let uuid = peripheral.perform(NSSelectorFromString("identifier")).takeUnretainedValue() as! UUID
            identifier = UUID(uuidString: uuid.uuidString)!
        }
        
        let rssi = RSSI.intValue
        
        guard let parsedBeacons = try? _beaconParser.beacons(from: advertisementData, rssi: rssi, identifier: identifier) else { return }
        
        if parsedBeacons.isEmpty { return }
        
        for beacon in parsedBeacons {
            self.delegate?.beaconScanner(self, didDiscover: beacon)
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) { }
}

// MARK: ObjC only
public extension BeaconScanner {
    @available(swift, obsoleted: 3.0)
    @objc
    public func start() {
        self.start(restoreIdentifier: nil)
    }
}
