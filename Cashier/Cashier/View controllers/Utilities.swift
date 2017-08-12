//
//  Utilities.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum ReceiptType {
    case itemreceipt
    case shipment
    case returns
}

enum ItemType : String {
    case Item
    case PO
    case SO
}


class Utilities : BarCodeProtocal {
    
//    private static var __once: () = {
//            Static.instance = Utilities()
//        }()
    
    var barCodeCompletionHandler : (( String?) -> Void)? = nil
    
    func barCodefail( _ error: String?) {
    
        barCodeCompletionHandler!(error)

    }
    func barCodereceived( _ barcode: String?) {
        if let handler = barCodeCompletionHandler {
        handler(barcode)
        }
    }
    static let sharedInstance: Utilities = Utilities()

    
//    class var sharedInstance: Utilities {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: Utilities? = nil
//        }
//        _ = Utilities.__once
//        return Static.instance!
//    }
    
    func didAppSettingsExist(_ targetVC: UIViewController) -> Bool {
        if((UserDefaults.standard.object(forKey: APPURL) ) == nil && Platform.isSimulator == false) {
            Utilities.sharedInstance.showAlert("Please configure settings", btnTitle: "Ok", targetVC: targetVC)
            return false
            }

        return true
    }
    
    func showAlert(_ title:String, btnTitle :  String, targetVC: UIViewController)  {
        
        let controller = UIAlertController(title:nil , message: title, preferredStyle: .alert)
        
        let action = UIAlertAction(title: btnTitle, style: .default, handler: nil)
        
        controller.addAction(action)
        DispatchQueue.main.async(execute: {
            targetVC.present(controller, animated: true, completion: nil)

        })

        
    }
    
    func showAlert(_ title:String, msg : String, btnTitle :  String, targetVC: UIViewController, completion:@escaping ()->())  {
        
        let controller = UIAlertController(title:title , message: msg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: btnTitle, style:.default ){
            (UIAlertAction) in
            completion()
        }
        
        
        controller.addAction(action)
        DispatchQueue.main.async(execute: {
            targetVC.present(controller, animated: true, completion: nil)
            
        })
        
        
    }
    
    


    
    
    
    
    func processErrorResponse(_ repsonse: Any?, target:UIViewController)  {
        
        if let res = repsonse as? String {
            
            let array = res.components(separatedBy: ":")
          //  print(array[1])
            
            let filteredStrings = array.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercased().range(of: "Error".lowercased())
                return stringMatch != nil ? true : false
            })
            
            
            if filteredStrings.count > 0 {
                
                var str = array.last
                str = str?.replacingOccurrences(of: "\\", with: "")
                str = str?.replacingOccurrences(of: "\"", with: "")
                str = str?.replacingOccurrences(of: "}", with: "")
                
                
                Utilities.sharedInstance.showAlert(str!, btnTitle: "Ok", targetVC: target)
            }
            else {
                Utilities.sharedInstance.showAlert("There was a problem processing your request.", btnTitle: "Ok", targetVC: target)
                
            }
            
        }

    }
    
    
   
    func showAlert(_ sender: AnyObject, title : String, option1 : String, block1 : @escaping (()-> Void), option2 : String, block2 : @escaping (()-> Void), targetVC : UIViewController )  {
        
        
      let alertController = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        
        let oneaction = UIAlertAction(title: option1, style: .default) { (_) in
            block1()
        }
        let twoaction = UIAlertAction(title: option2, style: .default) { (_) in
            block2()
        }
        
        alertController.addAction(oneaction)
        alertController.addAction(twoaction)
        alertController.popoverPresentationController?.sourceView = sender.superview
        alertController.popoverPresentationController?.sourceRect = sender.frame

        targetVC.present(alertController, animated: true, completion: nil)
        
    }
    func getAppSettingsbyScanningBarcode( _ targetVC: UIViewController,barcodeAlertTitle : String, completionHandler: (( String?) -> Void)?) {
        barCodeCompletionHandler = completionHandler

        let bvc = targetVC.storyboard?.instantiateViewController(withIdentifier: "barcodeReader") as? BarcodeReaderViewController
        bvc?.delegate = self
        targetVC.present(bvc!, animated: true
            , completion: nil)
        
    }
    
    /*
     let bvc = targetVC.storyboard?.instantiateViewControllerWithIdentifier("barcodeReader") as? BarcodeReaderViewController
     bvc?.delegate = self
     targetVC.presentViewController(bvc!, animated: true
     , completion: nil)

 */
    
    func addItemPopup(_ sender: AnyObject, targetVC: UIViewController,textfieldPlaceholder : String,barcodeAlertTitle : String, completionHandler: (( String?) -> Void)?) {
		IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false

		
	
		
        barCodeCompletionHandler = completionHandler
        
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let oneAction = UIAlertAction(title: "Scan", style: .default) { (_) in
        
            
           let bvc = targetVC.storyboard?.instantiateViewController(withIdentifier: "barcodeReader") as? BarcodeReaderViewController
            bvc?.delegate = self
            targetVC.present(bvc!, animated: true
                , completion: nil)
            
			IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true

        }
        let twoAction = UIAlertAction(title: "Add Manually", style: .default) { (_) in
			
			IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false

			
            let upcAlrt = UIAlertController(title: "Enter the code", message: "", preferredStyle: .alert)
            let loginAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                print("login")
                if let textField = upcAlrt.textFields?[0], upcAlrt.textFields?.count > 0{
					textField.clearButtonMode = .whileEditing
                    print(textField)
                    completionHandler!(textField.text)
                }
				IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true

            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
                (action : UIAlertAction!) -> Void in
				IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true

				
            })


            
            upcAlrt.addTextField { (textField) in
                textField.placeholder = "UPC"
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    loginAction.isEnabled = textField.text != ""
                }
                
                
            }
            upcAlrt.addAction(cancelAction)
            upcAlrt.addAction(loginAction)
            loginAction.isEnabled = false
            targetVC.present(upcAlrt, animated: true, completion: {
                
            })
            
        }
        
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        
        
        alertController.popoverPresentationController?.sourceView = sender.superview
        alertController.popoverPresentationController?.sourceRect = sender.frame
            //(sender.superview?!.frame)!
        targetVC.present(alertController, animated: true, completion: nil)
        
        
    }
    
     func isValidEmail(_ testStr:String, targetVC : UIViewController) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let flag = emailTest.evaluate(with: testStr)
        if flag == false {
            Utilities.sharedInstance.showAlert("Please enter valid email id", btnTitle: "Ok", targetVC: targetVC)
        }
		return flag

    }

    //--------------------->
    func isAppSettingsAvailble() -> Bool {
        
        return UserDefaults.standard.object(forKey: APPNAME) != nil || Platform.isSimulator
    }
    
    func decodeAppSettingsFromQRCode(_ str : String) -> Bool {
        
        let decodeddata =  Data(base64Encoded: str, options: NSData.Base64DecodingOptions(rawValue: 0))
        if decodeddata == nil
        {
            return false
        }
        let decodedstr = NSString(data: decodeddata!, encoding: String.Encoding.utf8.rawValue)
        print(decodedstr as Any)
        
        if decodedstr == nil {
            return false
        }
        
        let searchTerms =  decodedstr?.replacingOccurrences(of: "@@", with: "\n", options: .regularExpression, range:NSMakeRange(0, (decodedstr?.length)!-1) )
        var arr = searchTerms?.components(separatedBy: CharacterSet(charactersIn: "\n"))
        
        if arr?.count <  3{
            
            return false
        }
        UserDefaults.standard.set(arr![0], forKey: APPNAME)
        UserDefaults.standard.set(arr![1] , forKey: APPURL)
        UserDefaults.standard.set(arr![2] , forKey: APPAUTH)
		
		Connection.baseURL = arr![1]
        //NSUserDefaults.standardUserDefaults().setObject(arr![3], forKey: APPSAMPLE)
        UserDefaults.standard.synchronize()
        //request.setValue("NLAuth nlauth_account=TSTDRV1381328, nlauth_email=vamsi@netscoretech.com, nlauth_signature=NetSuite@123, nlauth_role=3", forHTTPHeaderField: "Authorization")

        return true
        
    }
    

    

    
}
