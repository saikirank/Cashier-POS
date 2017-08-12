//
//  Inventory.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import Foundation

public struct Inventory: Decodable {
    
    public let location: String?
    public let qtyAvailable: String?
    
    public init?(json: JSONOBJ) {
        location = "location" <~~ json
        qtyAvailable = "qtyAvailable" <~~ json
        
    }
    
}
