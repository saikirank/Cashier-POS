//
//  NSDashBoardReportCell.swift
//  Cashier
//
//  Created by sample on 23/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSDashBoardReportCell: NABaseTableViewCell {

	@IBOutlet var statusLabel: UILabel!
	@IBOutlet var custNameLabel: UILabel!
	@IBOutlet var transcationLabel: UILabel!
	@IBOutlet var amountLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
