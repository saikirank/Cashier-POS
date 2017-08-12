//
//  NSItemLookUpVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSItemLookUpVC: NSBaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ConenctionDelegate {

    
    var iteminfo : ItemInfo? = nil
    
    @IBOutlet weak var header1: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var upcName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var itemImageView: UIImageView!

    var selectedUPC : String?
	
	@IBOutlet var tableview: UITableView!


	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.tableview.layer.borderWidth = 1.0
		self.tableview.separatorStyle = .none;
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.header1.text = "Location"
        self.header2.text = "Available"
        self.tableview.separatorStyle = .singleLine
		self.tableview.separatorColor = bgColor
		self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		self.tableview.tableFooterView = UIView(frame: .zero)

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.iteminfo?.item?.inventory?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		
        if let leftLabel = cell?.contentView.viewWithTag(100) as? UILabel {
            
            leftLabel.text = self.iteminfo?.item?.inventory?[indexPath.row].location ?? ""
        }

        if let rhsfield = cell?.contentView.viewWithTag(101) as? UITextField {
            
            
            rhsfield.text = self.iteminfo?.item?.inventory?[indexPath.row].qtyAvailable ?? ""

        }
		return cell ?? UITableViewCell()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return true
	}
	
	
	@IBAction func actionBackClicked(_ sender: AnyObject) {
		_ = navigationController?.popViewController(animated: true)
	}
	
	func updateInfoOnScreen() {
		
		itemName.text = self.iteminfo?.item?.itemid ?? ""
		priceLabel.text = self.iteminfo?.item?.baseprice ?? ""
		descriptionLabel.text = self.iteminfo?.item?.salesdescription ?? ""
		upcName.text = self.selectedUPC ?? ""
		
		if let imageURL = self.iteminfo?.item?.imageURL  {
			itemImageView.downloadedFrom(imageURL , contentMode: .scaleAspectFit)
		}
		
		self.tableview.reloadData()
	}
	
	
	
	@IBAction func addItemPopup(_ sender: AnyObject) {
		
		Utilities.sharedInstance.addItemPopup(sender, targetVC: self, textfieldPlaceholder: "ID", barcodeAlertTitle: "Enter the code") { (  str) in
			
			self.iteminfo = nil
			
			DispatchQueue.main.async {
				self.updateInfoOnScreen()
			}
			
			
			print("str /(str)");
			//            str = "080095301283"
			//            str = "080095301287"
			//            str = "080095301287"
			//
			//            str = "080095301268"//working
			self.selectedUPC = str
			Connection.sharedInstance.targetVC = self
			
			Connection.sharedInstance.delegate = self;
			Connection.sharedInstance.itemlookUp(str!,target : self, competion: { (connectionType, json, error) in
				
				if let unerror = error {
					Utilities.sharedInstance.processErrorResponse(unerror, target: self)
				}
				
				guard let iteminfo = ItemInfo(json: json!), json != nil else {
					print("Error initializing object")
					
					return
				}
				self.iteminfo = iteminfo
				
				DispatchQueue.main.async {
					self.updateInfoOnScreen()
				}
				
				
			})
			
		}
		
		
	}

	
	func connectioDidFail(_ repsonse:Any?,connectiontype: ConnectionType) {
		print(repsonse as Any )
		
		Utilities.sharedInstance.processErrorResponse(repsonse, target: self)
		
	}
	
	func connectioDidReceiveResponse(_ json: [String: AnyObject],
	                                 connectiontype: ConnectionType) {
		print(iteminfo as Any )
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
