//
//  NSSalesOrderTBCell.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit

class NSSalesOrderTBCell: NABaseTableViewCell {
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderQty: NSTextField!
    @IBOutlet weak var price: NSTextField!
    @IBOutlet weak var availableQty: UITextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

}
