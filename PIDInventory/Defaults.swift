//
//  Defaults.swift
//  PIDInventory
//
//  Created by Baker on 2/3/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Image Functions
func documentsPathForFileName(name: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
    let path = paths[0] as String;
    let fullPath = path.stringByAppendingPathComponent(name)
    
    return fullPath
}

func savePicture(image: UIImage) -> String {
    let imageData = UIImageJPEGRepresentation(image, 0.5)
    let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
    let path = documentsPathForFileName(relativePath)
    imageData.writeToFile(path, atomically: true)
    
    return relativePath
}

func readPicture(path: String) -> UIImage? {
    let oldFullPath = documentsPathForFileName(path)
    let oldImageData = NSData(contentsOfFile: oldFullPath)
    
    return oldImageData != nil ? UIImage(data: oldImageData!) : nil
}

func base64FromPicturePath(path: String) -> String {
    var image = readPicture(path)
    if image != nil {
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    return ""
}

func completedText(status: Bool) -> String {
    return status ? "😌" : "😨"
}

func indexFromList(list:[(key: String, value: String)], Key key:String) -> Int? {
    for var i = 0; i < list.count; i++ {
        if list[i].key == key {
            return i
        }
    }
    
    return nil
}

 let formatter: NSDateFormatter = {
    var c = NSDateFormatter()
    c.dateFormat = "yyyyMMdd"
    return c
    }()

//Lists are index based!!

let listInsertCategories:[(key: String, value: String)] = [
    ("AD", "Advertisement"),
    ("LRS", "LR_Schedule"),
    ("LRSM", "LR_System_Map"),
    ("O", "Other"),
    ("RS", "Rail_Schedule"),
    ("RSM", "Rail_System_Map"),
    ("SAM", "Station_Area_Map"),
    ("TVM", "TVM")]

let listCaseNumbers:[(key: String, value: String)] = [
    ("1", "Single"),
    ("2", "Double"),
    ("3", "Triple"),
    ("4", "Quadruple"),
    ("5", "Quintuple"),
    ("6", "Sextuple")]

let listCaseColors:[(key: String, value: String)] = [
    ("BL", "Black"),
    ("AG", "Silver"),
    ("OT", "Other")]

let listSeverities:[(key: String, value: String)] = [
    ("PR", "Poor"),
    ("FR", "Fair"),
    ("GD", "Good"),
    ("NA", "N/A")]

let listLocationNames:[(key: String, value: String)] = [
    ("CPBD", "Center Island Platform - Bidirectional"),
    ("CPIO", "Center Island Platform - Inbound Only"),
    ("CPOO", "Center Island Platform - Outbound Only"),
    ("NONJ", "Non NJ Transit Property"),
    ("OTHR", "Other"),
    ("PARK", "Parking Area"),
    ("SPBD", "Side Platform - Bidirectional"),
    ("SPIO", "Side Platform - Inbound Only"),
    ("SPOO", "Side Platform - Outbound Only"),
    ("STAT", "Station Areas (Entrances/Waiting Areas)")]

let listLocationOrientations:[(key: String, value: String)] = [
    ("PAR", "Parallel"),
    ("PERP", "Perpendicular"),
    ("NA", "Not Applicable")]

let listLocationMounts:[(key: String, value: String)] = [
    ("SM", "Stand"),
    ("WM", "Wall"),
    ("CM", "Case"),
    ("FM", "Frame"),
    ("FS", "Free")]

