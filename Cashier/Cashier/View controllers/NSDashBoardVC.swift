//
//  NSDashBoardVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSDashBoardVC: NSBaseVC , UITableViewDataSource, UITableViewDelegate {

	enum HOME_SCREEN_OPTIONS : Int  {
		case dashboard 
		case itemlookup
		case salesorder
		case shipment
		case purchaseorder
		case itemreceipt 
		case itemReturns
		
		func title() -> String {
			
			switch self {
			case .dashboard : return  "DASHBOARD"
			case .itemlookup : return "ITEM LOOKUP"
			case .salesorder : return "SALES ORDER"
			case .shipment : return "SHIPMENT"
			case .purchaseorder : return "PURCHASE ORDER"
			case .itemreceipt : return "ITEM RECEIPT"
			case .itemReturns : return "RETURN"
			
			}

		}
		
		static func count() -> Int {
			return 7
		}
		
		
	}
	
	@IBOutlet var tableView: UITableView!
	
	let options = [ "DASHBOARD", "ITEM LOOKUP", "SALES ORDER", "SHIPMENT", "PURCHASE ORDER", "ITEM RECEIPT", "RETURN"]
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		UserModelManager.sharedInstance.shippingAddress  = [String :String]();
		
	}

	
	

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let view = UIView(frame: CGRect(x: 0,y: 0,width: tableView.frame.width, height: 0))
		view.backgroundColor = UIColor.white

		navigationItem.hidesBackButton = true
		let option = HOME_SCREEN_OPTIONS(rawValue: 1)
		print(option!.title())
		
//		tableView.tableHeaderView = UIView(frame: CGRectZero)
		tableView.tableFooterView = view
		tableView.separatorColor = UIColor.white
		tableView.tableHeaderView?.backgroundColor = UIColor.white
		tableView.tableFooterView?.backgroundColor = UIColor.white
		tableView.backgroundColor = bgColor
		

		
		// Do any additional setup after loading the view.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return HOME_SCREEN_OPTIONS.count();
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//totalheight-30 
		
		
		let footerheight = ((tableView.tableFooterView?.frame) ?? CGRect.zero).height
		let headerheight = ((tableView.tableHeaderView?.frame) ?? CGRect.zero).height

		let rem = CGFloat( CGFloat ( 10 * (options.count + 1)) - (footerheight ) - (headerheight ))
		
		return (tableView.frame.height  - rem) / CGFloat(options.count)
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		if let label = cell.contentView.viewWithTag(100) as? UILabel {
			//label.text = options[indexPath.row]
			
			
			if let option = HOME_SCREEN_OPTIONS(rawValue: indexPath.row)?.title{
				label.text = option()

			}

			
		}
		
		let bgColorView = UIView()
		bgColorView.backgroundColor = UIColor(red: 73/255.0, green: 92/255.0, blue: 124/255.0, alpha: 1.0)
		cell.selectedBackgroundView = bgColorView
		return cell;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: false)
		//return;
		
		if let option = HOME_SCREEN_OPTIONS(rawValue: indexPath.row) {
			var storyBoardIdentifier = ""
			switch option {
			case .dashboard: storyBoardIdentifier = "gotoItemLookup"
			case .itemlookup: storyBoardIdentifier = "gotoItemLookup"
				case .itemreceipt: storyBoardIdentifier = "gotoItemReceipts"
				case.purchaseorder: storyBoardIdentifier = "gotoSalesOrder"
			case.salesorder: storyBoardIdentifier = "gotoSalesOrder"
			case.itemReturns: storyBoardIdentifier = "gotoItemReturns"
			case.shipment: storyBoardIdentifier = "gotoShipments"

				
			}
			
			
            
            if  HOME_SCREEN_OPTIONS(rawValue: indexPath.row)  == .purchaseorder {
                
               let vc =  self.storyboard?.instantiateViewController(withIdentifier: "NSSalesOrderVC") as? NSSalesOrderVC
                vc!.isPurchaseOrder = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }
			else             if  HOME_SCREEN_OPTIONS(rawValue: indexPath.row)  == .dashboard {
				
				let vc =  self.storyboard?.instantiateViewController(withIdentifier: "NSDashBoardReportsVC")
				self.navigationController?.pushViewController(vc!, animated: true)
			}

            else {
			
			self.performSegue(withIdentifier: storyBoardIdentifier, sender: self)
            }
		}

		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
