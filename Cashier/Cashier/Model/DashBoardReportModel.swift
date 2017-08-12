//
//  DashBoardReportModel.swift
//  Cashier
//
//  Created by sample on 23/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import Foundation

public struct DashBoardReportModel: Decodable {

	public var transactions: [Transaction]?

	public  init?(json: JSONOBJ) {
		
		transactions = "transactions" <~~ json

	}

}


public struct Transaction: Decodable {
	
	public var tranNum: String?
	public let custName: String?
	public var date: String?
	public let amount: String?

	public let status: String?

	
	
	public  init?(json: JSONOBJ) {
		
		tranNum = "tranNum" <~~ json
		custName = "custName" <~~ json
		date = "date" <~~ json
		amount = "amount" <~~ json
		status = "status" <~~ json

	}
	
	
}
