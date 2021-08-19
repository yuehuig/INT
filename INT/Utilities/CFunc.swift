//
//  CFunc.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit

func vcCls(with name: String, hasController: Bool = true, isOC: Bool = false) -> UIViewController.Type? {
    var cls = NSClassFromString(name + (hasController ? "Controller" : "")) as? UIViewController.Type
    if (isOC == false) {
        cls = NSClassFromString(Bundle.main.nameSpace + "." + name + (hasController ? "Controller" : "")) as? UIViewController.Type;
    }
    return cls
}
