//
//  Bundle+YH.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import Foundation

extension Bundle {
    // 计算型属性返回
    var nameSpace: String {
       
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }

}
