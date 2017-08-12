//
//  NSDecoratorView.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSDecoratorView: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	class func viewKind() -> String {
		return "decorator"
	}
}
