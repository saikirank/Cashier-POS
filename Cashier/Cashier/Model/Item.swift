//
//  Item.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import Foundation

public struct Item: Decodable {
    
    public var inventory: [Inventory]?
    
    
    public var itemid: String?
    public let salesdescription: String?
    public let baseprice: String?
    public let imageURL: AnyObject?
  
    //fields for sales order
    public let displayname: String?
    public var quantity: String?
    public var price: String?
    public var orderQty: String = "1"

    //item receipt fields
    
    public let itemName: String?
    
    public let ponum: String?
    public let sonum: String?

    public var itemreceiptQty: String?
    public var custName: String?

    public var selected: Bool?
    /*
     {“status”:”success”,"itemid":"1234","displayname":"computer","quantity":"2",”price”:”1.50”}

 */
    
    public init?(json: JSONOBJ) {
        
        itemid = "itemid" <~~ json
        inventory = "inventory" <~~ json
        baseprice = "baseprice" <~~ json

        salesdescription = "salesdescription" <~~ json
        imageURL = "storedisplaythumbnail" <~~ json
       
        
        displayname = "displayname" <~~ json
        quantity = "availqty" <~~ json

        price = "price" <~~ json

        //item receipt fields

        
        itemName = "itemName" <~~ json
        ponum = "poNum" <~~ json
        
        itemreceiptQty = "quantity" <~~ json

        
        //shipment
        sonum = "sonum" <~~ json
        
        custName = "custName" <~~ json


    }
    /*
     // 1
     public let name: String
     public let link: String
     
     public init?(json: JSON) {
     // 2
     guard let container: JSON = "im:name" <~~ json, let id: JSON = "id" <~~ json else { return nil }
     guard let name: String = "label" <~~ container, link: String = "label" <~~ id else { return nil }
     
     self.name = name
     self.link = link
     }
 */
    
}
