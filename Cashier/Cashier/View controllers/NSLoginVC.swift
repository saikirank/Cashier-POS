//
//  NSMainVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

@IBDesignable
class NSLoginVC: UIViewController, UIActionSheetDelegate {
	@IBOutlet var emailField: UITextField!
	@IBOutlet var passwordField: UITextField!
    @IBAction func actionSettings(_ sender: AnyObject) {
        
        Utilities.sharedInstance.getAppSettingsbyScanningBarcode(  self, barcodeAlertTitle: "") { (str) in
            
            if ((str?.characters.count) != 0 && Utilities.sharedInstance.decodeAppSettingsFromQRCode(str!)
                ) {
                print("bar code success")
                
            }
            else {
                print("bar code fail")
                
                Utilities.sharedInstance.showAlert("There was a problem processing your bar code.", btnTitle: "Ok", targetVC: self)
            }
            
        }
        
    }
    
    @IBAction func actionLogin(_ sender: AnyObject) {
        
    if((Utilities.sharedInstance.didAppSettingsExist(self) ) ) {
		
		
		if Platform.isSimulator
		{
			//let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NSDashBoardVC")
			//self.navigationController?.pushViewController(vc!, animated: true)

			self.emailField.text = "sai2@sai.com"
			self.passwordField.text = "123456"
			//a@a.com password:a
		}
//
//		else 
		if emailField.text?.characters.count == 0 {
			emailField.becomeFirstResponder()
		}
		else if( Utilities.sharedInstance.isValidEmail(emailField.text!,targetVC:self) == false){
			emailField.becomeFirstResponder()
			//Utilities.sharedInstance.showAlert("Please enter valid email", btnTitle: "Ok", targetVC: self)
		}
		else if passwordField.text?.characters.count == 0 {
			passwordField.becomeFirstResponder()
		}
		
		else  {
		
		Connection.sharedInstance.login(self.emailField.text!, password: self.passwordField.text!, target: self) { (connectionType, json, error) in
			
			guard let user = ProfileModel(json: json!), json != nil else {
				print("Error initializing object")
				
				DispatchQueue.main.async(execute: {
					
				Utilities.sharedInstance.showAlert("There was a problem processing your request", btnTitle: "Ok", targetVC: self)
				})

				
				return
			}
			
			UserModelManager.sharedInstance.profiledata = user;

			DispatchQueue.main.async(execute: {
			
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "NSDashBoardVC")
				self.navigationController?.pushViewController(vc!, animated: true)
				
				self.passwordField.text = ""
		   })
		}
		
		}
        }
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.title = NETSCORETITLE

	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.title = ""
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = NETSCORETITLE
		self.view.backgroundColor = bgColor

        // Do any additional setup after loading the view.
        
        
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        
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
