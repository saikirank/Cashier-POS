//
//  Locations.swift
//  Cashier
//
//  Created by sample on 08/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import Foundation

public struct Locations: Decodable {

	public var locations: [Location]?
	
	
	public  init?(json: JSONOBJ) {
		
		locations = "locations" <~~ json
		
	}

	
}

public struct Location: Decodable {
	
	public var id: String?
	public let name: String?
	
	
	public  init?(json: JSONOBJ) {
		
		id = "id" <~~ json
		name = "name" <~~ json
		
	}
	
	
}



