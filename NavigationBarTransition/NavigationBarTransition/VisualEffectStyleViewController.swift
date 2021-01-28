//
//  VisualEffectStyleViewController.swift
//  NavigationBarTransition
//
//  Created by 蔡志文 on 2019/10/24.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class VisualEffectStyleViewController: YXViewController {

     @IBOutlet weak var segmentControl: UISegmentedControl!
       
       override func viewDidLoad() {
           super.viewDidLoad()

           // Do any additional setup after loading the view.
            /// 开启模糊效果
            yx_navigationBar?.barEffect = UIBlurEffect(style: .light)
       }
       

       @IBAction func changeStyleAction(_ sender: UISegmentedControl) {
            yx_navigationBar!.resetToDefaultStyle()
            yx_navigationBar?.barEffect = UIBlurEffect(style: .light)
            yx_navigationBar?.maxAlpha = 0.55
           switch sender.selectedSegmentIndex {
           case 0:break
           case 1:
                yx_navigationBar?.maxAlpha = 0.65
                yx_navigationBar?.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
           case 2:
                yx_navigationBar?.backgroundImage = UIImage(named: "navbar")
           case 3:
                yx_navigationBar?.alpha = 0
           default:
               break
           }
       }
    
    /// ❌ 不要重写该方法 使用 `yx_viewDidLayoutSubViews()` 替换
      //    override func viewDidLayoutSubviews() {}
       override func yx_viewDidLayoutSubViews() {
           super.yx_viewDidLayoutSubViews()
       }
}

extension VisualEffectStyleViewController: UITableViewDataSource, UITableViewDelegate {
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
        
        let colorAlpha = min(max(offset / self.statusAndNavigationBarHeight, 0), yx_navigationBar!.maxAlpha)
        let barAlpha = min(max(offset / self.statusAndNavigationBarHeight, 0), 1)
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            /// 只调整背景色的透明度
            let color = yx_navigationBar?.backgroundColor?.withAlphaComponent(colorAlpha)
            yx_navigationBar?.backgroundColor = color
        case 1:
            /// 也可以通过 navigationBar 的 alpha 调整整体透明度，穿透效果只对颜色生效
            yx_navigationBar?.alpha = barAlpha
        case 2:
            /// 通过 navigationBar 的 alpha 调整整体透明度，穿透效果对图片不生效
            yx_navigationBar?.alpha = barAlpha
        default: break
        }
        
    }
}
