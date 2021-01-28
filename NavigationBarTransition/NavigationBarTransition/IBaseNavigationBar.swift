//
//  BaseNavigationBar.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/21.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class IBaseNavigationBar: UINavigationBar {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 13, *) {
            let appearance = standardAppearance
            appearance.shadowColor = nil
            appearance.shadowImage = nil
            appearance.backgroundColor = UIColor(red: 236.0 / 255, green: 236.0 / 255, blue: 236.0 / 255, alpha: 1)
            appearance.backgroundImage = nil
            standardAppearance = appearance
            compactAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            shadowImage = nil
            backgroundColor = UIColor(red: 236.0 / 255, green: 236.0 / 255, blue: 236.0 / 255, alpha: 1)
            setBackgroundImage(nil, for: .default)
            isTranslucent = false
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func configureWithOpacityBackground() {
        if #available(iOS 13, *) {
            let appearance = standardAppearance
            appearance.shadowColor = nil
            appearance.shadowImage = nil
            appearance.backgroundColor = UIColor.clear
            appearance.backgroundImage = UIImage()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .light)
            standardAppearance = appearance
            compactAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            shadowImage = UIImage(color: UIColor.clear)
            backgroundColor = nil
            /// 不设置 title 会发生抖动现象
            setBackgroundImage(UIImage(color: UIColor.clear), for: .default)
            isTranslucent = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13, *) { return }
        for subView in subviews {
            if "\(type(of: subView))" == "_UIBarBackground" {
                subView.isHidden = true
            }
        }
    }
    
}


public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
