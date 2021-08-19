//
//  BaseViewController.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit
import SwifterSwift
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension BaseViewController {
    @objc open func setupUI() {
        view.backgroundColor = .white
        setupTitle()
    }
    
    private func setupTitle() {
        guard let str = NSStringFromClass(Self.self).split(separator: ".").last else {
            return
        }
        var vcName = String(str)
        if (vcName.hasSuffix("Controller")) {
            vcName = vcName.replacingOccurrences(of: "Controller", with: "")
        }
        title = vcName
    }
}
