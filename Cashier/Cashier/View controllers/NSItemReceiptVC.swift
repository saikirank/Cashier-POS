//
//  NSItemReceiptVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSItemReceiptVC: NSBaseVC , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ConenctionDelegate {
    @IBOutlet weak var headerLb2: UILabel!
    @IBOutlet weak var headerLb3: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var headerLb1: UILabel!
	@IBOutlet weak var headerLb4: UILabel!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.layer.borderWidth = 1.0
        self.tableView.separatorStyle = .none;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.headerLb1.text = "Select"
        self.headerLb2.text = "Item"
        self.headerLb3.text = "Order #"
		self.headerLb4.text = "Quantity"

		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = bgColor
		self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		self.tableView.tableFooterView = UIView(frame: .zero)
		self.tableView!.dataSource = self
		self.tableView!.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		
		
		var bool = true;
		if let tf = textField as? NSTextField, (tf.textFieldtype == .quantity  || tf.textFieldtype == .price ) && string != ""  {
			
			let numberRegEX = "\\b([0-9%_.+\\-]+)\\b"
			
			let emailTest = NSPredicate(format:"SELF MATCHES %@", numberRegEX)
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
                
                dict["poNum"] = item.ponum ?? ""
                dict["itemId"] = item.itemid ?? ""
                dict["quantity"] = item.itemreceiptQty ?? ""
                selectedItems.append(dict)
            }
            
        }
		
		if selectedItems.count == 0 {
			 Utilities.sharedInstance.showAlert("Please add items before submitting Item receipt", btnTitle: "Ok", targetVC: self)
			return
		}

        let request = ["event" : "itemreceipt",  "items" : selectedItems ] as [String : Any]
        Connection.sharedInstance.targetVC = self

        Connection.sharedInstance.delegate = self
        Connection.sharedInstance.webServiceType = .submit_ITEMRECEIPT
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
            }, option2: "PO", block2: {
                
            self.selectedItemType = ItemType.PO
            self.showAddItemPopUP(sender)

            }, targetVC: self)
        
        

        
    }
    
    func showAddItemPopUP(_ sender: AnyObject)  {
        
        Utilities.sharedInstance.addItemPopup(sender, targetVC: self, textfieldPlaceholder: "ID", barcodeAlertTitle: "Enter the code") { (  str) in
            
            print("str /(str)");
            //str = "080095301283"
           // str = "080095301287"
            //str = "080095301287"
            
            //str = "080095301268"//working
            self.selectedOrderNo = str
            
          //  str = self.selectedItemType == .Item ? "080095301268" : "PUR00001338"
            Connection.sharedInstance.targetVC = self

            Connection.sharedInstance.delegate = self;
            Connection.sharedInstance.webServiceType = .additem_ITEMRECEIPT

            Connection.sharedInstance.targetVC = self
            Connection.sharedInstance.getItemInformation(ReceiptType.itemreceipt, itemType: self.selectedItemType, upc: str!, target :self, completion: { (connectionType, json, error) in
                
                print(json as Any)
                
                if let unerror = error {
                    Utilities.sharedInstance.processErrorResponse(unerror, target: self)
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

          //  Connection.sharedInstance.getItemInformation(ReceiptType.ITEMRECEIPT, itemType: self.selectedItemType, upc: str!)
            
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
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NSShipmentsCell

        cell?.itemLabel.text = items[indexPath.row].itemName ?? ""
        cell?.salesOrderLabel.text = items[indexPath.row].ponum ?? ""
        cell?.selectBtn.indexPath = indexPath
		
		cell?.quantityTextField.textFieldtype = .quantity
		cell?.quantityTextField.indexPath = indexPath
		cell?.quantityTextField.text = items[indexPath.row].itemreceiptQty ?? ""

//NSShipmentsCell
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
