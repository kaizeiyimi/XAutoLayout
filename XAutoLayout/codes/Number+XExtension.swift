//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

extension Int: AttributeContainer {}
extension Int8: AttributeContainer {}
extension Int16: AttributeContainer {}
extension Int32: AttributeContainer {}
extension Int64: AttributeContainer {}

extension UInt: AttributeContainer {}
extension UInt8: AttributeContainer {}
extension UInt16: AttributeContainer {}
extension UInt32: AttributeContainer {}
extension UInt64: AttributeContainer {}

extension Float: AttributeContainer {}
extension CGFloat: AttributeContainer {}
extension Double: AttributeContainer {}

extension SignedNumberType {
    public func generateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}

extension UnsignedIntegerType {
    public func generateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}
