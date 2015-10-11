## XAutoLayout ##

uses some swift 2 amazing feature, provides a very short and clear way to make constraints in code.  

### XCode 7 and above ###

since swift 2 is reqiured, you need XCode 7 and above.

### Latest version ###

current latest version is **1.0.0**.

### Quick look ###

you must know what 'left.attr = right.attr * m + c' means for AutoLayout.

```swift

import XAutoLayout

// use =/ to make composite equal witch creates an array of NSLayoutConstraint
NSLayoutConstraint.activateConstraints( v1.xEdge =/ [10,5,-10,-20] )

// use 'xmakeConstraints' to make constraints. constraints can be adjusted by 'direction'
// direction is default to 'LeadingToTrailing' and autoActive is default to 'true' 
xmakeConstraints(.RightToLeft, autoActive: true) {
    v2.xSize =/ [50, view.xHeight.c(-80)]
    // since the direction is 'RightToLeft', the "v2.xLeading =/ 10" will be adjusted as "v2.xRight =/ -10"
    [v2.xTop, v2.xLeading] =/ [20, 10.p(750)]
    // notice that in 'v2.xLeading =/ 10' the right var is a number 10, 
    // since no view is specified, superview of v2 will be used as second item, and secondAttr is same as firstAttr.
    // so the result is same as "v2.xLeading =/ v2.superview.xLeading.c(10)"
}

// and you should know "v.xHeight =/ 20" will not use superview, because height and width are dimension not anchor.

// we can also adjust constraint's constaint, multiplier and priority
v.xWidth =/ view.xWidth.m(2).c(-20).p(750)

```

It's easy to read and write. isn't it?

### What's *the matter* of AutoLayout ? ###

The API is not friendly for developers. Too long and too complicated. wish XAutoLayout will make our lives easier.
