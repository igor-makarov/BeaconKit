//
//  BeaconScanner.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import CoreBluetooth

public protocol BeaconScannerDelegate: class {
    func beaconScanner(_ beaconScanner: BeaconScanner, didDiscover beacon: Beacon)
}

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
            _centralManager = CBCentralManager(delegate: self, queue: nil,
                                               options: [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifier])
        } else {
            _centralManager = CBCentralManager(delegate: self, queue: nil,
                                               options: nil)
        }
    }
}

extension BeaconScanner: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
//            let beaconServiceIds = self.recognizedBeaconTypes.map { $0.serviceUuid }
            central.scanForPeripherals(withServices: nil, options:nil)
//            central.scanForPeripherals(withServices: beaconServiceIds, options:nil)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let identifier = peripheral.identifier
        
        let rssi = RSSI.intValue
        
        guard let parsedBeacons = try? _beaconParser.beacons(from: advertisementData, rssi: rssi, identifier: identifier) else { return }
        
        if parsedBeacons.isEmpty { return }
        
        for beacon in parsedBeacons {
            self.delegate?.beaconScanner(self, didDiscover: beacon)
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) { }
}
