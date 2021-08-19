//
//  Style.swift
//  xinan
//
//  Created by 郭月辉 on 2017/7/24.
//  Copyright © 2017年 weiyankeji. All rights reserved.
//

import UIKit

// MARK: - ///////////////////颜色
/// 主色 品牌颜色、核心色
let kCMColor: UIColor = UIColor.colorWithHex(hex: "#FD6A2B")

// MARK: - ///////////////辅助色/////////////////
/// 警告、重要、风险色
let kCRColor: UIColor = UIColor.colorWithHex(hex: "#FF614C")
/// 弱警示 用于普通提示相对重要信息或等待
let kCYColor: UIColor = UIColor.colorWithHex(hex: "#FAAC3E")
/// 成功色
let kCGColor: UIColor = UIColor.colorWithHex(hex: "#1DBF60")
///分割线
let kSepColor: UIColor = UIColor.colorWithHex(hex: "#E4E7F0")

// MARK: - ///////////////灰色系/////////////////
/// C1标题---标题文字以及重点突出文字
let kC1Color: UIColor = UIColor.colorWithHex(hex: "#121C33")
/// 常用正文---常态黑色文字、正文
let kC2Color: UIColor = UIColor.colorWithHex(hex: "#3D4966")
/// C3辅助---用于副标题或辅助信息的文字
let kC3Color: UIColor = UIColor.colorWithHex(hex: "#7A8499")
/// C4置灰---disable不可用状态
let kC4Color: UIColor = UIColor.colorWithHex(hex: "#B8BECC")
/// C5 line---line、描边和分界线
let kC5Color: UIColor = UIColor.colorWithHex(hex: "#EBECF0")
/// C6背景色---background 背景灰色
let kC6Color: UIColor = UIColor.colorWithHex(hex: "#F2F4F7")
/// C7白色---白色文字 FFFFFF
let kC7Color: UIColor = UIColor.colorWithHex(hex: "#FFFFFF")

// MARK: - ///////////////////字号
/// h1 超大文字或数字
let kH1FontSize: CGFloat = 30
/// h2 大字号，用于内容模块标题
let kH2FontSize: CGFloat = 24
/// h3 导航栏标题
let kH3FontSize: CGFloat = 18
/// h4 文字小标题
let kH4FontSize: CGFloat = 16
/// h5 正文、常用文字
let kH5FontSize: CGFloat = 14
/// h6 辅助文字信息
let kH6FontSize: CGFloat = 12
/// h7 最小文字
let kH7FontSize: CGFloat = 10

// MARK: - ///////////////////字体
/// h1 超大文字或数字
let kH1Font = UIFont.systemFont(ofSize: kH1FontSize)
/// h2 大字号，用于内容模块标题
let kH2Font = UIFont.systemFont(ofSize: kH2FontSize)
/// h3 导航栏标题
let kH3Font = UIFont.systemFont(ofSize: kH3FontSize)
/// h4 文字小标题
let kH4Font = UIFont.systemFont(ofSize: kH4FontSize)
/// h5 标题/正文 14
let kH5Font = UIFont.systemFont(ofSize: kH5FontSize)
/// h6 辅助文字信息
let kH6Font = UIFont.systemFont(ofSize: kH6FontSize)
/// h7 最小文字
let kH7Font = UIFont.systemFont(ofSize: kH7FontSize)

////////////////////////////////////////////

/// 系统后台运行时间
let kBackgroundRunTime: TimeInterval = 60

// MARK: - ///////////////////尺寸
let kDeviceScale = UIScreen.main.scale
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
let kStatusNavBarHeight: CGFloat = kStatusBarHeight + kNavBarHeight
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
let kNavBarHeight: CGFloat = 44
//let kTabBarHeight: CGFloat = UIDevice.current.isX() ? 83 : 49
let kScaleLineHeight: CGFloat = 1.0 / kDeviceScale
/// iPhone6屏幕为基准
/// 高度比例
let kScreenHeightScale: CGFloat = kScreenWidth / 375.0

