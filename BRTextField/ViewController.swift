//
//  ViewController.swift
//  BRTextField
//
//  Created by Archy on 2017/12/14.
//  Copyright © 2017年 Archy. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var tfNormal: BRTextField!
    @IBOutlet weak var tfClose: BRTextField!
    @IBOutlet weak var tfPassword: BRTextField!
    @IBOutlet weak var tfVerify: BRTextField!
    @IBOutlet weak var tfInternational: BRTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfNormal.style = .normal
        self.tfClose.style = .close
        self.tfPassword.style = .password
        self.tfVerify.style = .verify
        self.tfInternational.style = .international
    }

}

