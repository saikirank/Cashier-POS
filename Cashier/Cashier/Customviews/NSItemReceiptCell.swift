//
//  NSItemReceiptCell.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit

class NSItemReceiptCell: NABaseTableViewCell {

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
