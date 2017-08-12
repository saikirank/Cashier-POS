//
//  NLLocationManager.swift
//  Cashier
//
//  Created by sample K on 03/09/16.
//  Copyright © 2016 sample. All rights reserved.
//

import Foundation
import CoreLocation

class NLLocationManager  : NSObject,   CLLocationManagerDelegate  {

//private static var __once: () = {
//        Static.instance = NLLocationManager()
//    }()
    static let sharedInstance: NLLocationManager = NLLocationManager()
/*
class var sharedInstance: NLLocationManager {
    struct Static {
        static var onceToken: Int = 0
        static var instance: NLLocationManager? = nil
    }
    
    _ = NLLocationManager.__once
    return Static.instance!
}*/
    override init () {
        
    }
    
    lazy var locationManager = { return CLLocationManager()
    }()
    
    var handler : (()->())? = nil

    
    var  lattitude : CLLocationDegrees?
    var longitide : CLLocationDegrees?
    
    var isloadingAddressInProgress : Bool = false
    
    func updateLocation(_ completion:@escaping ()->())  {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100; //whenever we move
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        self.handler = completion
        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        if let lat = locationManager.location?.coordinate.latitude, let lang = locationManager.location?.coordinate.longitude {
            self.lattitude = lat
            self.longitide = lang
            
            if isloadingAddressInProgress == false {
                isloadingAddressInProgress = true
                getAreaDetailsUsingLatLong()
            }
            
        }

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
            
            isloadingAddressInProgress = true
            let location = locations.last;
            locationManager.stopUpdatingLocation()
            self.lattitude = location?.coordinate.latitude
            self.longitide = location?.coordinate.longitude
            
            //performSelector(#selector(getAreaDetailsUsingLatLong), withObject: nil, afterDelay: 0.2)
            getAreaDetailsUsingLatLong()
        
        
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
                        
                        
                        
                        if let habd = self.handler {
                            habd()
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


    
    
}
