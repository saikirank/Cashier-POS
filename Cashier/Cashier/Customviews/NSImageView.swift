//
//  NSImageView.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    func downloadedFrom(_ link: AnyObject, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        var url : URL
        if link is URL {
            
            url  = link as! URL
        }
        else if link is String {
            
            if let unwrappedURL = URL (string: link as! String){
                url = unwrappedURL
            }
            else {
                return
            }

        }
        else {
            return
        }
        
        contentMode = mode
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async(execute: {
                
                self.image = image

            })
            
            }) .resume()
        }

        
}
