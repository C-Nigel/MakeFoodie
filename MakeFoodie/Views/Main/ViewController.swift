//
//  ViewController.swift
//  MakeFoodie
//
//  Created by Nigel Cheong on 13/5/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    var isGrantedNotificationAccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            self.isGrantedNotificationAccess = granted
            if !granted{
                //add alert to complain to user
            }
        }
        // Do any additional setup after loading the view.
        
    }


}

