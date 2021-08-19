//
//  AppInfo.swift
//  xinan
//
//  Created by Yanping Chen on 07/07/2017.
//  Copyright © 2017 weiyankeji. All rights reserved.
//

import Foundation

public struct AppInfo {
    
    ///bundle id
    public static var identifier: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
    
    ///build号
    public static var buildNo: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    ///版本号
    public static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    ///应用名称
    public static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    
    ///是否是App Store版本，测试:com.weiyankeji.xx.pgy
    public static var isAppstoreVersion: Bool {
        return AppInfo.identifier == "com.xinan.leftandRight1"
    }
}
