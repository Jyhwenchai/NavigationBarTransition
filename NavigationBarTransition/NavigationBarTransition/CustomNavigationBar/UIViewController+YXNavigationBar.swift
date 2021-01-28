//
//  UIViewController+YXNavigationBar.swift
//  NavigationBarTransition
//
//  Created by 蔡志文 on 2019/10/25.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

//MARK: - Associate Propertys
extension UIViewController {

    private struct YXAssociatedKey {
        static var disableNavigationBar:            UInt8 = 0
        static var navigationBar:                   UInt8 = 0
        static var navigationBarOffset:             UInt8 = 0
        static var fixedNavigationBarPosition:      UInt8 = 0
    }

    var yx_disableNavigationBar: Bool {
        get {
            if self is UINavigationController { return true }
            guard let value = objc_getAssociatedObject(self, &YXAssociatedKey.disableNavigationBar) else { return true }
            return value as! Bool
        }
        set {
            if self is UINavigationController { return }
            objc_setAssociatedObject(self, &YXAssociatedKey.disableNavigationBar, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var yx_navigationBar: YXNavigationBar? {
        get {  return __yx_navigationBar }
    }
    

    var __yx_navigationBar: YXNavigationBar? {
        get {
            guard let value: YXNavigationBar = objc_getAssociatedObject(self, &YXAssociatedKey.navigationBar) as? YXNavigationBar else {
                return nil
            }

            return value
        }

        set {
            objc_setAssociatedObject(self, &YXAssociatedKey.navigationBar, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var yx_navigationBarOffset: CGFloat {
        get {
            guard let value = objc_getAssociatedObject(self, &YXAssociatedKey.navigationBarOffset) else { return 0.0 }
            return value as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &YXAssociatedKey.navigationBarOffset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var yx_fixedNavigationBarPosition: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &YXAssociatedKey.fixedNavigationBarPosition) else { return true }
            return value as! Bool
        }
        set {
            objc_setAssociatedObject(self, &YXAssociatedKey.fixedNavigationBarPosition, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
}

//MARK: - Method Swizzing
extension UIViewController {

    public class func yx_initialize() {
        
        if self != UIViewController.self {
            return
        }
        
        DispatchQueue.once {
            YXMethodSwizzing.swizzingMethod(cls: self,
                            originalSelector: #selector(UIViewController.viewDidLoad),
                            swizzledSelector: #selector(UIViewController.yx_viewDidLoad))
            YXMethodSwizzing.swizzingMethod(cls: self,
                            originalSelector: #selector(UIViewController.viewWillAppear(_:)),
                            swizzledSelector: #selector(UIViewController.yx_viewWillAppear(_:)))
            YXMethodSwizzing.swizzingMethod(cls: self,
                               originalSelector: #selector(UIViewController.viewWillDisappear(_:)),
                               swizzledSelector: #selector(UIViewController.yx_viewWillDisappear(_:)))
            YXMethodSwizzing.swizzingMethod(cls: self,
                               originalSelector: #selector(UIViewController.viewDidLayoutSubviews),
                               swizzledSelector: #selector(UIViewController.yx_viewDidLayoutSubviews))
        }
        
    }
    
    
    @objc func yx_viewDidLoad() {
        yx_viewDidLoad()
        configureNavigationBar()
    }
    
    @objc func yx_viewWillAppear(_ animated: Bool) {
        yx_viewWillAppear(animated)
        updateNavigationBarFrame()
        addDeviceDirectionListener()
        addNavigationBarFrameListener()
    }
    
    @objc func yx_viewWillDisappear(_ animated: Bool) {
        yx_viewWillDisappear(animated)
        removeNavigationBarFrameListener()
    }
    
    @objc func yx_viewDidLayoutSubviews() {
        yx_viewDidLayoutSubviews()
        if let navigationBar = __yx_navigationBar {
            view.bringSubviewToFront(navigationBar)
        }
    }
    
}


//MARK: - Extension Methods
extension UIViewController {
    
    func configureNavigationBar() {
        
        guard let _ = navigationController, !yx_disableNavigationBar else { return }
        if let _ = __yx_navigationBar { return }

        var navbarHeight: CGFloat = self.statusAndNavigationBarHeight
        if navigationController!.modalPresentationStyle == .pageSheet {
            navbarHeight = navigationController!.navigationBar.bounds.size.height
        }
        
        __yx_navigationBar = YXNavigationBar(frame: CGRect(x: 0, y: yx_navigationBarOffset, width: view.bounds.size.width, height: navbarHeight))
        view.addSubview(__yx_navigationBar!)
    }
    
    
    @objc private func deviceDirectionChanaged(notification: Notification) {
        guard let navigationController = navigationController, let navigationBar = __yx_navigationBar else { return }
        var frame = navigationBar.frame
        /// 在 ipad 下 通过 navigationController.navigationBar.bounds.size 得到的 size 不正确所以需这么获取
        let height = navigationController.navigationBar.bounds.size.height + YXConstant.statusBarHeight
        var width: CGFloat = 0
        if YXConstant.deviceIsIpad {
            
            if !YXConstant.deviceOrientationIsVertical && !YXConstant.deviceOrientationIsHorizontal { return }
            
            if (YXConstant.deviceOrientationIsVertical) {
                width = UIScreen.main.bounds.size.width
            } else if (YXConstant.deviceOrientationIsHorizontal) {
                width = UIScreen.main.bounds.size.height
            }
        } else {
            width = UIScreen.main.bounds.size.width
        }
        let size = CGSize(width: width, height: height)
        frame.size = size
        frame.origin.y = yx_navigationBarOffset
        navigationBar.frame = frame
    }
   
    private func updateNavigationBarFrame() {
        if #available(iOS 11, *) {
            guard let navigationController = navigationController, let navigationBar = __yx_navigationBar, !yx_disableNavigationBar else {  return }
            if navigationController.navigationBar.prefersLargeTitles {
                var frame = navigationBar.frame
                frame.origin.y = yx_navigationBarOffset
                frame.size.height = (navigationController.modalPresentationStyle == .pageSheet) ? navigationBarHeight : statusAndNavigationBarHeight
                navigationBar.frame = frame
            }
        }
    }
}

//MARK: - Add Listener
extension UIViewController {
    
    private struct YXObserverContext {
        static var scrollViewContentOffset: UInt8 = 0
        static var navigationbarBounds:     UInt8 = 0
    }
    
    /// 设备旋转处理 navigationBar
    private func addDeviceDirectionListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDirectionChanaged(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeDeviceDirectionListener() {
        if let _ = __yx_navigationBar {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        }
    }
    
    private func addNavigationBarFrameListener() {
        if #available(iOS 11, *) {
            guard let navigationController = navigationController, let _ = __yx_navigationBar, !yx_disableNavigationBar else { return }
            navigationController.navigationBar.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: &YXObserverContext.navigationbarBounds)
        }
        
        if self is UITableViewController {
            let tableViewConroller = self as! UITableViewController
            tableViewConroller.tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &YXObserverContext.scrollViewContentOffset)
        }
    }
    
    private func removeNavigationBarFrameListener() {
        if #available(iOS 11, *) {
            guard let navigationController = navigationController, let _ = __yx_navigationBar, !yx_disableNavigationBar else { return }
            navigationController.navigationBar.layer.removeObserver(self, forKeyPath: "bounds")
        }
        if self is UITableViewController, yx_fixedNavigationBarPosition {
             let tableViewConroller = self as! UITableViewController
             tableViewConroller.tableView.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let unwrapContext = context else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if unwrapContext == &YXObserverContext.navigationbarBounds {
            updateNavigationBarFrame()
            
        } else if unwrapContext == &YXObserverContext.scrollViewContentOffset {
            
            let value = change![NSKeyValueChangeKey.newKey] as! CGPoint
            var frame = __yx_navigationBar!.frame
            frame.origin.y = value.y
            __yx_navigationBar?.frame = frame
        }
    }

}
