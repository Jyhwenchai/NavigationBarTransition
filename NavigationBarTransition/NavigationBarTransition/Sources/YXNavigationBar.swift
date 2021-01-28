//
//  BaseNavigationBar.swift
//  NavigationBarTransition
//
//  Created by ilosic on 2019/10/21.
//  Copyright © 2019 ilosic. All rights reserved.
//

import UIKit

class YXNavigationBar: UIView {

    public var bindSeparatorAlpha = true
    
    /**
     影响 `backgroundColor` 的 `alpha`, 仅在带模糊效果的时候生效, 使在模糊状态下具有穿透效果
     */
    public var maxAlpha: CGFloat = 0.55 {
        didSet {
            maxAlpha = min(max(0, maxAlpha), 1.0)
            let color = backgroundColor
            backgroundColor = color
        }
    }
    
    public var separatorColor: UIColor = UIColor.lightGray {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    public var separatorHeight: CGFloat =  1.0 / UIScreen.main.scale {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /**
     模糊图层样式
     
     如果想要应用模糊效果该值不能为 nil。 同时如果 `backgroundColor` 的 alpha 值必须小于1.0，则会带有穿透效果。如果该值为 nil 则无模糊效果， 默认值为 nil。
     */
    public var barEffect: UIBlurEffect? {
        didSet {
            updateBlurView()
        }
    }
    
    /**
     模糊图层透明度
     
     当在模糊效果存在，同时导航栏的 `backgroundcolor` 不为 nil，那么可以通过同步修改此值及 `backgroundcolor` 为导航栏应用滑动时动态调整透明度功能（默认可以不需要手动修改此值，可通过调整 `backgroundcolor` 触发影响该值的变化），同时另一种达到同样效果的方法是直接调整导航栏的 `alpha` 值
     */
    public var blurEffectAlpha: CGFloat = 1.0 {
        didSet {
            updateBlurView()
        }
    }
    
    /**
     为导航栏体统背景图片
     
     当该值不为 nil 时，`blurView` 及时提供了模糊效果也不会生效
     */
    var backgroundImage: UIImage? {
        didSet {
            updateBarBackground()
        }
    }
    
    //MARK: - UIKit
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: nil)
        return blurView
    }()
    
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(red: 236.0 / 255, green: 236.0 / 255, blue: 236.0 / 255, alpha: 1)
        addSubview(backgroundImageView)
        addSubview(blurView)
        addSubview(separatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        blurView.frame = bounds
        separatorView.frame = CGRect(x: 0, y: self.bounds.height - separatorHeight, width: self.bounds.width, height: separatorHeight)
    }
    
    
    override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set {
            guard let color = newValue else {
                super.backgroundColor = newValue
                return
            }

            /// 如果设置了模糊效果，那么 backgroundColor 的 alpha 最大值只能为 0.92
            let alpha = min(color.rgba!.alpha / 255, maxAlpha)
            if let _ = barEffect, !blurView.isHidden {
            
                /// 调整模糊层 alpha
                blurEffectAlpha = alpha / maxAlpha
                super.backgroundColor = newValue?.withAlphaComponent(alpha)
            } else {
                super.backgroundColor = newValue
            }
            
            if bindSeparatorAlpha {
               separatorView.alpha = alpha / maxAlpha
            }
        }

    }
    
}

//MARK: Configure Bar Style
extension YXNavigationBar {
 
   /// 重置导航栏为默认样式
   public func resetToDefaultStyle() {
       backgroundColor = UIColor(red: 236.0 / 255, green: 236.0 / 255, blue: 236.0 / 255, alpha: 1)
       barEffect = nil
       blurEffectAlpha = 1
       backgroundImage = nil
       alpha = 1
   }
    
    /// 如果提供背景图片则应用它
    private func updateBarBackground() {
        backgroundImageView.image = backgroundImage
    }
    
    private func updateBlurView() {
        
        /// 如果存在背景图片则不使用 blurView
        blurView.isHidden = barEffect == nil ? true : false

        blurView.alpha = blurEffectAlpha
        blurView.effect = barEffect
        
    }
}
