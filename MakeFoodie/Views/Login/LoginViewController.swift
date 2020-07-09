//
//  LoginViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emaily: UITextField!
    
    @IBOutlet weak var passwordy: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.black
        emaily.layer.borderColor = myColor.cgColor
        emaily.layer.borderWidth = 1.0
        passwordy.layer.borderColor = myColor.cgColor
        passwordy.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
