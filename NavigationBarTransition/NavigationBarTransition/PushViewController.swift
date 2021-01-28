//
//  PushViewController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/27.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class PushViewController: YXViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yx_navigationBar?.backgroundImage = UIImage(named: "bg")
        yx_navigationBar?.separatorColor = UIColor.clear
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        let wechat = UIImageView(frame: CGRect(x: 0, y: 200, width: view.bounds.size.width, height: 400))
        wechat.image = UIImage(named: "Wechat")
        wechat.contentMode = .scaleAspectFit
        tableView.addSubview(wechat)
        
        
    }

}
