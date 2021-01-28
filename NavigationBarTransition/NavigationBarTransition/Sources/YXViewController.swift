//
//  BaseViewController.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/21.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class YXViewController: UIViewController {

    /// 如果为 true 则禁用导航栏，false 则启用导航栏，默认为  false, 如果需要禁用导航栏，应该在子类 `viewDidLoad()` 中 `super.viewDidLoad()` 之前设置一次
    ///
    ///     override func viewDidLoad() {
    ///         disableNavigationBar = true
    ///         super.viewDidLoad()
    ///     }
    ///
    ///
    public var disableNavigationBar: Bool = false
    
    private(set) var yx_navigationBar: YXNavigationBar?
    

    override func viewDidLoad() {
        super.viewDidLoad()

       //  Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        configureNavigationBar()
    }

    func configureNavigationBar() {

        guard let _ = navigationController, !disableNavigationBar else { return }
        if let _ = yx_navigationBar { return }

        var navbarHeight: CGFloat = self.statusAndNavigationBarHeight
        if isModalPageSheet {
            navbarHeight = navigationController!.navigationBar.bounds.size.height
        }

        yx_navigationBar = YXNavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: navbarHeight))
        view.addSubview(yx_navigationBar!)
        addDeviceDirectionListener()
    }

    deinit {
        if let _ = yx_navigationBar {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        }
    }
    
}

//MARK: - Override Methods
extension YXViewController {

    /// 子类不要直接重写改方法 `viewDidLayoutSubviews()`, 如果需要可以重写 `yx_viewDidLayoutSubViews()`
     override func viewDidLayoutSubviews() {
         if let navigationBar = yx_navigationBar {
             view.bringSubviewToFront(navigationBar)
         }
         yx_viewDidLayoutSubViews()
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         updateNavigationBarFrame()
         addNavigationBarFrameListener()
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         removeNavigationBarFrameListener()
     }
}

//MARK: - Publish & Private  Methods
extension YXViewController {
    
    /// 子类如果在布局完成后需要执行某些操作，应该重写改方法
    @objc public func yx_viewDidLayoutSubViews() { }
    
    
    @objc private func deviceDirectionChanaged(notification: Notification) {
        guard let _ = navigationController else { return }
        var frame = yx_navigationBar!.frame
        /// 在 ipad 下 通过 navigationController.navigationBar.bounds.size 得到的 size 不正确所以需这么获取
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

        let height = isModalPageSheet ? navigationBarHeight : statusAndNavigationBarHeight
        
        let size = CGSize(width: width, height: height)
        frame.size = size
        yx_navigationBar?.frame = frame
        
        updateNavigationBarFrame()
    }
   
    private func updateNavigationBarFrame() {
        
        guard let navigationController = navigationController, let navigationBar = yx_navigationBar, !disableNavigationBar else {  return }
        
        var frame = navigationBar.frame
        
        if #available(iOS 11, *) {
            if navigationController.navigationBar.prefersLargeTitles {
                frame.size.height = (navigationController.modalPresentationStyle == .pageSheet) ? navigationBarHeight : statusAndNavigationBarHeight
                navigationBar.frame = frame
            }
        }
        
        if !edgesForExtendedLayout.contains(.top) {
            frame.origin.y = -statusAndNavigationBarHeight
            navigationBar.frame = frame
        }
    }
}

extension YXViewController {
    private var isModalPageSheet: Bool {
        return (navigationController!.modalPresentationStyle == .pageSheet && navigationController!.viewControllers.contains(self))
    }
    
}

//MARK: - Add Listener
extension YXViewController {
    
    private struct YXObserverContext {
        static var navigationbarBounds:     UInt8 = 0
    }
    
    /// 设备旋转处理 navigationBar
    private func addDeviceDirectionListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDirectionChanaged(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func addNavigationBarFrameListener() {
        if #available(iOS 11, *) {
            guard let navigationController = navigationController, let _ = yx_navigationBar, !disableNavigationBar else { return }
            navigationController.navigationBar.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: &YXObserverContext.navigationbarBounds)
        }
    }
    
    private func removeNavigationBarFrameListener() {
        if #available(iOS 11, *) {
            guard let navigationController = navigationController, let _ = yx_navigationBar, !disableNavigationBar else { return }
            navigationController.navigationBar.layer.removeObserver(self, forKeyPath: "bounds", context: &YXObserverContext.navigationbarBounds)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let context = context, context == &YXObserverContext.navigationbarBounds {
            updateNavigationBarFrame()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
