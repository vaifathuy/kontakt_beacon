//
//  BeaconFlutterResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

class BeaconFlutterResult: SwiftFlutterResult {
    internal var values: FlutterBeaconResponse

    init(values: FlutterBeaconResponse) {
        self.values = values
    }
    func result() -> SwiftFlutterJSON {
        return convertToJSON(value: values)
    }
    
    fileprivate func convertToJSON<T: Codable>(value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(value)
            if let json = String(data: data, encoding: .utf8) {
                return json
            }else {
                return nil
            }
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
