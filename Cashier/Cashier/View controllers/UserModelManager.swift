//
//  UserModel.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import Foundation


class UserModelManager {
    
//    private static var __once: () = {
//            Static.instance = UserModelManager()
//        }()
    /*
    class var sharedInstance: UserModelManager {
        struct Static {
            static var onceToken: Int = 0
            static var instance: UserModelManager? = nil
        }
        _ = UserModelManager.__once
        return Static.instance!
    }*/
    static let sharedInstance: UserModelManager = UserModelManager()

	
    func getAddressDescrition() -> String {
          let dict = UserModelManager.sharedInstance.shippingAddress
        var desc = ""
        if let name = dict["name"], let country = dict["country"], let phone = dict["phone"], let address1 = dict["address1"],
        let address2 = dict["address2"],
        let city = dict["city"], let state = dict["state"] ,
        let zip = dict["zip"], dict.count > 0 {


            desc = name + "\n" + country + "\n" + phone + "\n" + address1 + "\n" + address2 + "\n" + city + "\n" + state + "\n" + zip + "\n"
        }

        return desc
    }
    
    
    var shippingAddress  = [String :String]();
	var profiledata : ProfileModel?
	var locations : [Location]?
	
}
