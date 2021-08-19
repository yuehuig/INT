//
//  Logging.swift
//  xinan
//
//  Created by 郭月辉 on 2017/8/8.
//  Copyright © 2017年 weiyankeji. All rights reserved.
//

import Foundation

/// 配置Log
///
/// - Parameters:
///   - message: Log信息
///   - file: 输出Log信息所在文件
///   - funcName: 函数名
///   - lineNum: Log所在行
func printLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName: String = (file as NSString).lastPathComponent
        print("***********Log************\n🐶🐶【\(fileName)：\(lineNum)】->>   \(message)")
    #endif
}
