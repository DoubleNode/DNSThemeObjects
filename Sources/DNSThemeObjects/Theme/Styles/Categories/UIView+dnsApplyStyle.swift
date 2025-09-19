//
//  UIView+dnsApplyStyle.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSThemeTypes
import SkeletonView
import UIKit

public extension UIView {
    func dnsApply(_ style: DNSThemeViewStyle) {
        self.dnsApply(style as DNSThemeStyle)
        // DNSThemeViewStyle
    }
    func dnsApply(_ style: DNSThemeStyle) {
        // DNSThemeStyle
        self.backgroundColor = style.backgroundColor.normal
        self.layer.borderColor = style.border.color.normal.cgColor
        self.layer.borderWidth = CGFloat(style.border.width)
        self.layer.cornerRadius = CGFloat(style.border.cornerRadius)
        self.layer.shadowColor = style.shadow.color.normal.cgColor
        self.layer.shadowOffset = style.shadow.offset
        self.layer.shadowOpacity = style.shadow.opacity
        self.layer.shadowRadius = style.shadow.radius
        self.isSkeletonable = style.skeletonable.normal
        self.tintColor = style.tintColor.normal
        // DNSThemeViewStyle
    }
}
