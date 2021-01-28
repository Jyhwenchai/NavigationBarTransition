//
//  BaseNavigationController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/21.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class YXNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 13, *) {
            let appearance = navigationBar.standardAppearance
            appearance.shadowColor = nil
            appearance.shadowImage = nil
            appearance.backgroundColor = nil
            appearance.backgroundImage = nil
            appearance.backgroundEffect = nil
            appearance.configureWithTransparentBackground()
            navigationBar.standardAppearance = appearance
        } else {
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.setBackgroundImage(nil, for: .compact)
            navigationBar.barTintColor = nil
            navigationBar.barTintColor = UIColor.clear
            
            removeBarBackgroundMask()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        removeBarBackgroundMask()
    }
    
    /// 移除 _UIBarBackground 带来的模糊图层
    func removeBarBackgroundMask() {
        for subView in navigationBar.subviews {
            if "\(type(of: subView))" == "_UIBarBackground" {
                for view in subView.subviews {
                    view.isHidden = true
                }
            }
        }
    }
    
    
}
