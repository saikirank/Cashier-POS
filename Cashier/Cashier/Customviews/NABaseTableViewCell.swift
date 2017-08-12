//
//  NABaseTableViewCell.swift
//  Cashier
//
//  Created by sample on 23/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NABaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.preservesSuperviewLayoutMargins = false
		self.layoutMargins = UIEdgeInsets.zero;
		self.separatorInset = UIEdgeInsets.zero

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
