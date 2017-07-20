//
//  LayoutFragments.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

class LayoutFragment {
    let start: Int
    let end: Int
    var length: Int { return end - start + 1 }
    
    // swiftlint:disable:next force_try
    static let _regex = try! NSRegularExpression(pattern: "^([msipd])\\:([0-9]+)\\-([0-9]+)(?:\\=([0-9a-fA-F]+))?$", options: [])

    
    init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
    
    static func fragment(string: String) throws -> LayoutFragment {
        let matches = try LayoutFragment.matchingFragmentStrings(string: string)
        
        guard let start = Int(matches[1]) else { throw BeaconParsingError.incorrectFragmentSpecification }
        guard let end = Int(matches[2]) else { throw BeaconParsingError.incorrectFragmentSpecification }
        let match: Data?
        if matches.count == 4 {
            match = .from(hex: matches[3])
        } else {
            match = nil
        }

        switch matches[0] {
        case "m":
            return BeaconTypeFragment(start: start, end: end, match: match)
        case "i":
            return IdentifierFragment(start: start, end: end)
        case "d":
            return DataFieldFragment(start: start, end: end)
        case "p":
            return TxPowerFragment(start: start, end: end)
        default:
            throw BeaconParsingError.incorrectFragmentSpecification
        }
    }
    
    static func matchingFragmentStrings(string: String) throws -> [String] {
        guard let regexMatch = LayoutFragment._regex.matches(in: string, options: [], range: NSRange(location: 0, length: (string as NSString).length)).first else {
            throw BeaconParsingError.incorrectFragmentSpecification
        }
        guard [4, 5].contains(regexMatch.numberOfRanges) else { throw BeaconParsingError.incorrectFragmentSpecification }
        
        let matches = (1..<regexMatch.numberOfRanges).flatMap { (n: Int) -> String? in
            #if swift(>=4.0)
            let range = regexMatch.range(at: n)
            #else
            let range = regexMatch.rangeAt(n)
            #endif
            if range.location != NSNotFound {
                let r = string.index(string.startIndex, offsetBy: range.location)..<string.index(string.startIndex, offsetBy: range.location+range.length)
                return string.substring(with: r)
            }
            return nil
        }
        return matches
    }
}

class IntegerFragment: LayoutFragment {
    let bigEndian: Bool
    
    init(start: Int, end: Int, bigEndian: Bool = true) {
        self.bigEndian = bigEndian
        super.init(start: start, end: end)
    }
    
    func getValueAsInt(_ data: Data, signed: Bool) throws -> Int {
        switch length {
        case 1: return signed ? Int(try getValue(data) as Int8) : Int(try getValue(data) as UInt8)
        case 2: return signed ? Int(try getValue(data) as Int16) : Int(try getValue(data) as UInt16)
        case 4: return signed ? Int(try getValue(data) as Int32) : Int(try getValue(data) as UInt32)
        default: throw BeaconParsingError.incorrectFragmentSpecification
        }
    }
    
    #if swift(>=3.2)
    @available(swift, introduced: 3.2)
    func getValue<T>(_ data: Data) throws -> T where T: FixedWidthInteger {
        guard T.bitWidth / 8 == length else { throw BeaconParsingError.incorrectFragmentSpecification }
        let subdata = data.subdata(in: (start..<end + 1))
        guard subdata.count == T.bitWidth / 8 else { throw BeaconParsingError.parseError }
        let result: T = try subdata.toInteger()
        return bigEndian ? result.bigEndian : result
    }
    #endif
}

class PatternMatchingFragment: IntegerFragment {
    let match: Data?
    
    init(start: Int, end: Int, match: Data?) {
        self.match = match
        super.init(start: start, end: end)
    }
    
    override func getValueAsInt(_ data: Data, signed: Bool) throws -> Int {
        let result = try super.getValueAsInt(data, signed: signed)
        let subdata = data.subdata(in: (start..<end + 1))
        if let match = match, match != subdata { throw BeaconParsingError.fieldDoesNotMatch }
        return result
    }
}

class TxPowerFragment: IntegerFragment { }

class BeaconTypeFragment: PatternMatchingFragment {  }

class FieldFragment: LayoutFragment {
    let canBeShorter: Bool = true
    func getValue(_ data: Data) throws -> Data {
        var desiredRange = Range(start..<end + 1)
        guard start < data.endIndex else { throw BeaconParsingError.parseError }
        
        let availableRange = Range(start..<data.endIndex)
        
        if availableRange.count < desiredRange.count {
            if canBeShorter {
                desiredRange = availableRange
            } else {
                throw BeaconParsingError.parseError
            }
        }
        
        let subdata = data.subdata(in: desiredRange)
        return subdata
    }
}

class IdentifierFragment: FieldFragment { }

class DataFieldFragment: FieldFragment { }
