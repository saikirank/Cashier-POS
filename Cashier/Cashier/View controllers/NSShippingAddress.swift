//
//  NSShippingAddress.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit
import CoreLocation
class NSShippingAddress: NSBaseVC , CLLocationManagerDelegate{

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var namefield: UITextField!
  
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var addressField: UITextField!
//shippingaddress
    
    @IBOutlet weak var zipfield: UITextField!
    @IBOutlet weak var statefield: UITextField!
    @IBOutlet weak var cityfield: UITextField!
    
    var  lattitude : CLLocationDegrees?
    var longitide : CLLocationDegrees?
    
    var isloadingAddressInProgress : Bool = false
     var locationManager : CLLocationManager?
    
    
    @IBOutlet weak var address2field: UITextField!
    
    @IBAction func actionSubmit(_ sender: AnyObject) {
        
        
        if(namefield.text?.characters.count == 0){
            namefield.becomeFirstResponder()
        }
        else  if(countryField.text?.characters.count == 0){
            countryField.becomeFirstResponder()
        }
        else  if(phoneField.text?.characters.count == 0){
            phoneField.becomeFirstResponder()
        }

        else  if(addressField.text?.characters.count == 0){
            addressField.becomeFirstResponder()
        }
            /*
        else  if(address2field.text?.characters.count == 0){
            address2field.becomeFirstResponder()
        } */

        else  if(cityfield.text?.characters.count == 0){
            cityfield.becomeFirstResponder()
        }

        else  if(statefield.text?.characters.count == 0){
            statefield.becomeFirstResponder()
        }

        else  if(zipfield.text?.characters.count == 0){
            zipfield.becomeFirstResponder()
        }
        else {
            
            var dict  = [String :String]();
            
            dict["name"] = namefield.text
            dict["country"] = countryField.text
            dict["phone"] = phoneField.text
            dict["address1"] = addressField.text
            dict["address2"] = address2field.text
            dict["city"] = cityfield.text
            dict["state"] = statefield.text
            dict["zip"] = zipfield.text

            UserModelManager.sharedInstance.shippingAddress = dict
            
            self.performSegue(withIdentifier: "shippingToSalesOrder", sender: self)
        //self.navigationController?.popViewControllerAnimated(true)
            
            /*
 ”:{“name”:”xxx”,”country”:”USA”,"phone":"9867453214",”address1”:”add1”,”address2”:”add2”,”city”:”cty”,”state”:”sta “,”zip”: “Zip”},
 */
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
                                    self.address2field.text = address2 as? String

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
