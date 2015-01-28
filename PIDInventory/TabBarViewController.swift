//
//  TabBarViewController.swift
//  PIDInventory
//
//  Created by Baker on 1/28/15.
//  Copyright (c) 2015 Umetzu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToTabBarViewController(segue: UIStoryboardSegue) {
        var source: AnyObject = segue.sourceViewController
        if (source is CameraViewController) {
            if let dest = selectedViewController as? ListViewController {
                dest.textFieldPID.text = (source as CameraViewController).capturedCode
            }
        }
    }

}
