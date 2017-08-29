//
//  Swift 3.1 Compatibility.swift
//
//  Created by Igor Makarov on 20/07/2017.
//  
//

import Foundation

#if !swift(>=3.2)

// MARK: Integer readers, Swift 3.1
@available(swift, deprecated: 3.2)
extension IntegerFragment {
    func getValue(_ data: Data) throws -> UInt8 {
        guard 1 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 1 else { throw BeaconParsingError.parseError }
        return try subdata.toInteger()
    }
    
    func getValue(_ data: Data) throws -> Int8 {
        guard 1 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 1 else { throw BeaconParsingError.parseError }
        return try subdata.toInteger()
    }
    
    func getValue(_ data: Data) throws -> UInt16 {
        guard 2 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 2 else { throw BeaconParsingError.parseError }
        let result: UInt16 = try subdata.toInteger()
        return bigEndian ? result.bigEndian : result
    }
    
    func getValue(_ data: Data) throws -> Int16 {
        guard 2 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 2 else { throw BeaconParsingError.parseError }
        let result: Int16 = try subdata.toInteger()
        return bigEndian ? result.bigEndian : result
    }
    
    func getValue(_ data: Data) throws -> UInt32 {
        guard 4 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 4 else { throw BeaconParsingError.parseError }
        let result: UInt32 = try subdata.toInteger()
        return bigEndian ? result.bigEndian : result
    }
    
    func getValue(_ data: Data) throws -> Int32 {
        guard 4 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == 4 else { throw BeaconParsingError.parseError }
        let result: Int32 = try subdata.toInteger()
        return bigEndian ? result.bigEndian : result
    }
}

// MARK: Integer readers, Swift 3.1
@available(swift, deprecated: 3.2)
extension Data {
    func toInteger() throws -> UInt8 {
        guard 1 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toInteger() throws -> Int8 {
        guard 1 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toInteger() throws -> UInt16 {
        guard 2 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toInteger() throws -> Int16 {
        guard 2 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toInteger() throws -> UInt32 {
        guard 4 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func toInteger() throws -> Int32 {
        guard 4 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
}

#endif
