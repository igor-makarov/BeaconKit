//
//  Extensions.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

extension Data {
    #if swift(>=3.2)
    func toInteger<T>() throws -> T where T: FixedWidthInteger {
        guard T.bitWidth / 8 == self.count else { throw BeaconParsingError.parseError }
        return self.withUnsafeBytes { $0.pointee }
    }
    #else
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
    #endif
    static func from(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while hex.characters.count > 0 {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    func toString() -> String {
        return self.map { String(format: "%02hhX", $0) }.joined()
    }
}
