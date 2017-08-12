//
//  NSForgotVC.swift
//  Cashier
//
//  Created by sample K on 03/09/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSForgotVC: NSBaseVC, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func reset(_ sender: AnyObject) {
        
        
        if emailField.text?.characters.count == 0 {
            emailField.becomeFirstResponder()
        }
		else if( Utilities.sharedInstance.isValidEmail(emailField.text!,targetVC:self) == false){
			emailField.becomeFirstResponder()
		}

        else if( Utilities.sharedInstance.isValidEmail(emailField.text!,targetVC:self) == true) {
            
            //perform reet action
			
			Connection.sharedInstance.forgotPassword(emailField.text!, target: self){ (connectionType, json, error) in
				
				print("forgot" + "/(json)" + "/(error)");
			
				
				DispatchQueue.main.async(execute: {
                   _ = self.navigationController?.popToRootViewController(animated: true)
					
				})

			}
			
        }
        
    }
    @IBAction func showLogin(_ sender: AnyObject) {
        
       _ = navigationController?.popViewController(animated: true)
        
        
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
