//
//  NSRegistrationVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit
import CoreLocation

class NSRegistrationVC: NSBaseVC , CLLocationManagerDelegate , UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var officePhoneField: NSTextField!
    @IBOutlet weak var pincodeField: NSTextField!
    @IBOutlet weak var stateField: NSTextField!
    @IBOutlet weak var mobileField: NSTextField!
    @IBOutlet weak var address2Field: NSTextField!
    @IBOutlet weak var address1Field: NSTextField!
    @IBOutlet weak var countryField: NSTextField!
    @IBOutlet weak var storeNameField: NSTextField!
    @IBOutlet weak var cityField: NSTextField!

    @IBOutlet weak var firstNamefield: NSTextField!
    
    
    @IBOutlet weak var lastNameField: NSTextField!
    
    
    @IBOutlet weak var emailField: NSTextField!
    
    @IBOutlet weak var userNameField: NSTextField!
    
    @IBOutlet weak var passwordField: NSTextField!
    
    @IBOutlet weak var confirmPwdField: NSTextField!
    @IBOutlet weak var view1Xposition: NSLayoutConstraint!

    @IBOutlet weak var view2Xposition: NSLayoutConstraint!
    @IBOutlet weak var view1: UIView!
	var selectedLocation : Location?
	
    //177
    
    var  lattitude : CLLocationDegrees?
    var longitide : CLLocationDegrees?
    
    var isloadingAddressInProgress : Bool = false
    var locationManager : CLLocationManager?
	var table : UITableView = UITableView()

    @IBOutlet weak var view2: UIView!
	
	
	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return UserModelManager.sharedInstance.locations?.count ?? 10
	}

	  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell(style: .default, reuseIdentifier:"cell")
		
		//cell.textLabel?.text = "hello"
		
		cell.textLabel!.text = UserModelManager.sharedInstance.locations?[indexPath.row].name
		cell.textLabel?.textColor = UIColor.black
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("\(indexPath.row)")
		
		self.storeNameField.text = UserModelManager.sharedInstance.locations?[indexPath.row].name
		
		self.selectedLocation = UserModelManager.sharedInstance.locations?[indexPath.row]
		dismiss(animated: false, completion: nil )
	}
	

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		if textField == storeNameField {
			print("store fielf")
			return false
		}
		else {
		print("no store fielf")
		}
		return true;
	}
	func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
	{
		if textField === storeNameField  {
			
			let tableViewController = UITableViewController()
			tableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
			tableViewController.preferredContentSize = CGSize(width: 400, height: 400)
			tableViewController.tableView=table
			table.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
			table.delegate = self;
			table.dataSource = self
			
			present(tableViewController, animated: true, completion: nil)
			
			let popoverPresentationController = tableViewController.popoverPresentationController
			popoverPresentationController?.sourceView = textField
			popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: textField.frame.size.width, height: textField.frame.size.height)
			popoverPresentationController?.delegate=self
			popoverPresentationController?.permittedArrowDirections=UIPopoverArrowDirection.up
			
		}

		
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

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.passwordField.isSecureTextEntry = true
		self.confirmPwdField.isSecureTextEntry = true
		
        locationManager =  CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.distanceFilter = 100; //whenever we move
        
        locationManager!.requestAlwaysAuthorization()
        
        locationManager!.requestWhenInUseAuthorization()
        
        
        locationManager!.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager?.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        if let lat = locationManager?.location?.coordinate.latitude, let lang = locationManager?.location?.coordinate.longitude {
            self.lattitude = lat
            self.longitide = lang
            
            if countryField.text?.characters.count == 0 && isloadingAddressInProgress == false {
                isloadingAddressInProgress = true
                getAreaDetailsUsingLatLong()
            }
            
        }
		
    }
	
	
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if countryField.text?.characters.count == 0  {
            
            isloadingAddressInProgress = true
            let location = locations.last;
            locationManager!.stopUpdatingLocation()
            self.lattitude = location?.coordinate.latitude
            self.longitide = location?.coordinate.longitude
            
            //performSelector(#selector(getAreaDetailsUsingLatLong), withObject: nil, afterDelay: 0.2)
            getAreaDetailsUsingLatLong()
        }
        
    }
    
    func getAreaDetailsUsingLatLong()  {
        
        
        URLSession.shared.invalidateAndCancel()
        let url = URL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(format: "%.15f,", self.lattitude!) + String(format: "%.15f", self.longitide!) + "&sensor=true")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            do {
                if data ==  nil
                {
                    
                    return
                }
                let  dict = try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions()) as? [String: AnyObject]
                
                print(dict as Any)
                if ((dict!["status"] as! String) == "Ok") {
                    if (dict!["results"] as! NSArray).count > 0 {
                        
                        
                        var results = (dict!["results"] as! [NSDictionary])
                        let dict2 = results[results.count-1]
                        let address = (dict2["formatted_address"] as! String)
                        
                        if let address2 = results[0]["formatted_address"], let country2 : String = dict2["formatted_address"] as? String {
                            
                            DispatchQueue.main.async(execute: {
                                self.countryField.text = country2
                                self.countryField.isEnabled = false
                                self.address2Field.text = address2 as? String
                                
                            })
                            
                            
                        }
                        
                        
                        print("\(address)")
                    }
                }
                
                
            } catch {
                print(error)
                
            }
            
            
        }) 
        
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionBack(_ sender: AnyObject) {
    }
    
    @IBAction func registeraction(_ sender: AnyObject) {
        
        
        if stateField.text?.characters.count == 0 {
            stateField.becomeFirstResponder()
        }
        else  if countryField.text?.characters.count == 0 {
            countryField.becomeFirstResponder()
        }
        else  if address1Field.text?.characters.count == 0 {
            address1Field.becomeFirstResponder()
        }/*
        else  if address2Field.text?.characters.count == 0 {
            address2Field.becomeFirstResponder()
        } */
        else  if cityField.text?.characters.count == 0 {
            cityField.becomeFirstResponder()
        }
        else  if stateField.text?.characters.count == 0 {
            stateField.becomeFirstResponder()
        }

        else  if pincodeField.text?.characters.count == 0 {
            pincodeField.becomeFirstResponder()
        }

        else  if mobileField.text?.characters.count == 0 {
            mobileField.becomeFirstResponder()
        }
			/*
        else  if officePhoneField.text?.characters.count == 0 {
            officePhoneField.becomeFirstResponder()
        }*/
        else {
            
            let companyName = UserDefaults.standard.object(forKey: APPNAME) ?? ""
            //now you can submit
			let dict : NSDictionary =	["event":"register","firstname": self.firstNamefield.text!,
    "lastname": lastNameField.text!,
    "phone": mobileField.text!,
    "email": emailField.text!,
    "username": userNameField.text!,
    "password": passwordField.text!,
    "mobilephone": mobileField.text!,
    "officenumber": officePhoneField.text!,
    "addr1": address1Field.text!,
    "addr2": address2Field.text!,
    "city": cityField.text!,
    "state": stateField.text!,
    "country": countryField.text!,
    "zip": pincodeField.text!,
    "storeid": (self.selectedLocation?.id)!,"companyName":companyName ]
			
			Connection.sharedInstance.registration(dict, target: self ){ (connectionType, json, error) in
				
				DispatchQueue.main.async(execute: {
				_ =	self.navigationController?.popViewController(animated: true)

					})
				

				}
			
        }
        
    }
    @IBAction func previousAction(_ sender: AnyObject) {
        
        
        UIView.animate(withDuration: 2, delay: 2, options: .curveLinear, animations: {
            self.view2Xposition.constant = 1024;

        }) { (flag) in
            self.view1.isHidden = false;

        }
        
        
    }
	
	
    
    @IBAction func nextAction(_ sender: AnyObject) {
        
//		showV2()
//		return
        if firstNamefield.text?.characters.count == 0 {
            firstNamefield.becomeFirstResponder()
        }
        else  if lastNameField.text?.characters.count == 0 {
            lastNameField.becomeFirstResponder()
        }
        else  if emailField.text?.characters.count == 0 {
            emailField.becomeFirstResponder()
        }
        else if( Utilities.sharedInstance.isValidEmail(emailField.text!,targetVC:self) == false){
            emailField.becomeFirstResponder()

        }
        else  if userNameField.text?.characters.count == 0 {
            userNameField.becomeFirstResponder()
        }
        else  if passwordField.text?.characters.count == 0 {
            passwordField.becomeFirstResponder()
        }
        else  if confirmPwdField.text?.characters.count == 0 {
            confirmPwdField.becomeFirstResponder()
        }
        else if passwordField.text != confirmPwdField.text {
            
            Utilities.sharedInstance.showAlert("Password and Confirmation Password should be same", msg: "", btnTitle: "Ok", targetVC: self, completion: {
                
                self.passwordField.text = ""
                self.confirmPwdField.text = ""
                self.passwordField.becomeFirstResponder()


            })
            
        }
         else
            
          {
			
			self.storeNameField.delegate = self
			
            DispatchQueue.main.async(execute: {
                self.view2.isHidden = true
                self.view2Xposition.constant =  (self.view.frame.width-self.view2.frame.width)/2;
                })
            
			Connection.sharedInstance.locations( self, competion: { (connectionType, json, error) in
				
				print(json as Any)
				
				guard let loc = Locations(json: json!), json != nil else {
					print("Error initializing object")
					
					DispatchQueue.main.async(execute: {
						
						Utilities.sharedInstance.showAlert("There was a problem processing getting locations", btnTitle: "Ok", targetVC: self)
					})
					
					return
				}
				UserModelManager.sharedInstance.locations = loc.locations;

				self.showV2()
				
				
				
			})
			

			

			
        }
        
        
    }
	
	func showV2()  {
//        dispatch_async(dispatch_get_main_queue(), {
//        self.view2Xposition.constant = 1024;
//        
//        self.view2Xposition.constant = (CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view2.frame))/2;
//
//            })
//        
//        self.view2.hidden = false;
//        self.view1.hidden = true;
//
//		
//
//	}
        


    DispatchQueue.main.async(execute: {
    
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view2.isHidden = false
            self.view1.isHidden = true

        })
        
        
    })
    }
    
//        self.view2Xposition.constant = 1024;
//
//        UIView.animateWithDuration(0.1, animations: {
//        self.view2Xposition.constant =  (CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view2.frame))/2;
//
//				
//    }) { (flag) in
//				
//    
//        //self.view2Xposition.constant = (CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view2.frame))/2;
//        self.view1.hidden = true;
//
//        LoadingOverlay.shared.hideOverlayView()
//
//				
//    }
//    })
    //}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
