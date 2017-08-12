//
//  UserModek.swift
//  Cashier
//
//  Created by sample on 08/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import Foundation

public struct ProfileModel: Decodable {

	
	public var storeName: String?
	public let storeId: String?
	public let empId: String?
	public let empName: String?
	
	//fields for sales order
	public let address: String?

	
	  public  init?(json: JSONOBJ) {
		
		storeName = "storeName" <~~ json
		storeId = "storeId" <~~ json
		empId = "empId" <~~ json
		
		empName = "empName" <~~ json
		address = "address" <~~ json
		
	}

}
