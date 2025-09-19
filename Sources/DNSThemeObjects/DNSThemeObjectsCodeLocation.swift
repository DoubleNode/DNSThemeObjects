//
//  DNSThemeObjectsCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias baseTheme = DNSThemeObjectsCodeLocation
}
open class DNSThemeObjectsCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.baseTheme." }
}
