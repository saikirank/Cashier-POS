//
//  NSBaseVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSBaseVC: UIViewController {

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.backgroundColor = bgColor
        
    self.title = UserDefaults.standard.object(forKey: APPNAME) as? String ?? ""
        
        if self .isKind(of: NSLoginVC.self) || self .isKind(of: NSRegistrationVC.self) || self .isKind(of: NSForgotVC.self){
            
            
        }
        else {
            
            let button: UIButton = UIButton(type: UIButtonType.custom)
            //set image for button
            button.setImage(UIImage(named: "quit"), for: UIControlState())
            //add function for button
            button.addTarget(self, action: #selector(NSBaseVC.logout), for: UIControlEvents.touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 43, height: 43)
            
        
        //let barbutton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(logout))
            
            //quit
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func logout() {
       _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = UserDefaults.standard.object(forKey: APPNAME) as? String ?? ""

    }
	
	override func viewWillDisappear(_ animated: Bool) {
		self.title = "Back"
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
