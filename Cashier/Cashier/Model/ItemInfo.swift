//
//  ItemInfo.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import Foundation

public typealias JSONOBJ = [String : AnyObject]

public struct ItemInfo: Decodable {
    
    public let item: Item?
    public let items: [Item]?

    public init?(json: JSONOBJ) {
        item = "itemInfo" <~~ json
        items = "itemData" <~~ json

    }
    
}
