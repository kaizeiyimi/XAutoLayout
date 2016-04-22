//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

extension Int: XAttributeContainer {}
extension Int8: XAttributeContainer {}
extension Int16: XAttributeContainer {}
extension Int32: XAttributeContainer {}
extension Int64: XAttributeContainer {}

extension UInt: XAttributeContainer {}
extension UInt8: XAttributeContainer {}
extension UInt16: XAttributeContainer {}
extension UInt32: XAttributeContainer {}
extension UInt64: XAttributeContainer {}

extension Float: XAttributeContainer {}
extension CGFloat: XAttributeContainer {}
extension Double: XAttributeContainer {}

extension SignedNumberType {
    public func xGenerateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}

extension UnsignedIntegerType {
    public func xGenerateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}
