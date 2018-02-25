//
//  Debug.swift
//
//  Created by Igor Makarov on 29/08/2017.
//  
//

import Foundation

internal func beaconKitGetSwiftVersion() -> String {
    #if swift(>=3.2)
        #if swift(>=4.0)
            let swiftVersion = "4.0"
        #else
            let swiftVersion = "3.2"
        #endif
    #else
        let swiftVersion = "3.1"
    #endif
    return swiftVersion
}
