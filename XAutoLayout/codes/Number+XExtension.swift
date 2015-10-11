
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
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(any: self))
    }
}

extension UnsignedIntegerType {
    public func generateX() -> XAttributeX {
        return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(any: self))
    }
}

extension CGFloat {
    private init(any value: Any) {
        switch value {
        case let v as Int: self = CGFloat(v)
        case let v as Int8: self = CGFloat(v)
        case let v as Int16: self = CGFloat(v)
        case let v as Int32: self = CGFloat(v)
        case let v as Int64: self = CGFloat(v)
            
        case let v as UInt: self = CGFloat(v)
        case let v as UInt8: self = CGFloat(v)
        case let v as UInt16: self = CGFloat(v)
        case let v as UInt32: self = CGFloat(v)
        case let v as UInt64: self = CGFloat(v)
            
        case let v as Float: self = CGFloat(v)
        case let v as CGFloat: self = v
        case let v as Double: self = CGFloat(v)
        default:
            fatalError("'value' is not convertable to 'CGFloat'")
        }
    }
}
