//
//  XAutoLayout
//
//  Created by kaizei on 15/10/11.
//  Copyright © 2015年 kaizeiyimi. All rights reserved.
//


import UIKit

public protocol AnchorExtending {
    func makeExtendedAnchor() -> ExtendedAnchor
}

public protocol Anchor: AnchorExtending {
    associatedtype AnchorType: AnyObject
}

public protocol NSAnchor: Anchor {}

public protocol XAxisAnchor: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedXAxisAnchor
    func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor
    
    @available(iOS 11, *)
    func useSystemSpace(m: CGFloat) -> ExtendedXAxisAnchor
}

public protocol YAxisAnchor: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedYAxisAnchor
    func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor
    
    @available(iOS 11, *)
    func useSystemSpace(m: CGFloat) -> ExtendedYAxisAnchor
}

public protocol Dimension: AnchorExtending {
    func c(_ constant: CGFloat) -> ExtendedDimension
    func p(_ priority: UILayoutPriority) -> ExtendedDimension
    func m(_ multiplier: CGFloat) -> ExtendedDimension
}

// MARK: - ExtendedAnchor

public class ExtendedAnchor {
    let anchor: Any?   // tradeoff.
    
    let constant: CGFloat
    let multiplier: CGFloat
    let priority: UILayoutPriority
    
    let useSystemSpace: Bool
    
    #if swift(>=4.0)
    init(_ anchor: Any?, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = .required, useSystemSpace: Bool = false) {
        self.anchor = anchor
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
        self.useSystemSpace = useSystemSpace
    }
    #else
    init(_ anchor: Any?, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityRequired, useSystemSpace: Bool = false) {
        self.anchor = anchor
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
        self.useSystemSpace = useSystemSpace
    }
    #endif
    
    convenience init(extending other: ExtendedAnchor, constant: CGFloat? = nil, multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil, useSystemSpace: Bool? = nil) {
        self.init(other.anchor,
                  constant: constant ?? other.constant,
                  multiplier: multiplier ?? other.multiplier,
                  priority: priority ?? other.priority,
                  useSystemSpace: useSystemSpace ?? other.useSystemSpace)
    }
}

extension ExtendedAnchor: AnchorExtending {
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return self
    }
}


// MARK: - XAxis

public final class ExtendedXAxisAnchor: ExtendedAnchor, Anchor, XAxisAnchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    
    public func c(_ constant: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, priority: priority)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, priority: UILayoutPriority(priority))
    }
    #endif
    
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(extending: self, multiplier: m, useSystemSpace: true)
    }
}

extension NSLayoutXAxisAnchor: NSAnchor, XAxisAnchor {
    public typealias AnchorType = NSLayoutXAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, priority: priority)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, priority: UILayoutPriority(priority))
    }
    #endif
    
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> ExtendedXAxisAnchor {
        return ExtendedXAxisAnchor(self, multiplier: m, useSystemSpace: true)
    }
}

// MARK: - YAxis

public final class ExtendedYAxisAnchor: ExtendedAnchor, Anchor, YAxisAnchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    
    public func c(_ constant: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, priority: priority)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, priority: UILayoutPriority(priority))
    }
    #endif
    
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(extending: self, multiplier: m, useSystemSpace: true)
    }
}

extension NSLayoutYAxisAnchor: NSAnchor, YAxisAnchor {
    public typealias AnchorType = NSLayoutYAxisAnchor
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, priority: priority)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, priority: UILayoutPriority(priority))
    }
    #endif
    
    @available(iOS 11, *)
    public func useSystemSpace(m: CGFloat) -> ExtendedYAxisAnchor {
        return ExtendedYAxisAnchor(self, multiplier: m, useSystemSpace: true)
    }
}

// MARK: - Dimension

public final class ExtendedDimension: ExtendedAnchor, Anchor, Dimension {
    public typealias AnchorType = NSLayoutDimension
    
    public func c(_ constant: CGFloat) -> ExtendedDimension {
        return ExtendedDimension(extending: self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
        return ExtendedDimension(extending: self, priority: priority)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedDimension {
        return ExtendedDimension(extending: self, multiplier: multiplier)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedDimension {
        return ExtendedDimension(extending: self, priority: UILayoutPriority(priority))
    }
    #endif
}

extension NSLayoutDimension: NSAnchor, Dimension {
    public typealias AnchorType = NSLayoutDimension
    
    public func makeExtendedAnchor() -> ExtendedAnchor {
        return ExtendedAnchor(self)
    }
    
    public func c(_ constant: CGFloat) -> ExtendedDimension {
        return ExtendedDimension(self, constant: constant)
    }
    
    public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
        return ExtendedDimension(self, priority: priority)
    }
    
    public func m(_ multiplier: CGFloat) -> ExtendedDimension {
        return ExtendedDimension(self, multiplier: multiplier)
    }
    
    #if swift(>=4.0)
    public func p(_ priority: Float) -> ExtendedDimension {
        return ExtendedDimension(self, priority: UILayoutPriority(priority))
    }
    #endif
}


#if swift(>=4.0)
    extension Int: Anchor, Dimension {}
    extension Int8: Anchor, Dimension {}
    extension Int16: Anchor, Dimension {}
    extension Int32: Anchor, Dimension {}
    extension Int64: Anchor, Dimension {}
    
    extension UInt: Anchor, Dimension {}
    extension UInt8: Anchor, Dimension {}
    extension UInt16: Anchor, Dimension {}
    extension UInt32: Anchor, Dimension {}
    extension UInt64: Anchor, Dimension {}
    
    extension Float: Anchor, Dimension {}
    extension CGFloat: Anchor, Dimension {}
    extension Double: Anchor, Dimension {}
    
    extension Numeric {
        public typealias AnchorType = NSLayoutDimension
    
        public func makeExtendedAnchor() -> ExtendedAnchor {
            return ExtendedAnchor(nil, constant: self.cgFloatValue)
        }
    
        public func c(_ constant: CGFloat) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: constant)
        }
    
        public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: self.cgFloatValue, priority: priority)
        }
    
        public func m(_ multiplier: CGFloat) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: self.cgFloatValue, multiplier: multiplier)
        }
    
        private var cgFloatValue: CGFloat {
            return CGFloat(("\(self)" as NSString).doubleValue)
        }
    
        public func p(_ priority: Float) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: self.cgFloatValue, priority: UILayoutPriority(priority))
        }
    }
#else
    extension Int: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension Int8: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension Int16: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension Int32: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension Int64: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    
    extension UInt: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension UInt8: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension UInt16: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension UInt32: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension UInt64: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    
    extension Float: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension CGFloat: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    extension Double: Anchor, Dimension {
        public typealias AnchorType = NSLayoutDimension
    }
    
    extension UnsignedInteger {
        public func makeExtendedAnchor() -> ExtendedAnchor {
            return ExtendedAnchor(nil, constant: self.cgFloatValue)
        }
        
        public func c(_ constant: CGFloat) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: constant)
        }
        
        public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: self.cgFloatValue, priority: priority)
        }
        
        public func m(_ multiplier: CGFloat) -> ExtendedDimension {
            return ExtendedDimension(nil, constant: self.cgFloatValue, multiplier: multiplier)
        }
        
        private var cgFloatValue: CGFloat {
            return CGFloat(("\(self)" as NSString).doubleValue)
        }
    }
    #if swift(>=3.2)
        extension SignedNumeric {
            public func makeExtendedAnchor() -> ExtendedAnchor {
                return ExtendedAnchor(nil, constant: self.cgFloatValue)
            }
            
            public func c(_ constant: CGFloat) -> ExtendedDimension {
                return ExtendedDimension(nil, constant: constant)
            }
            
            public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
                return ExtendedDimension(nil, constant: self.cgFloatValue, priority: priority)
            }
            
            public func m(_ multiplier: CGFloat) -> ExtendedDimension {
                return ExtendedDimension(nil, constant: self.cgFloatValue, multiplier: multiplier)
            }
            
            private var cgFloatValue: CGFloat {
                return CGFloat(("\(self)" as NSString).doubleValue)
            }
        }
    #else
            extension SignedNumber {
                public func makeExtendedAnchor() -> ExtendedAnchor {
                    return ExtendedAnchor(nil, constant: self.cgFloatValue)
                }
        
                public func c(_ constant: CGFloat) -> ExtendedDimension {
                    return ExtendedDimension(nil, constant: constant)
                }
        
                public func p(_ priority: UILayoutPriority) -> ExtendedDimension {
                    return ExtendedDimension(nil, constant: self.cgFloatValue, priority: priority)
                }
        
                public func m(_ multiplier: CGFloat) -> ExtendedDimension {
                    return ExtendedDimension(nil, constant: self.cgFloatValue, multiplier: multiplier)
                }
        
                private var cgFloatValue: CGFloat {
                    return CGFloat(("\(self)" as NSString).doubleValue)
                }
        }
    #endif
#endif
