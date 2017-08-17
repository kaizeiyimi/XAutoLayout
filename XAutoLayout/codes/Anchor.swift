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
        self.constant = constant
        return self
    }
    
    public func p(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> Self {
        self.priority = UILayoutPriority(rawValue: priority)
        return self
    }
    #endif
    
    #if swift(>=3.2)
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> Self {
        (self.multiplier, self.useSystemSpace) = (m, true)
        return self
    }
    #endif
}

extension NSLayoutDimension {
    public func m(_ multiplier: CGFloat) -> Self {
        self.multiplier = multiplier
        return self
    }
}

public final class Num: NSLayoutDimension {
    
    let value: CGFloat
    
    #if swift(>=3.2)
    public init<T>(_ number: T) where T: Numeric {
        value = CGFloat(("\(number)" as NSString).doubleValue)
        super.init()
    }
    #else
    public init<T>(_ number: T) where T: SignedNumber {
    value = CGFloat(("\(number)" as NSString).doubleValue)
    super.init()
    }
    
    public init<T>(_ number: T) where T: UnsignedInteger {
    value = CGFloat(("\(number)" as NSString).doubleValue)
    super.init()
    }
    #endif
}

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
    public var __associatedDict__: [String: Any] {
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
        get {
            #if swift(>=4.0)
                return __associatedDict__["priority"] as? UILayoutPriority ?? .required
            #else
                return __associatedDict__["priority"] as? UILayoutPriority ?? UILayoutPriorityRequired
            #endif
        }
        set { __associatedDict__["priority"] = newValue }
    }
    
    var useSystemSpace: Bool {
        get { return __associatedDict__["useSystemSpace"] as? Bool ?? false }
        set { __associatedDict__["useSystemSpace"] = newValue }
    }
}
