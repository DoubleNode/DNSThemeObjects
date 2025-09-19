//
//  UIImage+dnsSymbol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import SFSymbol
import UIKit

public extension UIImage {
    convenience init?<T: RawRepresentable>(dnsSymbol: T) where T.RawValue == String {
        self.init(systemName: dnsSymbol.rawValue)
    }
}
