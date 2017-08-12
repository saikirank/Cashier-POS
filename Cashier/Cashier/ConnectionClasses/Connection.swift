//
//  Connection.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

protocol ConenctionDelegate {
    
    func connectioDidFail(_ repsonse:Any?,connectiontype: ConnectionType);
    func connectioDidReceiveResponse(_ json: [String: AnyObject], connectiontype: ConnectionType);
    
}

enum ConnectionType {
    case none
    case additem_SALESORDER
    case additem_PURCHASEORDER

    case additem_ITEMRECEIPT
    case additem_ITEMRETURN
    case submit_ITEMRETURN

    case submit_ITEMRECEIPT
    case additem_ITEMLOOKUP
    case salesorder_SUBMIT
	case registration
	case forgotpassword
	case nobacknavigation
    
}

class Connection {
	
//    private static var __once: () = {
//			Static.instance = Connection()
//		}()
	

    //var json: JSON = JSON.null
    
    var delegate : ConenctionDelegate? = nil
    var webServiceType : ConnectionType = .none
    var targetVC : UIViewController?

    
    typealias CompletionBlock = (_ connectionType: ConnectionType, _ json:[String: AnyObject]?,_ error : String? ) -> Void

    var completionHandler : CompletionBlock?
    
     static var itemLookUpURl = "https://rest.na1.netsuite.com/app/site/hosting/restlet.nl?script=customscript_ns_ipad_app_restlet&deploy=customdeploy_ns_ipad_app_restlet"
    
    static var baseURL = "https://rest.na1.netsuite.com/app/site/hosting/restlet.nl?script=customscript_ns_ipad_app_restlet&deploy=customdeploy_ns_ipad_app_restlet"
    var loadingView : UIAlertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    func showLoading() {
        //loadingView = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        if let tVc = targetVC {
            DispatchQueue.main.async(execute: {
				self.targetVC?.navigationController?.navigationBar.isUserInteractionEnabled = false
                LoadingOverlay.shared.showOverlay(tVc.view)
            })

       }
    }
    
    func dismissLoading( _ completion :() -> ())  {
         DispatchQueue.main.async(execute: {
            LoadingOverlay.shared.hideOverlayView()
			self.targetVC?.navigationController?.navigationBar.isUserInteractionEnabled = true

         })
        completion()
    }
    
    static let sharedInstance: Connection = Connection()
/*
	class var sharedInstance: Connection {
		struct Static {
			static var onceToken: Int = 0
			static var instance: Connection? = nil
		}
		_ = Connection.__once
		return Static.instance!
	}*/
    
    func addItemtoSalesOrder(_ upc : String ,target: UIViewController, connectionType : ConnectionType,
                             completion: @escaping CompletionBlock)  {
        
        targetVC = target
        showLoading()
        let type  = (connectionType == .additem_PURCHASEORDER) ? "purchaseorder" : "salesorder"

        let urlstr = Connection.baseURL + "&upc=" + upc + "&event="+type

		
        let request = getURLRequest()
        let url = URL(string: urlstr)
        request.url = url
        self.webServiceType = .additem_SALESORDER
        startDataTaskWith(request,competion: completion)

    }
	
	
	func forgotPassword(_ email : String ,target: UIViewController,
	                         completion: @escaping CompletionBlock)  {
		
		targetVC = target
		showLoading()
		
		let urlstr = Connection.baseURL + "&username=" + email + "&password=test@123&event=login&forgot=yes"
		
		//https://rest.na1.netsuite.com/app/site/hosting/restlet.nl?script=customscript_ns_ipad_app_restlet&deploy=customdeploy_ns_ipad_app_restlet&username=oxtest@gmail.com&password=test@123&event=login&forgot=yes
		let request = getURLRequest()
		let url = URL(string: urlstr)
		request.url = url
		self.webServiceType = .forgotpassword
		startDataTaskWith(request,competion: completion)
		
	}
	
	func registration(_ input : NSDictionary,target: UIViewController, completion : @escaping CompletionBlock)  {
		targetVC = target
		showLoading()
		print(input)
		// let minput =  input.stringByReplacingOccurrencesOfString("\n", withString: "")
		let urlstr = Connection.baseURL
		
		let request = getRequestForPostMethod(input)
		let url = URL(string: urlstr)
		request.url = url
		self.webServiceType = .registration
		self.completionHandler = completion
		startDataTaskWith(request,competion: completion)
		
	}
	
	
    func submitSalesOrder(_ input : NSDictionary,target: UIViewController, completion : @escaping CompletionBlock)  {
        targetVC = target
		showLoading()
        print(input)
        // let minput =  input.stringByReplacingOccurrencesOfString("\n", withString: "")
        let urlstr = Connection.baseURL
        
        let request = getRequestForPostMethod(input)
        let url = URL(string: urlstr)
        request.url = url
        self.webServiceType = .salesorder_SUBMIT
        self.completionHandler = completion
        startDataTaskWith(request,competion: completion)
        
    }

    
	
    func submitItemReceiptDetails(_ input : NSDictionary, target : UIViewController, completion : @escaping CompletionBlock)  {
     print( input)

        targetVC = target
        showLoading()
        let urlstr = Connection.baseURL
       let request = getRequestForPostMethod(input)
        let url = URL(string: urlstr)
        request.url = url
        self.webServiceType = .additem_ITEMRECEIPT
        self.completionHandler = completion
        startDataTaskWith(request,competion: completion)

    }
    
    func getRequestForPostMethod(_ input : NSDictionary) -> NSMutableURLRequest {
        
        let request = getURLRequest()
        request.httpMethod = "POST"
        var jsonData : Data?;
        do {
            try  jsonData = JSONSerialization.data(withJSONObject: input, options: .prettyPrinted)
        }
        catch {
            
        }
        
        let str =  NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
        print(str ?? "")
        
        let strdata = str!.data(using: String.Encoding.utf8.rawValue)
        request.httpBody = strdata
        let length = "\(strdata?.count)"
        request.setValue(length, forHTTPHeaderField: "Content-Length")
        return request
    }
    
    func getItemInformation ( _ receiptType : ReceiptType, itemType : ItemType, upc:String, target : UIViewController,
                              completion: @escaping CompletionBlock){
       // print("\(Connection.itemLookUpURl)&upc=\(upc)&event=\"itemlookup\"")
        targetVC = target
        showLoading()
        var receipt = ""
        
        if receiptType == .itemreceipt {
            receipt = "itemreceipt"
        }
        else if receiptType == .shipment {
            receipt = "shipment"
        }
        else if receiptType == .returns {
             receipt = "return"
        }
        else {
            
        }
        
        var item = ""
        if itemType == .Item {
            item = "item"
        }
        else if itemType == .PO {
            item = "po"
        }
        else if itemType == .SO {
            item = "so"
        }
        else {
            
        }

        
        let urlstr = Connection.baseURL +  "&event=" + receipt + "&type=" + item + "&id=" + upc

        print(urlstr);
        let request = getURLRequest()
        let url = URL(string: urlstr)
        request.url = url
        self.webServiceType = .additem_ITEMLOOKUP
        self.completionHandler = completion
        startDataTaskWith(request,competion:completion )
        
    }
    
    func dfdf(_ str : String, block: (_ connectionType: ConnectionType, _ json:[String: AnyObject]? ) -> Void, error : String)  {
        

    }
	
	func locations (_ target: UIViewController, competion : @escaping CompletionBlock){
		targetVC = target
		showLoading()
		let urlstr = Connection.baseURL + "&event=location"
		
		let request = getURLRequest()
		let url = URL(string: urlstr)
		request.url = url
		self.completionHandler = competion
		startDataTaskWith(request,competion : competion)
		
	}

	
    func itemlookUp (_ upc:String, target: UIViewController, competion : @escaping CompletionBlock){
        targetVC = target
        showLoading()
        let urlstr = Connection.baseURL + "&upc=" + upc + "&event="+"itemlookup"
      print("\(Connection.itemLookUpURl)&upc=\(upc)&event=\"itemlookup\"")
        
        let request = getURLRequest()
        let url = URL(string: urlstr)
        request.url = url
        self.completionHandler = competion
        startDataTaskWith(request,competion : competion)
        
    }
	
	func dashBoardReport(_ startDate:String , endDate : String, receiptType : String, target: UIViewController ,connectionType: ConnectionType, competion : @escaping CompletionBlock) {
		
		self.webServiceType  = connectionType
		targetVC = target
		showLoading()
        
        let empID =  UserModelManager.sharedInstance.profiledata?.empId ?? ""

        
		let urlstr = Connection.baseURL + "&event=dashboard&startDate=" + startDate+"&endDate=" +   endDate   + "&recType=" + receiptType + (empID.characters.count > 0 ? "&empid=\(empID)" : "")
		//urlstr = urlstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
		let request = getURLRequest()
		let url = URL(string: urlstr)
		request.url = url
		self.completionHandler = competion
		startDataTaskWith(request,competion : competion)

		
	}
	
	func login (_ userName:String, password:String, target: UIViewController, competion : @escaping CompletionBlock){
		targetVC = target
		showLoading()
		let urlstr = Connection.baseURL + "&username="+userName+"&password="+password+"&event=login"
		
		let request = getURLRequest()
		let url = URL(string: urlstr)
		request.url = url
		self.completionHandler = competion
		startDataTaskWith(request,competion : competion)
		
	}

    
    
    func startDataTaskWith(_ request : NSMutableURLRequest,competion :  @escaping CompletionBlock)  {
        
       // showLoading();
        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//        }
       
        
      URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            
            // self.dismissLoading()
            print("data \n")
        self.dismissLoading {}
            if let data = data, String(data: data, encoding: String.Encoding.utf8) != nil {
                print(String(data: data, encoding: String.Encoding.utf8) as Any)

                var json: [String: AnyObject]!
                
                // 1
                do {
                    
                    json = try JSONSerialization.jsonObject(with: data, options:  JSONSerialization.ReadingOptions()) as? [String: AnyObject]
                } catch {
                    print(error)
                    if let vc = self.targetVC {
                    Utilities.sharedInstance.showAlert("Unable to process your request", btnTitle: "Ok", targetVC: vc)
                    }
                    
                    return;
                }
                
                if json != nil {
                    self.delegate?.connectioDidReceiveResponse(json, connectiontype: self.webServiceType)
					
										
                    
                    if let status = json["status"] as? String, status  != "Success" && status != "success", let message = json["message"]  as? String {
                        
                        if let targetVC = self.targetVC {
                            
                            Utilities.sharedInstance.showAlert(status, msg: message, btnTitle: "Ok", targetVC:targetVC ){
                                
                            }
                        return;
                            
                        }
                        else {
                            print("error response")
                        }
                    }
					else  if let status = json["status"] as? String, status  != "Success" && status != "success" {
						if let targetVC = self.targetVC {
							
							Utilities.sharedInstance.showAlert(status, msg: "", btnTitle: "Ok", targetVC:targetVC ){
								
							}
							return;
							
						}
						else {
							print("error response")
						}

					}
						
                   else  if let unjso = json, let status = unjso["status"] as? String, status  == "Success", let message = unjso["message"]  as? String {
						
						
                        Utilities.sharedInstance.showAlert(status, msg: message, btnTitle: "Ok", targetVC:self.targetVC! ){
						
							competion(self.webServiceType, json,nil)
							
							
							if self.webServiceType != .nobacknavigation {
							
                            self.targetVC?.dismiss(animated: true, completion: nil)
							
							_ = self.targetVC?.navigationController?.popViewController(animated: true)
								
							}

						}
						

                        print("error response")
						
						return
                        
                    }
                    competion(self.webServiceType, json,nil)

                    
                    

                }
                else {
                    let string =  String(data: data, encoding: String.Encoding.utf8)
                    self.delegate?.connectioDidFail(string,connectiontype: self.webServiceType)
                    competion(self.webServiceType, nil,string)
                }
                
                
            }
            else {
                if let vc = self.targetVC {
                Utilities.sharedInstance.showAlert("Network Error", btnTitle: "Ok", targetVC: vc)
                }
              //  self.delegate?.connectioDidFail(nil,connectiontype: self.webServiceType)
                //competion(connectionType: self.webServiceType, json:nil,error: nil)
            }
            
				self.webServiceType = .none;
				self.completionHandler = nil

				
         }.resume()
       // task.resume()

    }
    
    
    func getURLRequest()-> NSMutableURLRequest {
        let request = NSMutableURLRequest()

        if (Platform.isSimulator) {
             request.setValue("NLAuth nlauth_account=TSTDRV1381328, nlauth_email=vamsi@netscoretech.com, nlauth_signature=NetSuite@123, nlauth_role=3", forHTTPHeaderField: "Authorization")

        }
        else if ((UserDefaults.standard.object(forKey: APPURL)  ) != nil)
        {
        
            Connection.baseURL =  UserDefaults.standard.object(forKey: APPURL)  as! String;
            
        }
        else {
            
          let delegate =  UIApplication.shared.delegate as! AppDelegate
            
            let target = self.targetVC ?? delegate.window?.rootViewController
            
            if let target = target {
            
                
            Utilities.sharedInstance.showAlert("Please configure settings", btnTitle: "Ok", targetVC: target)
                
            }
            
            return request
        }
        
               // request.setValue("NLAuth nlauth_account=TSTDRV1381328, nlauth_email=vamsi@netscoretech.com, nlauth_signature=NetSuite@123, nlauth_role=3", forHTTPHeaderField: "Authorization")
        
        let str =
        (UserDefaults.standard.object(forKey: APPAUTH)  ) ?? ""
        
        print(str)
        
        let authsettingsArr = (str as AnyObject).components(separatedBy: ":")

        if authsettingsArr.count >= 3 {
            var str = authsettingsArr[1] as NSString
            str = str.replacingOccurrences(of: ",Host", with: "") as NSString
            request.setValue(str as String, forHTTPHeaderField: authsettingsArr[0])

         }
        
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request

    }
    
	func fetchData()  {
		
        return;
		var urlstr = "https://rest.na1.netsuite.com/app/site/hosting/restlet.nl?script=customscript_ns_ipad_app_restlet&deploy=customdeploy_ns_ipad_app_restlet&upc=080095301403"
        
		urlstr = 		urlstr.addingPercentEscapes(using: String.Encoding.utf8)!

		
		let url = URL(string: urlstr)

        let request = getURLRequest()

        request.url = url
        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
//        }
        
		let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
			//print(String(data: data!, encoding: String.Encoding.utf8))
		}
		task.resume()


	}

}
