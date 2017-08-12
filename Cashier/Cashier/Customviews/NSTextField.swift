//
//  NSTextField.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit

enum TextFieldType {
    case none
    case email
    case quantity
    case price
	case tax
}

@IBDesignable
class NSTextField: UITextField {

    var indexPath : IndexPath?
    var textFieldtype : TextFieldType = .none

	@IBInspectable var  cornerRadius : Int = 20
    @IBInspectable var  bordorWidth : Int = 2

	override func awakeFromNib() {
		
		super.awakeFromNib()
        //7,117,128
		
		self.layer.cornerRadius = CGFloat(cornerRadius);
		self.layer.borderWidth = CGFloat(bordorWidth);
		self.layer.borderColor = BORDER_COLOR.cgColor;
        self.layer.shadowRadius = bordorWidth == 0 ? 0 : 1 ;
		
	}
    


}
