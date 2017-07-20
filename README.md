# BeaconKit [![Build Status](https://travis-ci.org/igor-makarov/BeaconKit.svg?branch=master)](https://travis-ci.org/igor-makarov/BeaconKit) ![Current Version](https://img.shields.io/github/tag/igor-makarov/BeaconKit.svg?label=Current%20Version)
iOS Beacon framework using BTLE
## TL;DR
This is a framework that wraps around CoreBluetooth and detects beacons of different types.

The currently supported types are: **Eddystone-UID**, **Eddystone-URL** & **AltBeacon**.

It's not possible to detect iBeacons using CoreBluetooth on iOS (see [this explanation](http://developer.radiusnetworks.com/2013/10/21/corebluetooth-doesnt-let-you-see-ibeacons.html) for more info).

Only foreground operation is supported, but I plan on adding background detection of Eddystones (it's not possible to detect AltBeacons in the bacground).
## Usage
Activating:
```
BeaconScanner.shared.delegate = self
BeaconScanner.shared.start()
```
Deactivating:
```
BeaconScanner.shared.stop()
```
## Supported Beacon Types
* Eddystone-UID
* Eddystone-URL
* AltBeacon
## Known Unsupported Beacon Types
* Eddystone-TLM (not an actual beacon)
* iBeacon (Apple limitation)

