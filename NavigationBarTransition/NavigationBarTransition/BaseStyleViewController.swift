//
//  BaseStyleViewController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/23.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class BaseStyleViewController: YXViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        // 如果不需要导航栏的话，可以取消注释查看效果
        super.viewDidLoad()
    }
    
    /// ❌ 不要重写该方法 使用 `yx_viewDidLayoutSubViews()` 替换
//    override func viewDidLayoutSubviews() {}
    override func yx_viewDidLayoutSubViews() {
        super.yx_viewDidLayoutSubViews()
    }

    @IBAction func changeStyleAction(_ sender: UISegmentedControl) {
        
        yx_navigationBar!.resetToDefaultStyle()
        switch sender.selectedSegmentIndex {
        case 0: break
        case 1:
            yx_navigationBar?.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case 2:
            yx_navigationBar?.backgroundImage = UIImage(named: "navbar")
        case 3:
            yx_navigationBar?.alpha = 0
        default:
            break
        }
    }
    
}

extension BaseStyleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "click cell \(indexPath.row) to push"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + self.statusAndNavigationBarHeight
        let rate = min(max(offset / self.statusAndNavigationBarHeight, 0), 1)
        
        switch segmentControl.selectedSegmentIndex {
        case 0, 1:
            let color = yx_navigationBar?.backgroundColor?.withAlphaComponent(rate)
            yx_navigationBar?.backgroundColor = color
        case 2:
            yx_navigationBar?.alpha = rate
        default: break
        }
        
    }
  
}
