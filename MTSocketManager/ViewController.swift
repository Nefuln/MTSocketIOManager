//
//  ViewController.swift
//  MTSocketManager
//
//  Created by 李宁 on 2018/12/4.
//  Copyright © 2018 李宁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MTSocketManager.manager.start()
    }
}

