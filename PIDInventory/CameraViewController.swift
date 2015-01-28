//
//  CameraViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/23/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var preview: AVCaptureVideoPreviewLayer!
    var sessionMain: AVCaptureSession!
    var capturedCode = ""
    var sourceViewIsList = false
    
    lazy var outline: CAShapeLayer = {
        var x = CAShapeLayer()
        x.strokeColor = UIColor.greenColor().colorWithAlphaComponent(0.8).CGColor
        x.lineWidth = 2.0
        x.fillColor = UIColor.clearColor().CGColor
        return x
        }()
    
    func captureBarCode() {
        outline.path = nil
        sessionMain = AVCaptureSession()
        var session = sessionMain
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input = AVCaptureDeviceInput(device: device, error: &error)
        
        if (error != nil) {
            print(error)
            return
        }
        
        session.addInput(input)
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        
        
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        bringSubLayerToFront(outline)
        bringSubLayerToFront(preview)
        
        preview.frame = self.view.layer.frame
        
        var output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRect.zeroRect
        
        for metadataObject in metadataObjects {
            
            if (metadataObject is AVMetadataMachineReadableCodeObject) {
                
                capturedCode = metadataObject.stringValue
                
                var barCodeObject = preview.transformedMetadataObjectForMetadataObject(metadataObject as AVMetadataObject) as AVMetadataMachineReadableCodeObject
                
                outline.path = createPathFromPoints(barCodeObject.corners).CGPath
                
                NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "tick:", userInfo: nil, repeats: false)
                
                break
            }
        }
    }
    
    func tick(timer: NSTimer) {
        if (sessionMain.running) {
            sessionMain.stopRunning()
            
            outline.removeFromSuperlayer()
            preview.removeFromSuperlayer()
            
            unwind()
        }
    }
    
    func createPathFromPoints(points: NSArray) -> UIBezierPath {
        
        var path = UIBezierPath()
        
        var p0 = CGPoint()
        CGPointMakeWithDictionaryRepresentation(points[0] as CFDictionary, &p0)
        path.moveToPoint(p0)
        
        
        for var i = 1; i < points.count; i++ {
            var pX = CGPoint()
            CGPointMakeWithDictionaryRepresentation(points[i] as CFDictionary, &pX)
            path.addLineToPoint(pX)
        }
        
        path.addLineToPoint(p0)
        
        path.closePath()
        
        return path;
        
    }
    
    func bringSubLayerToFront(layer: CALayer) {
        layer.removeFromSuperlayer()
        self.view.layer.insertSublayer(layer, atIndex: 0)
    }
    
    @IBAction func closeCamera(sender: AnyObject) {
        unwind()
    }
    
    func unwind() {
        self.performSegueWithIdentifier(sourceViewIsList ? "unwindCameraToList" : "unwindCameraToDetail", sender: self)
    }
    
    // Mark: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        captureBarCode()
    }

}
