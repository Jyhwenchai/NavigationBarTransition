//
//  DisableBarViewController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/27.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class DisableBarViewController: YXViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        disableNavigationBar = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}
