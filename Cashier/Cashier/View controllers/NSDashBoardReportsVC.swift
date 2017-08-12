//
//  NSDaashBoardReportsVC.swift
//  Cashier
//
//  Created by sample on 22/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSDashBoardReportsVC: NSBaseVC , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ConenctionDelegate, UIPopoverPresentationControllerDelegate {
	@IBOutlet weak var headerLb2: UILabel!
	@IBOutlet weak var headerLb3: UILabel!
	
	
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var headerLb1: UILabel!
	
	@IBOutlet weak var startDateField: UITextField!

	@IBOutlet weak var endDateField: UITextField!

	@IBOutlet weak var receiptTypeLabel: UILabel!

	@IBOutlet weak var activeTextField: UITextField!

	var transactions = [Transaction]()

	var receiptTypes = [["title":"Sales Order", "key":"SalesOrd"],["title":"Item Shipments", "key":"ItemShip"]]
	
	var selectedOrderNo : String?
	var selectedItemType : ItemType = ItemType.Item
	
	var items  =  [Item]()
	var popOverTable : UITableView = UITableView()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.tableView.layer.borderWidth = 1.0
		self.tableView.separatorStyle = .none;
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
		startDateField.delegate = self
		
		endDateField.delegate = self
		endDateField.addTarget(self, action: #selector(self.editingDidBegin), for: .editingDidBegin)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		//dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let str = dateFormatter.string(from: Date())
		
		self.startDateField.text = str
		self.endDateField.text = str
        self.receiptTypeLabel.text = self.receiptTypes[0]["title"]

		self.searchReports(self.startDateField)
		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = bgColor
		self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		
		self.tableView.tableFooterView = UIView(frame: .zero)
	}
	
	@IBAction func searchReports(_ sender: AnyObject) {
		var key = ""
		for character in self.receiptTypes {
			if  self.receiptTypeLabel.text == character["title"] {
				key = character["key"]!
				break
			}
		}
		transactions = [Transaction]()
		tableView.reloadData()
		Connection.sharedInstance.dashBoardReport(startDateField.text!, endDate: endDateField.text!, receiptType: key, target: self,connectionType:.nobacknavigation) { (connectionType, json, error) in
			
			guard let model = DashBoardReportModel(json: json!), json != nil else {
				print("Error initializing object")
				
				return
			}

			if let transactions = model.transactions {
				self.transactions = transactions

			}
			//self.transactions = model.transactions!
			
			
			DispatchQueue.main.async(execute: {
				self.tableView.reloadData()

				})

		}
	}
	
	@IBAction func selectReceiptType(_ sender: UIButton) {
		
		let tableViewController = UITableViewController()
		tableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
		tableViewController.preferredContentSize = CGSize(width: 200, height: 200)
		tableViewController.tableView=self.popOverTable
		self.popOverTable.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
		self.popOverTable.delegate = self;
		self.popOverTable.dataSource = self
		self.popOverTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		present(tableViewController, animated: true, completion: nil)
		
		let popoverPresentationController = tableViewController.popoverPresentationController
		popoverPresentationController?.sourceView = sender.superview
		popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: sender.frame.size.width, height: sender.frame.size.height)
		popoverPresentationController?.delegate=self
		popoverPresentationController?.permittedArrowDirections=UIPopoverArrowDirection.up

		
	}
	
	func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController)
	{
	}
	
	func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
	{
	}
	
	func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
	{
		return true
	}
	



	
	
	@IBAction func receiptTypeDidSelect(_ sender: NSButton) {
		
		
		
		
	}

	@IBAction func editingDidBegin(_ sender: UITextField) {
		
		let datePickerView:UIDatePicker = UIDatePicker()
		
		datePickerView.datePickerMode = UIDatePickerMode.date
		
		sender.inputView = datePickerView
		
		let toolBar = UIToolbar()
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
		toolBar.sizeToFit()
		
		// Adds the buttons
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.datePickerValueChanged))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
		toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		
		sender.inputAccessoryView = toolBar

	}
	
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
	
	
	@IBAction func textFieldEditing(_ sender: UITextField) {
		// 6

		
		
	}
	
	func cancel() {
		self.activeTextField.resignFirstResponder()
	
	}
	func datePickerValueChanged(_ sender:UIBarButtonItem) {
		
		if let datePicker = self.activeTextField.inputView as? UIDatePicker {
		
		let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MM/dd/yyyy"
		//dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		
		//dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
		
		self.activeTextField.text = dateFormatter.string(from: datePicker.date)
		self.activeTextField.resignFirstResponder()
		}
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
	{

		self.activeTextField = textField
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		return true
	}
	

	
	
	
	
	
	
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView === self.popOverTable {
			
			return receiptTypes.count
		}
		return transactions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if tableView === self.popOverTable {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
			cell?.textLabel?.text = receiptTypes[indexPath.row]["title"] ?? ""
			return cell!
		}
		else {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NSDashBoardReportCell
		
		cell?.transcationLabel.text = transactions[indexPath.row].tranNum
		cell?.custNameLabel.text = transactions[indexPath.row].custName
				cell?.amountLabel.text = transactions[indexPath.row].amount
		cell?.dateLabel.text = transactions[indexPath.row].date
		cell?.statusLabel.text = transactions[indexPath.row].status
			return cell!
		}
		//return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if tableView === self.popOverTable {
			self.receiptTypeLabel.text = self.receiptTypes[indexPath.row]["title"] ?? ""
			dismiss(animated: false, completion: nil )

		}
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
