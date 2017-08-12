//
//  NSItemReceiptVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSShipmentsVC: NSBaseVC , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ConenctionDelegate {
    @IBOutlet weak var headerLb2: UILabel!
    @IBOutlet weak var headerLb3: UILabel!
	@IBOutlet weak var headerLb4: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerLb1: UILabel!
    
    var selectedOrderNo : String?
    var selectedItemType : ItemType = ItemType.Item
    
    var items  =  [Item]()
    
    @IBAction func ItemDidSelect(_ sender: NSButton) {
        
        sender.isSelected = sender.isSelected ? false : true
        
        if let indexPath = sender.indexPath {
            
            items[indexPath.row].selected = sender.isSelected
        }
        
        
        
    }
    func connectioDidFail(_ repsonse:Any?,connectiontype: ConnectionType) {
        print(repsonse as Any)
    }
    func connectioDidReceiveResponse(_ json: [String : AnyObject],connectiontype: ConnectionType) {
        print(json)
		
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.items = [Item]()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableView.layer.borderWidth = 1.0
        self.tableView.separatorStyle = .none;
		self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.headerLb1.text = "Select"
        self.headerLb2.text = "Item"
        self.headerLb3.text = "Order#"
		self.headerLb4.text = "Quantity"

		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = bgColor
		self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		self.tableView.tableFooterView = UIView(frame: .zero)

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
		}
		
		return bool
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let tf = textField as? NSTextField, let indexPath = tf.indexPath  {
			if tf.textFieldtype == .quantity {
				items[indexPath.row].itemreceiptQty = textField.text!
			}
			else  if tf.textFieldtype == .price {
				items[indexPath.row].price = textField.text
			}
			print(items[indexPath.row])
		}
	}
    @IBAction func submit(_ sender: AnyObject) {
		
		
        var selectedItems = [[String :String]]()
        for item in items {
			
            if item.selected == true {
				
                var dict  = [String :String]()
                
                dict["soNum"] = item.sonum ?? ""
                dict["itemId"] = item.itemid ?? ""
                dict["quantity"] = item.itemreceiptQty ?? ""
                selectedItems.append(dict)
            }
            
        }
		if selectedItems.count == 0 {
			Utilities.sharedInstance.showAlert("Please add items before submitting Item shipment", btnTitle: "Ok", targetVC: self)
			return
		}
        let request = ["event" : "shipment",  "items" : selectedItems ] as [String : Any]
        Connection.sharedInstance.targetVC = self

        Connection.sharedInstance.delegate = self
        Connection.sharedInstance.targetVC = self
        Connection.sharedInstance.submitItemReceiptDetails(request as NSDictionary,target : self) { (connectionType, json, error) in
            
            if let unerror = error {
                Utilities.sharedInstance.processErrorResponse(unerror, target: self)
            }

            
        }
        
    }
    
    @IBAction func addItem(_ sender: AnyObject) {
        
        
        
        Utilities.sharedInstance.showAlert(sender, title : "Choose Item type", option1: "Item", block1: {
            self.selectedItemType = ItemType.Item
            self.showAddItemPopUP(sender)
            }, option2: "SO#", block2: {
                
                self.selectedItemType = ItemType.SO
                self.showAddItemPopUP(sender)
                
            }, targetVC: self)
        
        
        
        
    }
    
    func showAddItemPopUP(_ sender: AnyObject)  {
        
        Utilities.sharedInstance.addItemPopup(sender, targetVC: self, textfieldPlaceholder: "ID", barcodeAlertTitle: "Enter the code") { (  str) in
            
            print("str /(str)");
          //  str = "080095301283"
          //  str = "080095301287"
          //  str = "080095301287"
            
          //  str = "080095301268"//working
            self.selectedOrderNo = str
            
          //  str = self.selectedItemType == .Item ? "080095301268" : "PUR00001338"
            Connection.sharedInstance.delegate = self;
            Connection.sharedInstance.targetVC = self
            Connection.sharedInstance.getItemInformation(ReceiptType.shipment, itemType: self.selectedItemType, upc: str!, target :self,completion: { (connectionType, json, error) in
                
                print(json as Any)
                
                if let unerror = error {
                    
                    print("unerror \(unerror)")
                    return;
                }
                
                guard let iteminfo = ItemInfo(json: json!), json != nil else {
                    print("Error initializing object")
                    
                    return
                }
                
                if let unitems =  iteminfo.items {
                    self.items.append(contentsOf: unitems)
                    
                }
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                })
                
                
                print(iteminfo)
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NSShipmentsCell
        
        cell?.itemLabel.text = items[indexPath.row].itemName ?? ""
        cell?.salesOrderLabel.text = items[indexPath.row].sonum ?? ""
        cell?.selectBtn.indexPath = indexPath
		cell?.quantityTextField.textFieldtype = .quantity
		cell?.quantityTextField.indexPath = indexPath
		cell?.quantityTextField.text = items[indexPath.row].itemreceiptQty ?? ""

		
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
