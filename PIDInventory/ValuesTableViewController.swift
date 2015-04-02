//
//  ValuesTableViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/28/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit

class ValuesTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var currentPIDObject: PIDCase!
    var pickersVisibility: [Bool] = [true, true, true, true]
    var insertNameList: [String] = []
    
    @IBOutlet weak var caseRusted: UISwitch!
    @IBOutlet weak var caseBroken: UISwitch!
    @IBOutlet weak var caseGraffiti: UISwitch!
    @IBOutlet weak var caseOther: UISwitch!
    @IBOutlet weak var caseSeverity: UISegmentedControl!
    @IBOutlet weak var caseColor: UISegmentedControl!
    @IBOutlet weak var caseSide: UISegmentedControl!
    @IBOutlet weak var casePickerViewWidth: UIPickerView!
    @IBOutlet weak var caseWidth: UILabel!
    
    @IBOutlet weak var coverNoCover: UISwitch!
    @IBOutlet weak var coverCracked: UISwitch!
    @IBOutlet weak var coverDiscolored: UISwitch!
    @IBOutlet weak var coverGraffiti: UISwitch!
    @IBOutlet weak var coverOther: UISwitch!
    @IBOutlet weak var coverSeverity: UISegmentedControl!
    
    @IBOutlet weak var insertDatePicker: UIDatePicker!
    @IBOutlet weak var insertBarcode: UITextField!
    @IBOutlet weak var insertDate: UILabel!
    @IBOutlet weak var insertPickerViewCategory: UIPickerView!
    @IBOutlet weak var insertCategory: UILabel!
    @IBOutlet weak var insertName: UILabel!
    @IBOutlet weak var insertFaded: UISwitch!
    @IBOutlet weak var insertTorn: UISwitch!
    @IBOutlet weak var insertMissing: UISwitch!
    @IBOutlet weak var insertWaterDamage: UISwitch!
    @IBOutlet weak var insertOther: UISwitch!
    
    @IBOutlet weak var standRusted: UISwitch!
    @IBOutlet weak var standRustedBasePlate: UISwitch!
    @IBOutlet weak var standBroken: UISwitch!
    @IBOutlet weak var standGraffiti: UISwitch!
    @IBOutlet weak var standOther: UISwitch!
    @IBOutlet weak var standSeverity: UISegmentedControl!
    
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var locationAdjacent: UISwitch!
    @IBOutlet weak var locationCases: UITextField!
    @IBOutlet weak var locationPosition: UITextField!
    @IBOutlet weak var locationOrientation: UISegmentedControl!
    @IBOutlet weak var locationMountType: UISegmentedControl!
    
    // MARK: - Sync
    func syncCaseValues(read: Bool) {
        if read {
            changePickerCellVisibility(false, tag: casePickerViewWidth.tag)
            
            var width = indexFromList(listCaseNumbers, Key: currentPIDObject.caseWidth) ?? 0
            casePickerViewWidth.selectRow(width, inComponent: 0, animated: false)
            caseWidth.text = listCaseNumbers[width].value
            
            caseRusted.on = currentPIDObject.caseRusted
            caseBroken.on = currentPIDObject.caseBroken
            caseGraffiti.on = currentPIDObject.caseGraffiti
            caseOther.on = currentPIDObject.caseOther
            
            caseSide.selectedSegmentIndex = indexFromList(listCaseNumbers, Key: currentPIDObject.caseSide) ?? 0
            caseColor.selectedSegmentIndex = indexFromList(listCaseColors, Key: currentPIDObject.caseColor) ?? 0
            caseSeverity.selectedSegmentIndex = indexFromList(listSeverities, Key: currentPIDObject.caseSeverity) ?? 0
        } else {
            currentPIDObject.caseRusted = caseRusted.on
            currentPIDObject.caseBroken = caseBroken.on
            currentPIDObject.caseGraffiti = caseGraffiti.on
            currentPIDObject.caseOther = caseOther.on
            currentPIDObject.caseWidth = listCaseNumbers[casePickerViewWidth.selectedRowInComponent(0)].key
            currentPIDObject.caseSide = listCaseNumbers[caseSide.selectedSegmentIndex].key
            currentPIDObject.caseColor = listCaseColors[caseColor.selectedSegmentIndex].key
            currentPIDObject.caseSeverity = listSeverities[caseSeverity.selectedSegmentIndex].key
            currentPIDObject.caseModified = true
        }
    }
    
    func syncCoverValues(read: Bool) {
        if read {
            coverNoCover.on = currentPIDObject.coverNoCover
            coverCracked.on = currentPIDObject.coverCracked
            coverDiscolored.on = currentPIDObject.coverDiscolored
            coverGraffiti.on = currentPIDObject.coverGraffiti
            coverOther.on = currentPIDObject.coverOther
            coverSeverity.selectedSegmentIndex = indexFromList(listSeverities, Key: currentPIDObject.coverSeverity) ?? 0
        } else {
            currentPIDObject.coverNoCover = coverNoCover.on
            currentPIDObject.coverCracked = coverCracked.on
            currentPIDObject.coverDiscolored = coverDiscolored.on
            currentPIDObject.coverGraffiti = coverGraffiti.on
            currentPIDObject.coverOther = coverOther.on
            currentPIDObject.coverSeverity = listSeverities[coverSeverity.selectedSegmentIndex].key
            currentPIDObject.coverModified = true
        }
    }
    
    func syncInsertValues(read: Bool) {
        if read {
            changePickerCellVisibility(false, tag: insertPickerViewCategory.tag)
            changePickerCellVisibility(false, tag: insertDatePicker.tag)
            
            setInsertCategoryNameDate(currentPIDObject.insertCategory, name: currentPIDObject.insertName, date: currentPIDObject.insertDate)
            
            insertBarcode.text = currentPIDObject.insertBarcode
            
            insertFaded.on = currentPIDObject.insertFaded
            insertTorn.on = currentPIDObject.insertTorn
            insertMissing.on = currentPIDObject.insertMissing
            insertWaterDamage.on = currentPIDObject.insertWaterDamage
            insertOther.on = currentPIDObject.insertOther
        } else {
            currentPIDObject.insertCategory = listInsertCategories[insertPickerViewCategory.selectedRowInComponent(0)].key
            var row = insertPickerViewCategory.selectedRowInComponent(1)
            currentPIDObject.insertName = insertNameList.count > row ? insertNameList[row] : ""
            currentPIDObject.insertDate = formatter.stringFromDate(insertDatePicker.date)
            currentPIDObject.insertBarcode = insertBarcode.text
            
            currentPIDObject.insertFaded = insertFaded.on
            currentPIDObject.insertTorn = insertTorn.on
            currentPIDObject.insertMissing = insertMissing.on
            currentPIDObject.insertWaterDamage = insertWaterDamage.on
            currentPIDObject.insertOther = insertOther.on
            currentPIDObject.insertModified = true
        }
    }
    
    func setInsertCategoryNameDate(category: String, name: String, date: String) {
        var categoryIndex = indexFromList(listInsertCategories, Key: category) ?? 0
        retrieveInsertNameList(listInsertCategories[categoryIndex].key)
        var nameIndex = find(insertNameList, name) ?? 0
        
        insertPickerViewCategory.selectRow(categoryIndex, inComponent: 0, animated: false)
        insertPickerViewCategory.selectRow(nameIndex, inComponent: 1, animated: false)
        
        insertCategory.text = listInsertCategories[categoryIndex].value
        insertName.text = insertNameList[nameIndex]
        
        var newDate = date.toInt() == 0 ? NSDate() : formatter.dateFromString(date)!
        
        insertDatePicker.setDate(newDate, animated: false)
        refreshDate()
    }
    
    func syncStandValues(read: Bool) {
        if read {
            standRusted.on = currentPIDObject.standRusted
            standRustedBasePlate.on = currentPIDObject.standRustedBasePlate
            standBroken.on = currentPIDObject.standBroken
            standGraffiti.on = currentPIDObject.standGraffiti
            standOther.on = currentPIDObject.standOther
            standSeverity.selectedSegmentIndex = indexFromList(listSeverities, Key: currentPIDObject.standSeverity) ?? 0
        } else {
            currentPIDObject.standRusted = standRusted.on
            currentPIDObject.standRustedBasePlate = standRustedBasePlate.on
            currentPIDObject.standBroken = standBroken.on
            currentPIDObject.standGraffiti = standGraffiti.on
            currentPIDObject.standOther = standOther.on
            currentPIDObject.standSeverity = listSeverities[standSeverity.selectedSegmentIndex].key
            currentPIDObject.standModified = true
        }
    }
    
    func syncLocationValues(read: Bool) {
        if read {
            changePickerCellVisibility(false, tag: locationPickerView.tag)
            
            var location = indexFromList(listLocationNames, Key: currentPIDObject.locationDescription) ?? 0
            locationPickerView.selectRow(location, inComponent: 0, animated: false)
            locationDescription.text = listLocationNames[location ?? 0].value
            
            locationAdjacent.on = currentPIDObject.locationAdjacentTVM
            locationCases.text = currentPIDObject.locationCasesInCluster
            locationPosition.text = currentPIDObject.locationPositionInCluster
            locationOrientation.selectedSegmentIndex = indexFromList(listLocationOrientations, Key: currentPIDObject.locationOrientation) ?? 0
            locationMountType.selectedSegmentIndex = indexFromList(listLocationMounts, Key: currentPIDObject.locationMountType) ?? 0
        } else {
            currentPIDObject.locationDescription = listLocationNames[locationPickerView.selectedRowInComponent(0)].key
            currentPIDObject.locationAdjacentTVM = locationAdjacent.on
            currentPIDObject.locationCasesInCluster = locationCases.text
            currentPIDObject.locationPositionInCluster = locationPosition.text
            currentPIDObject.locationOrientation = listLocationOrientations[locationOrientation.selectedSegmentIndex].key
            currentPIDObject.locationMountType = listLocationMounts[locationMountType.selectedSegmentIndex].key
            currentPIDObject.locationModified = true
        }
    }
    
    // Mark: - TODO
    func retrieveInsertNameList(category: String) {
        insertNameList = appDelegate.queryList(PIDInsertName.name, ToRetrieve: PIDInsertName.insertName, aCondition:PIDInsertName.insertCategory, aValue: category, SortBy:PIDInsertName.insertName)
    }
    
    @IBAction func unwindToValuesTableViewController(segue: UIStoryboardSegue) {
        var scanned = (segue.sourceViewController as CameraViewController).capturedCode
        insertBarcode.text = scanned
        insertBarcodeChanged(insertBarcode)
        
        self.view.endEditing(true)
    }
    
    @IBAction func insertBarcodeChanged(sender: UITextField) {
        linkInserts(true)
    }
    
    // MARK: - Date
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        refreshDate()
        linkInserts(false)
    }
    
    func linkInserts(fromBarcode: Bool) {
        
        var row = insertPickerViewCategory.selectedRowInComponent(1)
        
        var barcode = insertBarcode.text
        var category = listInsertCategories[insertPickerViewCategory.selectedRowInComponent(0)].key
        var name = insertNameList.count > row ? insertNameList[row] : ""
        var date = formatter.stringFromDate(insertDatePicker.date)
        
        var properties: [(property: String, value: String)] = [(PIDInsertName.insertCategory, category), (PIDInsertName.insertName, name), (PIDInsertName.insertDate, date)]
        
        var x = barcode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var y = x.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var z = x.stringByReplacingOccurrencesOfString("_", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        
        var insertFromBarcode: PIDInsert? = appDelegate.querySingle(PIDInsertName.name, ByProperty: PIDInsertName.insertBarcode, aValue: y)
        var insertFromBarcode2: PIDInsert? = appDelegate.querySingle(PIDInsertName.name, ByProperty: PIDInsertName.insertBarcode, aValue: z)
        var insertFromName: PIDInsert? = appDelegate.querySingle(PIDInsertName.name, Properties: properties)
        
        if fromBarcode {
            if insertFromBarcode != nil {
                setInsertCategoryNameDate(insertFromBarcode!.category, name: insertFromBarcode!.name, date: insertFromBarcode!.date)
            }
            if insertFromBarcode2 != nil {
                setInsertCategoryNameDate(insertFromBarcode2!.category, name: insertFromBarcode2!.name, date: insertFromBarcode2!.date)
            }
        } else {
            if insertFromName != nil {
                insertBarcode.text = insertFromName!.barcode
            }
        }
    }
    
    func refreshDate() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        insertDate.text = dateFormatter.stringFromDate(insertDatePicker.date)
    }
    
    // MARK: - Find Picker
    func pickerIndex(tag: Int) -> Int? {
        return find([100, 200, 400, 500], tag)
    }
    
    func picker(tag: Int) -> (picker:UIView?, visible: Bool) {
        switch tag {
        case 100:
            return (casePickerViewWidth, pickersVisibility[0])
        case 200:
            return (insertPickerViewCategory, pickersVisibility[1])
        case 400:
            return (insertDatePicker, pickersVisibility[2])
        case 500:
            return (locationPickerView, pickersVisibility[3])
        default:
            return (nil, false)
        }
    }
    
    func pickerLabel(tag: Int) -> UILabel? {
        switch tag {
        case 100:
            return caseWidth
        case 200:
            return insertCategory
        case 300:
            return insertName
        case 400:
            return insertDate
        case 500:
            return locationDescription
        default:
            return nil
        }
    }
    
    func pickerCount(tag: Int) -> Int {
        switch tag {
        case 100:
            return listCaseNumbers.count
        case 200:
            return listInsertCategories.count
        case 300:
            return insertNameList.count
        case 500:
            return listLocationNames.count
        default:
            return 0
        }

    }
    
    func pickerValue(tag: Int, row: Int) -> String {
        switch tag {
        case 100:
            return listCaseNumbers[row].value
        case 200:
            return listInsertCategories[row].value
        case 300:
            return insertNameList.count > row ? insertNameList[row] : ""
        case 500:
            return listLocationNames[row].value
        default:
            return ""
        }
    }

    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tag = tableView.cellForRowAtIndexPath(indexPath)?.tag ?? 0
        
        if pickerIndex(tag) != nil {
            changePickerCellVisibility(!picker(tag).visible, tag: tag)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if indexPath.row > 0 {
            var path = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            var cell = super.tableView(tableView, cellForRowAtIndexPath: path)
            var tag = cell.tag
            if pickerIndex(tag) != nil {
                height = picker(tag).visible ? 162 : 0
            }
        }
        
        return height
    }
    
    //MARK: - UIPickerView
    func changePickerCellVisibility(shouldDisplay: Bool, tag: Int) {
        if shouldDisplay {
            pickersVisibility[pickerIndex(tag)!] = true
            tableView.beginUpdates()
            tableView.endUpdates()
            
            UIView.animateWithDuration(0.25, animations: { self.picker(tag).picker!.alpha = 1 })
            
        }
        else {
            pickersVisibility[pickerIndex(tag)!]  = false
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.animateWithDuration(0.25, animations: { self.picker(tag).picker!.alpha = 0 })
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView.tag == 200 ? 2 : 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var tag = pickerView.tag == 200 && component == 1 ? 300 : pickerView.tag
        return pickerCount(tag)
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var tag = pickerView.tag == 200 && component == 1 ? 300 : pickerView.tag
        return pickerValue(tag, row: row)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 200 {
            if component == 0 {
                retrieveInsertNameList(listInsertCategories[row].key)
                (picker(pickerView.tag).picker as UIPickerView).reloadComponent(1)
            }
            
            pickerLabel(300)!.text = pickerValue(300, row: pickerView.selectedRowInComponent(1))
            
            linkInserts(false)
        }
        
        if component == 0 {
            pickerLabel(pickerView.tag)!.text = pickerValue(pickerView.tag, row: row)
        }
    }
    
    // MARK: - Validation
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        var  nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.NoStyle
        
        var newString = NSString(format: "%@%@", textField.text, string)
        
        var number = nf.numberFromString(newString)
        
        if let n = number {
            return Int(n) >= textField.tag && Int(n) < 7
        }
        
        return false
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch restorationIdentifier! {
        case "case":
            syncCaseValues(true)
        case "cover":
            syncCoverValues(true)
        case "insert":
            syncInsertValues(true)
        case "stand":
            syncStandValues(true)
        case "location":
            syncLocationValues(true)
        default: break
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        switch restorationIdentifier! {
        case "case":
            syncCaseValues(false)
        case "cover":
            syncCoverValues(false)
        case "insert":
            syncInsertValues(false)
        case "stand":
            syncStandValues(false)
        case "location":
            syncLocationValues(false)
        default: break
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? CameraViewController {
            dest.sourceView = 2
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
