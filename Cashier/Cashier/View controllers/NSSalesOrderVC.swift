//
//  NSSalesOrderVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class NSSalesOrderVC: NSBaseVC , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate , ConenctionDelegate {
    @IBOutlet weak var screentitleLabel: UILabel!
	@IBOutlet var namefield: NSTextField!
    @IBOutlet weak var ignoreButton: NSButton!
    @IBOutlet weak var ignoreCustLabel: UILabel!
	@IBOutlet weak var headerLb1: UILabel!

	@IBOutlet weak var headerLb2: UILabel!
	@IBOutlet weak var headerLb3: UILabel!
	@IBOutlet weak var headerLb4: UILabel!

	@IBOutlet weak var headerLb5: UILabel!

	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet var shippingAddressTextView: NSTextView!
	@IBOutlet var emailField: NSTextField!
	@IBOutlet var addShippingAdress: NSButton!
    
    var isPurchaseOrder : Bool = false
    
    var items = [Item]()
	
	@IBOutlet var taxTextField: NSTextField!
	
	@IBOutlet var subTotalLabel: UILabel!
	
	@IBOutlet var total: UILabel!
	
	
	@IBOutlet var summaryView: UIView!
	@IBOutlet var cashSaleLabel: UILabel!
	@IBOutlet var cashSaleBtn: NSButton!
	@IBOutlet var submitBtnYPos: NSLayoutConstraint!
	@IBOutlet var tableViewHeightConstant: NSLayoutConstraint!
	
	@IBOutlet var inventoryButton: NSRoundedButton!
	@IBOutlet var inventoryLabel: UILabel!
	@IBOutlet var tableToSubmitBottomConstraint: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.tableView.layer.borderWidth = 1.0
		self.tableView.separatorStyle = .none;
		self.tableView.rowHeight = UITableViewAutomaticDimension
        shippingAddressTextView.text = UserModelManager.sharedInstance.getAddressDescrition()
		shippingAddressTextView.delegate = self
		if shippingAddressTextView.text.characters.count == 0 {
			shippingAddressTextView.text = "Shipping Address"
			shippingAddressTextView.textColor = UIColor.lightGray
		}
		else {
			shippingAddressTextView.textColor = UIColor.black

		}
        
        UserModelManager.sharedInstance.shippingAddress  = [String :String]();
        if isPurchaseOrder {
            screentitleLabel.text = "Purchase Order/Inventory Count"
            ignoreCustLabel.text = "Guest Vendor"
			cashSaleLabel.isHidden = true
			cashSaleBtn.isHidden = true
			summaryView.isHidden = true
			summaryView.removeConstraints(summaryView.constraints)

			//submitBtnYPos.constant -= CGRectGetHeight(summaryView.frame)+40;
			submitBtnYPos.constant -= 120;
			tableToSubmitBottomConstraint.priority = 1000
			//tableToSubmitBottomConstraint.constant = 10
        }
		else {
            ignoreCustLabel.text = "Guest Customer"

			subTotalLabel.text = ""
			taxTextField.text = ""
			total.text = ""
			taxTextField.textFieldtype = .tax
			taxTextField.delegate = self
			tableToSubmitBottomConstraint.priority = 1
			inventoryLabel.isHidden = true
			inventoryButton.isHidden = true

		}
		
		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = bgColor
		self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		self.tableView.tableFooterView = UIView(frame: .zero)

		
		
	}
	
	@IBAction func actionInventorySale(_ sender: UIButton) {
		
		sender.isSelected = sender.isSelected ? false : true

	}
	override func viewWillAppear(_ animated: Bool) {
		
		
		if isPurchaseOrder {
			screentitleLabel.text = "Purchase Order/Inventory Count"
			ignoreCustLabel.text = "Guest Vendor"
			cashSaleLabel.isHidden = true
			cashSaleBtn.isHidden = true
			summaryView.isHidden = true
			summaryView.removeConstraints(summaryView.constraints)
			tableViewHeightConstant.constant=summaryView.frame.height
			//submitBtnYPos.constant -= CGRectGetHeight(summaryView.frame)+20;
			tableToSubmitBottomConstraint.priority = 900

		}
		else {
			tableToSubmitBottomConstraint.priority = 1
			inventoryLabel.isHidden = true
			inventoryButton.isHidden = true

		}
		
	}
	


	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		


        var bool = true;
        if let tf = textField as? NSTextField, (tf.textFieldtype == .quantity  || tf.textFieldtype == .price ) && string != ""  {
           
            
            let emailRegEx = "\\b([0-9%_.+\\-]+)\\b"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let str = textField.text! + string
            bool = emailTest.evaluate(with: str)
			
			if bool {
    if let tf = textField as? NSTextField, let indexPath = tf.indexPath  {
		
		if tf.textFieldtype == .quantity && self.isPurchaseOrder == false {
			
			if let quan = Int(items[indexPath.row].quantity ??  "0")
			{
				if quan < Int(str ) {
					bool = false
				}

			}
			
			
		}
				}
			}
			
			
        }
			
		return bool
	}
		
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if let tf = textField as? NSTextField, let indexPath = tf.indexPath  {
            
            if tf.textFieldtype == .quantity {
                
                items[indexPath.row].orderQty = textField.text!

            }
           else  if tf.textFieldtype == .price {
                
                items[indexPath.row].price = textField.text
				
            }

            self.tableView.reloadRows(at: [tf.indexPath! as IndexPath], with: .none)
			if self.isPurchaseOrder == false {
				computeTotal()
			}
	

            print(items[indexPath.row])
        }
		
		if textField === self.taxTextField {
			computeTotal()
		}
    }
    
    
    func connectioDidFail(_ repsonse:Any?,connectiontype: ConnectionType){
        print(repsonse as Any as Any)
        
        Utilities.sharedInstance.processErrorResponse(repsonse, target: self)
        
    }
    func connectioDidReceiveResponse(_ json: [String : AnyObject], connectiontype: ConnectionType) {
        
        
    }
    
    @IBAction func unwindFromShippingAddressScreen(_ segue: UIStoryboardSegue ) {
        
        if segue.identifier == "shippingToSalesOrder" {
            
            shippingAddressTextView.text = UserModelManager.sharedInstance.getAddressDescrition()
            
        }
    }
    
    @IBAction func ignoreCustomer(_ sender: UIButton) {
        
        sender.isSelected = sender.isSelected ? false : true
        
    }

    
	@IBAction func actionCashSale(_ sender: UIButton) {
		sender.isSelected = sender.isSelected ? false : true

	}
	
	@IBAction func submit(_ sender: AnyObject) {
        
        self.tableView.endEditing(true)
		if items.count == 0 {
			Utilities.sharedInstance.showAlert("Add Items to the sales order", btnTitle: "Ok", targetVC: self)
		}
		else if isPurchaseOrder == false && total.text! == "0.00" {
			Utilities.sharedInstance.showAlert("Total price should not be zero", btnTitle: "Ok", targetVC: self)
			
		}

		else if (self.isPurchaseOrder == false &&  self.cashSaleBtn.isSelected) {
			performSubmissionOperation()
		}
		else if ignoreButton.isSelected == true {
			performSubmissionOperation()
		}
        else if namefield.text?.characters.count == 0 {
            namefield.becomeFirstResponder()
        }
        else if emailField.text?.characters.count == 0 || Utilities.sharedInstance.isValidEmail(emailField.text!,targetVC:self ) == false {
            emailField.becomeFirstResponder()
        }
		/*else if ignoreButton.selected == false && UserModelManager.sharedInstance.shippingAddress.count == 0 {
            let str = isPurchaseOrder ? "Vendor" : "Customer"
            Utilities.sharedInstance.showAlert("Please add shipping address or select option to ignore \(str)", btnTitle: "Ok", targetVC: self)
        }*/
        else  {
            
			performSubmissionOperation()
           
        }
        
	}
	
	func computeTotal()  {
		
		if self.isPurchaseOrder {
			
			return
		}
		var  subTotal : Float = 0.0;
		
		for item in items {
			var itemdict  = [String :String]()
			itemdict["price"] = item.price
			itemdict["quantity"] = item.orderQty
			itemdict["itemId"] = item.itemid
			let price  = (item.price?.floatValue ?? Float(0))
			let qty = (item.orderQty.floatValue )
			subTotal += price*qty
			
		}
		let formatter = NumberFormatter()

		formatter.maximumFractionDigits = 2
		
  let subTotalStr =		formatter.string(from: NSNumber(value: subTotal as Float))
		subTotalLabel!.textColor = UIColor.black
		subTotalLabel!.text! = subTotalStr!


			
		let tax = ((taxTextField.text?.characters.count) != nil) ? (taxTextField.text!.floatValue) : 0
		let totalFloat = subTotal + (tax * subTotal)/100
		total!.text! = String(totalFloat) 
total.text! = String(format: "%0.2f", totalFloat)
		
		//let taxString = taxTextField.text.characters.count ? taxTextField.text : "0"
		//let totalFloat = subTotal + (taxString.floatValue)*subTotal
		//total.text = String(totalFloat)
	}
	
	func performSubmissionOperation()
	{
		
		let dict = NSMutableDictionary()
		dict["customername"] = namefield!.text
		dict["name"] = namefield!.text
		
		dict["lastname"] = namefield!.text
		dict["firstname"] = namefield!.text
		dict["phone"] = "9867453214"
		
		dict["event"] = self.isPurchaseOrder ? "purchaseorder" :"salesorder"
		dict["ignoreAdress"] = ignoreButton.isSelected ? "true" : "false"
		dict["email"] = emailField!.text
		dict["empId"] = UserModelManager.sharedInstance.profiledata?.empId ?? "1646"
		
		
		if self.isPurchaseOrder == false {
			dict["fulfilled"] = self.cashSaleBtn.isSelected ? "true" : "false"
		}
		//  dict["fulfilled"] = "true"
		
		if self.isPurchaseOrder == true {
			dict["isAdjustment"] = self.inventoryButton.isSelected ? "true" : "false"
		}

		if UserModelManager.sharedInstance.shippingAddress.count > 0 {
			dict["address"] = UserModelManager.sharedInstance.shippingAddress
			dict["ignoreAdress"] = "false"
			
		}
		
		
		
		var selectedItems = [[String :String]]()
		for item in items {
			var itemdict  = [String :String]()
			itemdict["price"] = item.price
			itemdict["quantity"] = item.orderQty
			itemdict["itemId"] = item.itemid
			selectedItems.append(itemdict)
		}
		dict["items"] = selectedItems
        
        
        if isPurchaseOrder == false {
            let tax = ((taxTextField.text?.characters.count) != nil) ? (taxTextField.text!.floatValue) : 0
            
            dict["taxpercent"] = tax
           /// dict["totalPrice"] = total.text!
        }
        
        
        
		Connection.sharedInstance.targetVC = self
		Connection.sharedInstance.submitSalesOrder(dict, target:self, completion: { (connectionType, json, error) in
			
			if let unjso = json, let status = unjso["status"] as? String, status  == "Success", let message = unjso["message"]  as? String {
				
				

				DispatchQueue.main.async(execute: {
					_ = self.navigationController?.popViewController(animated: true);
					
				})
				
				
				
				print("error response")
				
			}
			else {
				Utilities.sharedInstance.showAlert("", msg: "Error processing your request.", btnTitle: "Ok", targetVC:self ){
					
				}
				
			}
			
			
			print(json as Any as Any);
		})
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Shipping Address"{
			textView.text = ""
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.characters.count == 0{
			textView.text = "Shipping Address"
			textView.textColor = UIColor.lightGray
		}
	}
	

	@IBAction func addItem(_ sender: AnyObject) {
		
        Utilities.sharedInstance.addItemPopup(sender, targetVC: self, textfieldPlaceholder: "ID", barcodeAlertTitle: "Enter the code") { (  str) in
			
            print("str /(str)");
           // str = "080095301283"
            //str = "080095301287"
            //str = "080095301287"
			
           // str = "080095301268"//working
           // self.selectedOrderNo = str
			
           // str = self.selectedItemType == .Item ? "080095301268" : "PUR00001338"
            Connection.sharedInstance.targetVC = self

            Connection.sharedInstance.delegate = self;
            let type : ConnectionType = self.isPurchaseOrder ? .additem_PURCHASEORDER : .additem_SALESORDER
            Connection.sharedInstance.addItemtoSalesOrder(str!,
            target : self, connectionType: type, completion: { (connectionType, json, error) in
                
                
                guard let iteminfo = Item(json: json!), json != nil else {
                    print("Error initializing object")
                    
                    return
                }
                
                print(iteminfo)
				var itemFound = false;
				
			
				for (index, _) in self.items.enumerated() {
			//	for var item in self.items{
					var item = self.items[index]
					if item.itemid! == iteminfo.itemid {
						 let qty =  Int(item.orderQty)! + Int(iteminfo.orderQty)!
						item.orderQty = String(qty)
						itemFound = true
						self.items[index] = item
						
						break;
						
					}
				}
				if itemFound == false {
                self.items.append(iteminfo)
				}
				
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
					if self.isPurchaseOrder == false {
						self.computeTotal()
					}

					
                })

                
            })
            
        }

        
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let action = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
			print("perform delete action")
			
			self.items.remove(at: indexPath.row)
			tableView.reloadData()
			if self.isPurchaseOrder == false {
			self.computeTotal()
			}
		}
		
		return [action]
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NSSalesOrderTBCell
		//cell?.backgroundColor = UIColor.redColor()
		let item = items[indexPath.row]
        cell?.nameLabel.text = item.displayname ?? ""
        cell?.availableQty.text = item.quantity ?? ""
		cell?.availableQty.isUserInteractionEnabled = false
        cell?.price.text = item.price ?? ""
        cell?.orderQty.text = item.orderQty
        cell?.orderQty.indexPath = indexPath
        cell?.orderQty.textFieldtype = .quantity
        cell?.price.textFieldtype = .price
        cell?.price.indexPath = indexPath
		cell?.orderQty.text = item.orderQty
        if let priceinfo = item.price {
            cell?.priceLabel.text =  String( Float(item.orderQty)! * Float( priceinfo)!)

        }
		
		if let imageURL = item.imageURL  {
			cell?.imgView.downloadedFrom(imageURL , contentMode: .scaleAspectFit)
		}

		cell?.selectionStyle = .none
		

        //    case QUANTITY
        //case PRICE

		return cell!
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

extension String {
	var floatValue: Float {
		return (self as NSString).floatValue
	}
}
