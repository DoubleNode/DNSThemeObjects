//
//  UIButton+dnsApplyTheme.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSThemeTypes
import SkeletonView
import UIKit

public extension UIButton {
    func dnsApply(_ style: DNSThemeButtonStyle) {
        super.dnsApply(style as DNSThemeStyle)
        // DNSThemeButtonStyle
        if #available(iOS 15.0, *) {
            self.subtitleLabel?.textColor = style.subtitleStyle.color.normal
            self.subtitleLabel?.font = style.subtitleStyle.font.normal
            self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.normal
            self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
//            self.subtitleLabel?.strikeThru = style.subtitleStyle.strikeThru.enabled.normal
//            self.subtitleLabel?.strikeThruColor = style.subtitleStyle.strikeThru.color.normal
//            self.subtitleLabel?.strikeThruStyle = style.subtitleStyle.strikeThru.style
        }
        self.titleLabel?.font = style.titleStyle.font.normal
        self.setTitleColor(style.titleStyle.color.normal, for: UIControl.State.normal)
        self.setTitleColor(style.titleStyle.color.disabled, for: UIControl.State.disabled)
        self.setTitleColor(style.titleStyle.color.focused, for: UIControl.State.focused)
        self.setTitleColor(style.titleStyle.color.highlighted, for: UIControl.State.highlighted)
        self.setTitleColor(style.titleStyle.color.selected, for: UIControl.State.selected)
        self.setTitleShadowColor(style.titleStyle.shadow.color.normal, for: UIControl.State.normal)
        self.setTitleShadowColor(style.titleStyle.shadow.color.disabled, for: UIControl.State.disabled)
        self.setTitleShadowColor(style.titleStyle.shadow.color.focused, for: UIControl.State.focused)
        self.setTitleShadowColor(style.titleStyle.shadow.color.highlighted, for: UIControl.State.highlighted)
        self.setTitleShadowColor(style.titleStyle.shadow.color.selected, for: UIControl.State.selected)
        self.updateForState(using: style)
    }
    func updateForState(using style: DNSThemeStyle) {
        if self.isEnabled {
            self.backgroundColor = style.backgroundColor.normal
            self.layer.borderColor = style.border.color.normal.cgColor
            self.layer.shadowColor = style.shadow.color.normal.cgColor
            self.isSkeletonable = style.skeletonable.normal
            self.tintColor = style.tintColor.normal
        } else {
            self.backgroundColor = style.backgroundColor.disabled
            self.layer.borderColor = style.border.color.disabled.cgColor
            self.layer.shadowColor = style.shadow.color.disabled.cgColor
            self.isSkeletonable = style.skeletonable.disabled
            self.tintColor = style.tintColor.disabled
        }
        if self.isSelected {
            self.backgroundColor = style.backgroundColor.selected
            self.layer.borderColor = style.border.color.selected.cgColor
            self.layer.shadowColor = style.shadow.color.selected.cgColor
            self.isSkeletonable = style.skeletonable.selected
            self.tintColor = style.tintColor.selected
        }
        if self.isHighlighted {
            self.backgroundColor = style.backgroundColor.highlighted
            self.layer.borderColor = style.border.color.highlighted.cgColor
            self.layer.shadowColor = style.shadow.color.highlighted.cgColor
            self.isSkeletonable = style.skeletonable.highlighted
            self.tintColor = style.tintColor.highlighted
        }
        if self.isFocused {
            self.backgroundColor = style.backgroundColor.focused
            self.layer.borderColor = style.border.color.focused.cgColor
            self.layer.shadowColor = style.shadow.color.focused.cgColor
            self.isSkeletonable = style.skeletonable.focused
            self.tintColor = style.tintColor.focused
        }
    }
    func updateForState(using style: DNSThemeButtonStyle) {
        self.updateForState(using: style as DNSThemeStyle)
        if self.isEnabled {
            if #available(iOS 15.0, *) {
                self.subtitleLabel?.textColor = style.subtitleStyle.color.normal
                self.subtitleLabel?.font = style.subtitleStyle.font.normal
                self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.normal
                self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
            }
            self.titleLabel?.font = style.titleStyle.font.normal
        } else {
            if #available(iOS 15.0, *) {
                self.subtitleLabel?.textColor = style.subtitleStyle.color.disabled
                self.subtitleLabel?.font = style.subtitleStyle.font.disabled
                self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.disabled
                self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
            }
            self.titleLabel?.font = style.titleStyle.font.disabled
        }
        if self.isSelected {
            if #available(iOS 15.0, *) {
                self.subtitleLabel?.textColor = style.subtitleStyle.color.selected
                self.subtitleLabel?.font = style.subtitleStyle.font.selected
                self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.selected
                self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
            }
            self.titleLabel?.font = style.titleStyle.font.selected
        }
        if self.isHighlighted {
            if #available(iOS 15.0, *) {
                self.subtitleLabel?.textColor = style.subtitleStyle.color.highlighted
                self.subtitleLabel?.font = style.subtitleStyle.font.highlighted
                self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.highlighted
                self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
            }
            self.titleLabel?.font = style.titleStyle.font.highlighted
        }
        if self.isFocused {
            if #available(iOS 15.0, *) {
                self.subtitleLabel?.textColor = style.subtitleStyle.color.focused
                self.subtitleLabel?.font = style.subtitleStyle.font.focused
                self.subtitleLabel?.shadowColor = style.subtitleStyle.shadow.color.focused
                self.subtitleLabel?.shadowOffset = style.subtitleStyle.shadow.offset
            }
            self.titleLabel?.font = style.titleStyle.font.focused
        }
    }
}
