//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

/**
 cannot extension NSLayoutAnchor in swift4 with normal func.
 WTF: "Extension of a generic Objective-C class cannot access the class's generic parameters at runtime".
 
 guard the Anchor protocol to be used only in this framework.
 */


/// just a guard to protect Anchor protocol.
public final class __Placeholder__ {}

// MARK: - Anchor
public protocol Anchor: class {
    associatedtype AnchorType: AnyObject
    func __placeholder__() -> __Placeholder__
}

// MARK: - NSLayoutAnchor extension workaround
extension Anchor where Self: NSObject {
    public func c(_ constant: CGFloat) -> Self {
        let anchor = makeAnchorContainer()
        anchor.constant = constant
        return anchor
    }
    
    public func p(_ priority: UILayoutPriority) -> Self {
        let anchor = makeAnchorContainer()
        anchor.priority = priority
        return anchor
    }

    public func p(_ priority: Float) -> Self {
        let anchor = makeAnchorContainer()
        anchor.priority = UILayoutPriority(priority)
        return anchor
    }
    
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> Self {
        let anchor = makeAnchorContainer()
        (anchor.multiplier, anchor.useSystemSpace) = (m, true)
        return anchor
    }
    
    fileprivate func makeAnchorContainer() -> Self {
        if let _ = origin {
            return self
        } else {
            let anchor: Self = {
                switch self {
                case is NSLayoutXAxisAnchor: return UIView().leadingAnchor as! Self
                case is NSLayoutYAxisAnchor: return UIView().topAnchor as! Self
                case is NSLayoutDimension: return UIView().widthAnchor as! Self
                    
                default:
                    fatalError("maybe new anchor class?")
                }
            }()
            anchor.origin = self
            return anchor
        }
    }
}

extension NSLayoutDimension {
    public func m(_ multiplier: CGFloat) -> Self {
        let anchor = makeAnchorContainer()
        anchor.multiplier = multiplier
        return anchor
    }
}

// NOTICE: iOS9 says '[NSLayoutAnchor init] doesn't work yet.'
// so to support iOS9 I have to do so...

public func Num<T>(_ number: T) -> NSLayoutDimension where T: Numeric {
    let anchor = UIView().widthAnchor
    anchor.isNumDimension = true
    anchor.constant = CGFloat(("\(number)" as NSString).doubleValue)
    return anchor
}

// NOTICE: when iOS9 can be dropped, will switch to these impl.

//public final class Num: NSLayoutDimension {
//    #if swift(>=3.2)
//    public init<T>(_ number: T) where T: Numeric {
//        super.init()
//        constant = CGFloat(("\(number)" as NSString).doubleValue)
//    }
//    #else
//    public init<T>(_ number: T) where T: SignedNumber {
//        super.init()
//        constant = CGFloat(("\(number)" as NSString).doubleValue)
//    }
//
//    public init<T>(_ number: T) where T: UnsignedInteger {
//        super.init()
//        constant = CGFloat(("\(number)" as NSString).doubleValue)
//    }
//    #endif
//}

extension NSLayoutXAxisAnchor: Anchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    public func __placeholder__() -> __Placeholder__ { return __Placeholder__() }
}

extension NSLayoutYAxisAnchor: Anchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    public func __placeholder__() -> __Placeholder__ { return __Placeholder__() }
}

extension NSLayoutDimension: Anchor {
    public typealias AnchorType = NSLayoutDimension
    public func __placeholder__() -> __Placeholder__ { return __Placeholder__() }
}

extension NSObject {
    private static var dictKey = "XAutoLayout.NSObject.AssociatedDict.Key"
    var __associatedDict__: [String: Any] {
        get {
            if let dict = objc_getAssociatedObject(self, &NSObject.dictKey) as? [String: Any] {
                return dict
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &NSObject.dictKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var constant: CGFloat {
        get { return __associatedDict__["constant"] as? CGFloat ?? 0 }
        set { __associatedDict__["constant"] = newValue }
    }
    
    var multiplier: CGFloat {
        get { return __associatedDict__["multiplier"] as? CGFloat ?? 1 }
        set { __associatedDict__["multiplier"] = newValue }
    }
    
    var priority: UILayoutPriority {
        get { return __associatedDict__["priority"] as? UILayoutPriority ?? .required }
        set { __associatedDict__["priority"] = newValue }
    }
    
    var useSystemSpace: Bool {
        get { return __associatedDict__["useSystemSpace"] as? Bool ?? false }
        set { __associatedDict__["useSystemSpace"] = newValue }
    }
    
    //
    var origin: Any? {
        get { return __associatedDict__["origin"] }
        set { __associatedDict__["origin"] = newValue }
    }
    
    
    var isNumDimension: Bool {
        get { return __associatedDict__["isNumDimension"] as? Bool ?? false }
        set { __associatedDict__["isNumDimension"] = newValue }
    }
}

