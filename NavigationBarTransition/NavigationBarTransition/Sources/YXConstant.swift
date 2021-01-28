//
//  Constant.swift
//  NavigationBarTransition
//
//  Created by 蔡志文 on 2019/10/22.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit


enum YXConstant {
    
    static var keyWindow: UIWindow {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        return window
    }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13, *) {
            return keyWindow.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    static let deviceIsIpad: Bool = UIDevice.current.model == "iPad"
    
    static var deviceOrientationIsHorizontal: Bool {
        if UIDevice.current.orientation == .landscapeRight { return true }
        if UIDevice.current.orientation == .landscapeLeft { return true }
        return false
    }
    
    static var deviceOrientationIsVertical: Bool {
        if UIDevice.current.orientation == .portrait { return true }
        if UIDevice.current.orientation == .portraitUpsideDown { return true }
        return false
    }
}

extension UIViewController {
    
    var statusAndNavigationBarHeight: CGFloat {
        return YXConstant.statusBarHeight + navigationBarHeight
    }
    
    var navigationBarHeight: CGFloat {
       if let navigationController = navigationController {
           return navigationController.navigationBar.bounds.size.height
       } else {
           return 0
       }
    }
       
}

extension UIColor {
    public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let red = CGFloat(r * 255.0)
            let green = CGFloat(g * 255.0)
            let blue = CGFloat(b * 255.0)
            let alpha = CGFloat(a * 255.0)

            return (red, green, blue, alpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
        
    }
}

public extension DispatchQueue {

    private static var _onceTracker = [String]()

    class func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }
    
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}


struct YXMethodSwizzing {
    
    static func swizzingMethod(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod: Bool = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
    }
    
}
