## XAutoLayout

uses some swift amazing feature, provides a very short and clear way to make constraints in code.  

### XCode 8 and above

since swift 3 is reqiured, you need XCode 8 and above.
if you seek swift 2.3 version, use 1.3.0 instead.


### Latest version

current latest version is **1.2.0**.

### Quick look

you must know what 'left.attr = right.attr * m + c' means for AutoLayout.

```swift

import XAutoLayout

// use `=/`` to make composite equal witch creates an array of NSLayoutConstraint
NSLayoutConstraint.activateConstraints( v1.xEdge =/ [10,5,-10,-20] )

// use 'xmakeConstraints' to make constraints. constraints can be adjusted by 'direction'
// direction is default to 'LeadingToTrailing' and autoActive is default to 'true' 
xmakeConstraints(.RightToLeft, autoActive: true) {
    v2.xSize =/ [50, view.xHeight.xc(-80)]
    // since the direction is 'RightToLeft', the "v2.xLeading =/ 10" will be adjusted as "v2.xRight =/ -10"
    [v2.xTop, v2.xLeading] =/ [20, 10.xp(750)]
    // notice that in 'v2.xLeading =/ 10' the right var is a number 10, 
    // since no view is specified, superview of v2 will be used as second item, and secondAttr is same as firstAttr.
    // so the result is same as "v2.xLeading =/ v2.superview.xLeading.c(10)"
}

// and you should know "v.xHeight =/ 20" will not use superview, because height and width are dimension not anchor.

// we can also adjust constraint's constaint, multiplier and priority
v.xWidth =/ view.xWidth.xm(2).xc(-20).xp(750)

```

It's easy to read and write. isn't it?

### support your type
1. first item
you need to confirm to `XFirstItem` protocol and implement `xGenerate`.
```swift
func xGenerate() -> XAttribute {
	return XAttribute(item: yourItem, attr: yourAttr)
}
```
`yourItem` and `yourAttr` are the item and attr which will be constraint's firstItem and firstAttr.


2. second item
look at the SignedNumberType's and UnsignedIntegerType's implementation.
```swift
public func xGenerateX() -> XAttributeX {
    return XAttributeX(item: nil, attr: .NotAnAttribute, constant: CGFloat(("\(self)" as NSString).doubleValue))
}
```
item and attr will be constraint's secondItem and secondAttr. 
you can provide constant, multiplier and priority if you need. but you must know what you are doing.

### What's *the matter* of AutoLayout ?

The API is not friendly for developers. Too long and too complicated. wish XAutoLayout will make our lives easier.
