//
//  ValuesTableViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/28/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit

class ValuesTableViewController: UITableViewController {

    var currentPIDObject: PIDObject!
    
    @IBOutlet weak var caseBent: UISwitch!
    @IBOutlet weak var caseComingApart: UISwitch!
    @IBOutlet weak var caseRusted: UISwitch!
    @IBOutlet weak var casePitted: UISwitch!
    @IBOutlet weak var caseBroken: UISwitch!
    @IBOutlet weak var caseGraffiti: UISwitch!
    @IBOutlet weak var caseUnauthorized: UISwitch!
    @IBOutlet weak var caseOther: UISwitch!
    @IBOutlet weak var caseCondition: UISegmentedControl!
    
    @IBOutlet weak var coverNoCover: UISwitch!
    @IBOutlet weak var coverCracked: UISwitch!
    @IBOutlet weak var coverDiscolored: UISwitch!
    @IBOutlet weak var coverGraffiti: UISwitch!
    @IBOutlet weak var coverUnauthorized: UISwitch!
    @IBOutlet weak var coverOther: UISwitch!
    @IBOutlet weak var coverCondition: UISegmentedControl!
    
    @IBOutlet weak var insertFaded: UISwitch!
    @IBOutlet weak var insertTorn: UISwitch!
    @IBOutlet weak var insertMissing: UISwitch!
    @IBOutlet weak var insertOther: UISwitch!
    @IBOutlet weak var insertCondition: UISegmentedControl!
    @IBOutlet weak var insertDescription: UITextView!
    
    @IBOutlet weak var standRusted: UISwitch!
    @IBOutlet weak var standRustedBasePlate: UISwitch!
    @IBOutlet weak var standBroken: UISwitch!
    @IBOutlet weak var standGraffiti: UISwitch!
    @IBOutlet weak var standUnauthorized: UISwitch!
    @IBOutlet weak var standOther: UISwitch!
    @IBOutlet weak var standCondition: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch restorationIdentifier! {
            case "case":
                caseBent.on = currentPIDObject.caseBent
                caseComingApart.on = currentPIDObject.caseComingApart
                caseRusted.on = currentPIDObject.caseRusted
                casePitted.on = currentPIDObject.casePitted
                caseBroken.on = currentPIDObject.caseBroken
                caseGraffiti.on = currentPIDObject.caseGraffiti
                caseUnauthorized.on = currentPIDObject.caseUnauthorized
                caseOther.on = currentPIDObject.caseOther
                caseCondition.selectedSegmentIndex = Int(currentPIDObject.caseCondition)
            case "cover":
                coverNoCover.on = currentPIDObject.coverNoCover
                coverCracked.on = currentPIDObject.coverCracked
                coverDiscolored.on = currentPIDObject.coverDiscolored
                coverGraffiti.on = currentPIDObject.coverGraffiti
                coverUnauthorized.on = currentPIDObject.coverUnauthorized
                coverOther.on = currentPIDObject.coverOther
                coverCondition.selectedSegmentIndex = Int(currentPIDObject.coverCondition)
            case "insert":
                insertFaded.on = currentPIDObject.insertFaded
                insertTorn.on = currentPIDObject.insertTorn
                insertMissing.on = currentPIDObject.insertMissing
                insertOther.on = currentPIDObject.insertOther
                insertCondition.selectedSegmentIndex = Int(currentPIDObject.insertCondition)
                insertDescription.text = currentPIDObject.insertDescription
            case "stand":
                standRusted.on = currentPIDObject.standRusted
                standRustedBasePlate.on = currentPIDObject.standRustedBasePlate
                standBroken.on = currentPIDObject.standBroken
                standGraffiti.on = currentPIDObject.standGraffiti
                standUnauthorized.on = currentPIDObject.standUnauthorized
                standOther.on = currentPIDObject.standOther
                standCondition.selectedSegmentIndex = Int(currentPIDObject.standCondition)
            default: break
        }
    }

    override func viewWillDisappear(animated: Bool) {
        switch restorationIdentifier! {
        case "case":
             currentPIDObject.caseBent = caseBent.on
             currentPIDObject.caseComingApart = caseComingApart.on
             currentPIDObject.caseRusted = caseRusted.on
             currentPIDObject.casePitted = casePitted.on
             currentPIDObject.caseBroken = caseBroken.on
             currentPIDObject.caseGraffiti = caseGraffiti.on
             currentPIDObject.caseUnauthorized = caseUnauthorized.on
             currentPIDObject.caseOther = caseOther.on
             currentPIDObject.caseCondition = Int32(caseCondition.selectedSegmentIndex)
        case "cover":
            currentPIDObject.coverNoCover = coverNoCover.on
            currentPIDObject.coverCracked = coverCracked.on
            currentPIDObject.coverDiscolored = coverDiscolored.on
            currentPIDObject.coverGraffiti = coverGraffiti.on
            currentPIDObject.coverUnauthorized = coverUnauthorized.on
            currentPIDObject.coverOther = coverOther.on
            currentPIDObject.coverCondition = Int32(coverCondition.selectedSegmentIndex)
        case "insert":
            currentPIDObject.insertFaded = insertFaded.on
            currentPIDObject.insertTorn = insertTorn.on
            currentPIDObject.insertMissing = insertMissing.on
            currentPIDObject.insertOther = insertOther.on
            currentPIDObject.insertCondition = Int32(insertCondition.selectedSegmentIndex)
            currentPIDObject.insertDescription = insertDescription.text
        case "stand":
            currentPIDObject.standRusted = standRusted.on
            currentPIDObject.standRustedBasePlate = standRustedBasePlate.on
            currentPIDObject.standBroken = standBroken.on
            currentPIDObject.standGraffiti = standGraffiti.on
            currentPIDObject.standUnauthorized = standUnauthorized.on
            currentPIDObject.standOther = standOther.on
            currentPIDObject.standCondition = Int32(standCondition.selectedSegmentIndex)
        default: break
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
