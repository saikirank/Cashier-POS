//
//  BarcodeReaderViewController.swift
//  CDBarcodes
//
//  Created by Matthew Maher on 1/29/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarCodeProtocal {
    func barCodereceived( _ barcode: String?)
    func barCodefail( _ error: String?)
    
}

class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate : BarCodeProtocal? = nil;
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cancelButton : UIButton?
    var doneButton : UIButton?
    var highlightView : UIView?
    var label : UILabel = UILabel()
    
    func dismissBarcodeView()  {
        self.dismiss(animated: true, completion: nil)

    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton = NSButton(type: .roundedRect)
        self.cancelButton!.frame = CGRect(x: 10, y: 20, width: 60, height: 30)
        cancelButton!.setTitle("Cancel", for: UIControlState())
        cancelButton!.setTitleColor(UIColor.white, for: UIControlState())
		cancelButton?.backgroundColor = UIColor.blue
        cancelButton!.addTarget(self, action: #selector(self.dismissBarcodeView), for: .touchUpInside)
        self.view.addSubview(cancelButton!)
        self.doneButton = UIButton(type: .roundedRect)
        self.doneButton!.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 5, width: 60, height: 30)
        doneButton!.setTitle("Done", for: UIControlState())
        doneButton!.setTitleColor(UIColor.white, for: UIControlState())
        doneButton!.addTarget(self, action: #selector(self.chooseBarcodeView), for: .touchUpInside)
		
		let switchCamButton = UIButton(type: .roundedRect)
		switchCamButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 140, y: 20, width: 50, height: 50)
		//switchCamButton.setTitle("Front Camera", forState: .Normal)
		switchCamButton.setTitleColor(UIColor.white, for: UIControlState())
		switchCamButton.setImage(UIImage.init(named: "switchCamera"), for: UIControlState())
		switchCamButton.addTarget(self, action: #selector(self.switchCamera), for: .touchUpInside)
		view.addSubview(switchCamButton)
		
       // self.view.addSubview(doneButton!)
        self.highlightView = UIView()
        self.highlightView!.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        highlightView?.layer.borderWidth = 2

        self.highlightView!.layer.borderColor = UIColor.green.cgColor
        self.label = UILabel()
        self.label.frame = CGRect(x: 0, y: self.view.bounds.size.height - 40, width: self.view.bounds.size.width, height: 40)
        self.label.autoresizingMask = .flexibleTopMargin
        self.label.backgroundColor = UIColor(white: 0.15, alpha: 0.65)
        self.label.textColor = UIColor.white
        self.label.textAlignment = .center
		self.label.text = "Scanning..."
        view.addSubview(label)
        view.addSubview(highlightView!)

        
        // Create a session object.
        
        session = AVCaptureSession()
        
        // Set the captureDevice.
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
		
        // Create input object.
        
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		
        } catch {
            return
        }
        
        // Add input to the session.
        
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // Create output object.
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            
            metadataOutput.metadataObjectTypes =  metadataOutput.availableMetadataObjectTypes
            
            //[_metadataOutput availableMetadataObjectTypes]
            
        } else {
            scanningNotPossible()
        }
        
        // Add previewLayer and have it show the video data.
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // Begin the capture session.
        
        session.startRunning()
        
        view.bringSubview(toFront: highlightView!)
        view.bringSubview(toFront: label)
        view.bringSubview(toFront: cancelButton!)
        view.bringSubview(toFront: doneButton!)
        view.bringSubview(toFront: switchCamButton)

		self.label.text = "Scanning..."

    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (session?.isRunning == false ) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }
    
    func scanningNotPossible() {
        
        // Let the user know that scanning isn't possible with the current device.
        
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            
            if let delegate = self.delegate {
                let error : String? = "Can't Scan"
                delegate.barCodefail(error)
            }
            
            self.dismiss(animated: true, completion: nil)

        }))
      //  presentViewController(alert, animated: true, completion: nil)
        
        present(alert, animated: true) {

        }
        
        session = nil
    }
    

	func switchCamera(_ sender : UIButton)  {
		
		if session.inputs.count != 0 {
			session.beginConfiguration()

			//Remove existing input
			let currentCameraInput:AVCaptureInput = session.inputs.first as! AVCaptureInput
			session.removeInput(currentCameraInput)

		
		
		//Get new input
		var newCamera:AVCaptureDevice! = nil
		if let input = currentCameraInput as? AVCaptureDeviceInput {
			if (input.device.position == .back)
			{
				newCamera = cameraWithPosition(.front)
				
			}
			else
			{
				newCamera = cameraWithPosition(.back)
			}
		}
		
		//Add input to session
		var err: NSError?
		var newVideoInput: AVCaptureDeviceInput!
		do {
			newVideoInput = try AVCaptureDeviceInput(device: newCamera)
		} catch let err1 as NSError {
			err = err1
			newVideoInput = nil
		}
		
		if(newVideoInput == nil || err != nil)
		{
			print("Error creating capture device input: \(err!.localizedDescription)")
		}
		else
		{
			session.addInput(newVideoInput)
		}
		
		//Commit all the configuration changes at once
		session.commitConfiguration()
		}

	}
	
	func cameraWithPosition(_ position: AVCaptureDevicePosition) -> AVCaptureDevice?
	{
		let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
		for device in devices! {
			let device = device as! AVCaptureDevice
			if device.position == position {
				return device
			}
		}
		
		return nil
	}

	
    func chooseBarcodeView()  {
        if let delegate = self.delegate {
            let optional : String? = label.text
            delegate.barCodereceived(optional)
        }
//        self.dismissViewControllerAnimated(true, completion: nil)

        dismiss(animated: true) {
            
        }

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRect.zero
        var barCodeObject: AVMetadataMachineReadableCodeObject!
        var detectionString: String? = nil
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        for metadata in metadataObjects {
            for type: String in barCodeTypes {
                if ((metadata as AnyObject).type == type) {
                    barCodeObject = (previewLayer.transformedMetadataObject(for: (metadata as! AVMetadataMachineReadableCodeObject)) as! AVMetadataMachineReadableCodeObject)
                    highlightViewRect = barCodeObject.bounds
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    print("Barcode: \(detectionString)")
                    self.label.text = detectionString ?? ""
                    session.stopRunning()
                    
                    highlightView!.frame = highlightViewRect;
                    highlightView?.backgroundColor = UIColor.clear
                    view.bringSubview(toFront: highlightView!)

                    let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        print("test")
                        self.chooseBarcodeView()

                    }
                    

                    break;
                }
            }
            
                if (detectionString != nil)
                {
                    label.text = detectionString;
                    break;
                }
                else {
                label.text = "Scanning...";
            }
        
        /*
        // Get the first object from the metadataObjects array.
        
        if let barcodeData = metadataObjects.first {
            
            // Turn it into machine readable code
            
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
            
            if let readableCode = barcodeReadable {
                
                // Send the barcode as a string to barcodeDetected()
                
                barcodeDetected(readableCode.stringValue);
            }
            
            // Vibrate the device to give the user some feedback.
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device.
            
            session.stopRunning()
        }
        */
    }
      
        
    }

    
    func barcodeDetected(_ code: String) {
        
        // Let the user know we've found something.
        
        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.destructive, handler: { action in
            
            // Remove the spaces.
            
            let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
            
            // EAN or UPC?
            // Check for added "0" at beginning of code.
            
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String
            
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
                
                // Send the doctored UPC to DataService.searchAPI()
                if let delegate = self.delegate {
                    let optional : String? = trimmedCodeNoZero
                    delegate.barCodereceived(optional)
                }

                
                
            } else {
                
                // Send the doctored EAN to DataService.searchAPI()
                
                if let delegate = self.delegate {
                    let optional : String? = trimmedCodeString

                    delegate.barCodereceived(optional)
                }

                
                
            }
            self.dismiss(animated: true, completion: nil)
            
          //  self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
