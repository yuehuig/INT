//
//  DescriptionProtocol.swift
//  xinan
//
//  Created by 郭月辉 on 2017/8/1.
//  Copyright © 2017年 weiyankeji. All rights reserved.
//

//import ObjectMapper

protocol DescriptionProtocol: CustomStringConvertible {

}

extension DescriptionProtocol {
    var description: String {
        return "\(type(of: self))"
    }
}

//extension DescriptionProtocol where Self: Mappable {
//    var description: String {
//        return "\(type(of: self))" + (toJSONString(prettyPrint: true) ?? "")
//    }
//}

