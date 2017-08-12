//
//  NSShipmentsCell.swift
//  Cashier
//
//  Created by sample on 23/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSShipmentsCell: NABaseTableViewCell {

	@IBOutlet weak var receiptTextField: UITextField!
	
	//Item return outlets
	@IBOutlet weak var selectBtn: NSButton!
	@IBOutlet weak var itemLabel: UILabel!
	
	@IBOutlet weak var customerLabel: UILabel!
	@IBOutlet weak var salesOrderLabel: UILabel!
	@IBOutlet weak var quantityTextField: NSTextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

}
