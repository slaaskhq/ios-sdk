//
//  ViewController.swift
//  Slaask
//
//  Created by Rémi Delhaye on 05/06/2019.
//  Copyright (c) 2019 Rémi Delhaye. All rights reserved.
//

import UIKit
import Slaask

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Slaask.sharedInstance.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

