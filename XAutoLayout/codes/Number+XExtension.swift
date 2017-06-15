//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit


extension Int: XRightItem {}
extension Int8: XRightItem {}
extension Int16: XRightItem {}
extension Int32: XRightItem {}
extension Int64: XRightItem {}

extension UInt: XRightItem {}
extension UInt8: XRightItem {}
extension UInt16: XRightItem {}
extension UInt32: XRightItem {}
extension UInt64: XRightItem {}

extension Float: XRightItem {}
extension CGFloat: XRightItem {}
extension Double: XRightItem {}

extension XRightItem where Self: SignedNumber {
    public func xGenerateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .notAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}

extension XRightItem where Self: UnsignedInteger {
    public func xGenerateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .notAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
    }
}
