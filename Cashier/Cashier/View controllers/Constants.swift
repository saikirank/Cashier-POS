//
//  Constants.swift
//  Cashier
//
//  Created by sample K on 11/09/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit
let  BORDER_COLOR = UIColor(colorLiteralRed: 107/255.0, green: 117/255.0, blue: 128/255.0, alpha: 1.0)

let APPNAME = "appname"
let APPURL = "appurl"
let APPAUTH = "Authorization"
let APPSAMPLE = "sample"
let bgColor = UIColor.init(red: 94/255.0, green: 120/255.0, blue: 154/255.0, alpha: 1.0)
let NETSCORETITLE = "NetScore Mobile"

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
       // return TARGET_IPHONE_SIMULATOR != 0 // Use this line in Xcode 6
    }
    
}
