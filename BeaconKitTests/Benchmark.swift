//
//  Benchmark.swift
//
//  Created by Igor Makarov on 23/07/2017.
//  
//

import XCTest

class Benchmark {
    private static let _updateQueue = DispatchQueue(label: "updateQueue")
    private static var _measurements: [String: [Double]] = [:]
    
    private let _key: String
    private let _start: Date
    
    public static var averages: [String: Double] {
        let mapped = _measurements.map { (key: String, values: [Double]) -> (String, Double) in
            let average = values.reduce(0, +) / Double(values.count)
            return (key, average)
        }
        return Dictionary(uniqueKeysWithValues: mapped)
    }
    
    init(name: String? = nil) {
        self._key = name ?? Thread.callStackSymbols.joined()
        self._start = Date()
    }
    
    deinit {
        let key = _key
        let start = _start
        let end = Date()
        Benchmark._updateQueue.async {
            Benchmark._update(key: key, start: start, end: end)
        }
    }
    
    private static func _update(key: String, start: Date, end: Date) {
        var measurements: [Double]
        if let existingMeasurements = _measurements[key] {
            measurements = existingMeasurements
        } else {
            measurements = []
        }
        let interval = end.timeIntervalSince(start)
        measurements += [interval]
        _measurements[key] = measurements
    }
    
    public static func assert(key: String, expected: Double, margin: Double = 0.1) {
        guard let benchmark = Benchmark.averages[key] else {
            XCTFail("Benchmark \"\(key)\" does not exist")
            return
        }
        let fraction = benchmark / expected
        let percent = String(format: "%.2f", 100*(fraction - 1.0))
        if abs(fraction - 1.0) >= margin {
            XCTFail("Benchmark \(benchmark) deviates from expected value \(expected) by \(percent)%")
        } else {
            print("Benchmark \(benchmark): \(benchmark), expected value: \(expected) (\(percent)%)")
        }
    }
}
