//
//  YHNavgationController.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit

class YHNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        /// 接管导航控制器的边缘侧滑返回交互手势代理
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension YHNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    /// 允许同时响应多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    /// 避免响应边缘侧滑返回手势时，当前控制器中的ScrollView跟着滑动
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
    }
}

// MARK: - UI
extension YHNavigationController {
    private func setupAppearance() {
        let appearance = UINavigationBar.appearance()
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: kH4FontSize),
            NSAttributedString.Key.foregroundColor: kC1Color
        ]
        appearance.titleTextAttributes = attributes
//        navigationBar.yhBackgroundColor = kCMColor
        appearance.shadowImage = UIImage()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
