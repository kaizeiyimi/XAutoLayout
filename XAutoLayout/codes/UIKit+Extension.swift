//
//  UIKit+Extension.swift
//  XAutoLayout
//
//  Created by kai wang on 2017/8/5.
//  Copyright © 2017年 kaizei.yimi. All rights reserved.
//

import UIKit


extension UIView {
    public var centerAnchors: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (centerXAnchor, centerYAnchor)
    }
    
    public var originAnchors: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (leadingAnchor, topAnchor)
    }
    
    public var originAnchorsLR: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (leftAnchor, topAnchor)
    }
    
    public var sizeAnchors: (NSLayoutDimension, NSLayoutDimension) {
        return (widthAnchor, heightAnchor)
    }
    
    public var edgeAnchors: (NSLayoutYAxisAnchor, NSLayoutXAxisAnchor, NSLayoutYAxisAnchor, NSLayoutXAxisAnchor) {
        return (topAnchor, leadingAnchor, bottomAnchor, trailingAnchor)
    }
    
    public var edgeAnchorsLR: (NSLayoutYAxisAnchor, NSLayoutXAxisAnchor, NSLayoutYAxisAnchor, NSLayoutXAxisAnchor) {
        return (topAnchor, leftAnchor, bottomAnchor, rightAnchor)
    }
}

extension UILayoutGuide {
    public var centerAnchors: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (centerXAnchor, centerYAnchor)
    }
    
    public var originAnchors: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (leadingAnchor, topAnchor)
    }
    
    public var originAnchorsLR: (NSLayoutXAxisAnchor, NSLayoutYAxisAnchor) {
        return (leftAnchor, topAnchor)
    }
    
    public var sizeAnchors: (NSLayoutDimension, NSLayoutDimension) {
        return (widthAnchor, heightAnchor)
    }
    
    public var edgeAnchors: (NSLayoutYAxisAnchor, NSLayoutXAxisAnchor, NSLayoutYAxisAnchor, NSLayoutXAxisAnchor) {
        return (topAnchor, leadingAnchor, bottomAnchor, trailingAnchor)
    }
    
    public var edgeAnchorsLR: (NSLayoutYAxisAnchor, NSLayoutXAxisAnchor, NSLayoutYAxisAnchor, NSLayoutXAxisAnchor) {
        return (topAnchor, leftAnchor, bottomAnchor, rightAnchor)
    }
}
