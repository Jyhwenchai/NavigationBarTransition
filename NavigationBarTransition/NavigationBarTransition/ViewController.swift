//
//  ViewController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/21.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    

     @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) { }
}

