//
//  ParserLayout.swift
//
//  Created by Igor Makarov on 19/07/2017.
//

import Foundation

public class ParserLayout {
    let fragments: [LayoutFragment]
    let typeFragment: BeaconTypeFragment
    let txPowerFragment: TxPowerFragment
    
    public init(_ pattern: String) throws {
        self.fragments = try pattern.components(separatedBy: ",").map { string in
            return try LayoutFragment.fragment(string: string)
        }
        
        let typeFragments = self.fragments.flatMap { fragment -> BeaconTypeFragment? in fragment as? BeaconTypeFragment }
        guard let typeFragment = typeFragments.first, typeFragments.count == 1 else { throw BeaconParsingError.incorrectFragmentSpecification }
        self.typeFragment = typeFragment
        
        let txPowerFragments = self.fragments.flatMap { fragment -> TxPowerFragment? in fragment as? TxPowerFragment }
        guard let txPowerFragment = txPowerFragments.first, txPowerFragments.count == 1 else { throw BeaconParsingError.incorrectFragmentSpecification }
        self.txPowerFragment = txPowerFragment
    }
    
    func parse(_ data: Data) throws -> BeaconRawData {
        var identifiers = [Data]()
        var fields = [Data]()
        
        let type = try typeFragment.getValueAsInt(data, signed: false)
        let txPower = try txPowerFragment.getValueAsInt(data, signed: true)
        
        for fragment in fragments {
            switch fragment {
            case let identifierFragment as IdentifierFragment:
                let identifier = try identifierFragment.getValue(data)
                identifiers.append(identifier)
            case let dataFieldFragment as DataFieldFragment:
                let field = try dataFieldFragment.getValue(data)
                fields.append(field)
            default: break
            }
        }
        
        return BeaconRawData(type: type, txPower: txPower, identifiers: identifiers, fields: fields)
    }
}
