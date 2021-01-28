//
//  PageSheetViewController.swift
//  NavigationBarTransition
//
//  Created by 蔡志文 on 2019/10/24.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class PageSheetViewController: YXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yx_navigationBar?.backgroundColor = UIColor.systemOrange
    }
    

    /// ❌ 不要重写该方法 使用 `yx_viewDidLayoutSubViews()` 替换
    //    override func viewDidLayoutSubviews() {}
    override func yx_viewDidLayoutSubViews() {
        super.yx_viewDidLayoutSubViews()
    }

}
