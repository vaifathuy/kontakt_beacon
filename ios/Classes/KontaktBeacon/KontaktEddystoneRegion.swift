//
//  KontaktEddystoneRegion.swift
//  kontakt_beacon
//
//  Created by Vaifat on 9/4/20.
//

import KontaktSDK

class KontaktEddystoneRegion: KTKEddystoneRegion{
    let uniqueID: String
    
    init(uniqueID: String, namespaceID: String, instanceID: String?) {
        self.uniqueID = uniqueID
        super.init(namespaceID: namespaceID, instanceID: instanceID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
