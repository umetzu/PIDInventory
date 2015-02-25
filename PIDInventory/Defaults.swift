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

func clearDirectory() {
    var fm = NSFileManager.defaultManager()
    var directory = documentsPathForFileName("")
    
    if let fileList = fm.contentsOfDirectoryAtPath(directory, error:nil) as? [String] {
        for file in fileList {
            if file.rangeOfString("image_") != nil {
                fm.removeItemAtPath(String(format: "%@/%@", directory, file), error:nil)
            }
        }
    }
}

func savePicture(image: UIImage) -> String {
    
    var size = CGSize(width: image.size.width / 2, height: image.size.height / 2)
    UIGraphicsBeginImageContext(size)
    image.drawInRect(CGRectMake(0, 0, size.width, size.height))
    var newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let imageData = UIImageJPEGRepresentation(newImage, 0.5)
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
    return status ? "😁" : "😨"
}

func keysFromValue(list:[(key: String, value: String)], Value value:String) -> [String] {
    var result: [String] = []
    
    for var i = 0; i < list.count; i++ {
        if (list[i].value.lowercaseString.rangeOfString(value.lowercaseString) != nil) {
            result.append(list[i].key)
        }
    }
    
    return result
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

 let listStations:[(key: String, value: String)] = [("CABM", "Aberdeen Matawan"), ("CABS", "Absecon"), ("CACC", "Atlantic City"), ("CADS", "Anderson Street - Hackensack"), ("CALH", "Allenhurst"), ("CALL", "Allendale"), ("CANN", "Annandale"), ("CASP", "Asbury Park"), ("CATO", "Atco"), ("CAVL", "Avenel"), ("CBAY", "Bay Street - Montclair"), ("CBBK", "Bound Brook"), ("CBDB", "Bradley Beach"), ("CBDS", "Broad Street Station"), ("CBEL", "Belmar"), ("CBFL", "Broadway"), ("CBHD", "Bay Head"), ("CBKC", "Brick Church"), ("CBKR", "Basking Ridge"), ("CBMF", "Bloomfield"), ("CBON", "Boonton"), ("CBVL", "Bernardsville"), ("CBWR", "Bridgewater"), ("CBYH", "Berkeley Heights"), ("CCAM", "Chatham"), ("CCLF", "Clifton"), ("CCNV", "Convent Station"), ("CCRN", "Cranford"), ("CCYH", "Cherry Hill"), ("CDEL", "Delawanna"), ("CDNN", "Dunellen"), ("CDNV", "Denville"), ("CDOV", "Dover"), ("CEDI", "Edison"), ("CEGH", "Egg Harbor City"), ("CELB", "Elberon"), ("CEMN", "Emerson"), ("CEOG", "East Orange"), ("CEWR", "Newark Airport"), ("CEXS", "Essex Street - Hackensack"), ("CEZB", "Elizabeth"), ("CFHL", "Far Hills"), ("CFWD", "Fanwood"), ("CGAR", "Garfield"), ("CGDS", "Gladstone"), ("CGIL", "Gillette"), ("CGNR", "Glen Rock - Main"), ("CGRG", "Glen Ridge"), ("CGRO", "Glen Rock - Boro Hall"), ("CGRW", "Garwood"), ("CHAM", "Hamilton"), ("CHAW", "Hawthorne"), ("CHAZ", "Hazlet"), ("CHBG", "High Bridge"), ("CHCT", "Hackettstown"), ("CHHA", "Highland Avenue"), ("CHLD", "Hillsdale"), ("CHMM", "Hammonton"), ("CHOB", "Hoboken Terminal"), ("CHOH", "Ho-Ho-Kus"), ("CJSY", "Jersey Avenue"), ("CKGL", "Kingsland"), ("CLBH", "Long Branch"), ("CLEB", "Lebanon"), ("CLFA", "Little Falls"), ("CLIN", "Linden"), ("CLKH", "Lake Hopatcong"), ("CLPK", "Lincoln Park"), ("CLSC", "Secaucus Junction Lower Level"), ("CLSR", "Little Silver"), ("CLWD", "Lindenwold"), ("CLYH", "Lyndhurst"), ("CLYO", "Lyons"), ("CMAD", "Madison"), ("CMAH", "Mahwah"), ("CMAR", "Mt. Arlington"), ("CMCH", "Montclair Heights"), ("CMCU", "Montclair St Univ"), ("CMDW", "Meadowlands"), ("CMET", "Metropark"), ("CMHL", "Murray Hill"), ("CMID", "Middletown"), ("CMLB", "Millburn"), ("CMLG", "Millington"), ("CMNV", "Montvale"), ("CMOP", "Morris Plains"), ("CMOR", "Morristown"), ("CMPK", "Monmouth Park"), ("CMSQ", "Manasquan"), ("CMTA", "Mountain Avenue"), ("CMTL", "Mountain Lakes"), ("CMTN", "Mountain Station"), ("CMTO", "Mount Olive"), ("CMTV", "Mountain View - Wayne"), ("CMUT", "Metuchen"), ("CMWD", "Maplewood"), ("CNBH", "North Branch"), ("CNBK", "New Brunswick"), ("CNBL", "New Bridge Landing"), ("CNET", "Netcong"), ("CNEZ", "North Elizabeth"), ("CNPV", "New Providence"), ("CNTW", "Netherwood"), ("CNWK", "Newark Penn Station"), ("CNYP", "New York Penn Station"), ("CODL", "Oradell"), ("CORG", "Orange"), ("CPAM", "Perth Amboy"), ("CPAS", "Passaic"), ("CPAT", "Paterson"), ("CPDV", "Plauderville"), ("CPHI", "30th Street"), ("CPKR", "Park Ridge"), ("CPNF", "Plainfield"), ("CPNJ", "Princeton Junction"), ("CPPB", "Point Pleasant"), ("CPPK", "Peapack"), ("CPRN", "Princeton"), ("CPTC", "Pennsauken"), ("CR17", "Route 17 Ramsey"), ("CR23", "Wayne Route 23 Transit Center"), ("CRAH", "Rahway"), ("CRAM", "Ramsey"), ("CRAR", "Raritan"), ("CRBK", "Red Bank"), ("CRFL", "Radburn"), ("CRSP", "Roselle Park"), ("CRUF", "Rutherford"), ("CRVE", "River Edge"), ("CRWD", "Ridgewood"), ("CSAM", "South Amboy"), ("CSEC", "Secaucus Junction"), ("CSFF", "Suffern"), ("CSMT", "Summit"), ("CSOG", "South Orange"), ("CSOM", "Somerville"), ("CSPL", "Spring Lake"), ("CSRG", "Stirling"), ("CSRH", "Short Hills"), ("CTBR", "Mount Tabor"), ("CTET", "Teterboro - Williams Ave"), ("CTOW", "Towaco"), ("CTRE", "Trenton"), ("CUMC", "Upper Montclair"), ("CUNN", "Union"), ("CUSC", "Secaucus Junction Upper Level"), ("CWCL", "Woodcliff Lake"), ("CWDB", "Woodbridge"), ("CWDR", "Wood-Ridge"), ("CWFD", "Westfield"), ("CWGA", "Watchung Avenue"), ("CWGS", "Walnut Street"), ("CWHH", "White House"), ("CWTA", "Watsessing"), ("CWWD", "Westwood"), ("CWWK", "Waldwick"), ("H22N", "E 22nd Street"), ("H2ND", "2nd Street"), ("H34T", "E 34th Street"), ("H45T", "E 45th Street"), ("H8TH", "8th Street"), ("H9TH", "9th Street"), ("HBER", "Bergenline Avenue"), ("HDAN", "Danforth Avenue"), ("HESS", "Essex Street"), ("HEXP", "Exchange Place"), ("HGAF", "Garfield Avenue"), ("HHCV", "Harismus Cove"), ("HHFC", "Harborside"), ("HHOB", "Hoboken Terminal (LRT)"), ("HJYA", "Jersey Avenue"), ("HLHR", "Lincoln Harbor"), ("HLSP", "Liberty State Park"), ("HMAR", "Marin Blvd"), ("HMLK", "Martin Luther King Dr"), ("HPAV", "Newport"), ("HPIM", "Port Imperial"), ("HRIC", "Richard Street"), ("HTON", "Tonnelle Avenue"), ("HWSA", "West Side Avenue"), ("NATS", "Atlantic Street"), ("NBBP", "Branch Brook Park"), ("NBDS", "Broad Street (Light Rail)"), ("NBMF", "Bloomfield Avenue"), ("NDAV", "Davenport"), ("NGVS", "Grove Street"), ("NMIL", "Military Park"), ("NNJP", "NJPAC/ Center Street"), ("NNOR", "Norfolk Street"), ("NNWK", "Newark Penn Station (Light Rail)"), ("NORN", "Orange Street"), ("NPKA", "Park Avenue"), ("NRFS", "Riverfront Stadium"), ("NSVL", "Silver Lake"), ("NWAR", "Warren Street"), ("NWAS", "Washington Street"), ("NWHP", "Washington Park"), ("R36T", "36th Street"), ("RAQU", "Aquarium"), ("RBEV", "Beverly"), ("RBOR", "Bordentown"), ("RBTC", "Burlington Center Towne"), ("RBUR", "Burlington"), ("RCAS", "Cass"), ("RCIN", "Cinnaminson"), ("RCOO", "Rutgers Southbound"), ("RDEL", "Delanco"), ("RENT", "Waterfront Entertainment Center"), ("RFLO", "Florence"), ("RHAM", "Hamilton Avenue"), ("RPAL", "Palmyra"), ("RPEN", "Route 73"), ("RPTC", "Pennsauken"), ("RRIV", "Riverside"), ("RROE", "Roebling"), ("RRVS", "Riverton"), ("RTRE", "Trenton (Light Rail)"), ("RWRT", "Walter Rand Transportation Center")]

