//
//  DNSAlertViewController.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import UIKit

final public class DNSAlertViewController: UIViewController {
    /// This creates a retain cycle.
    /// This is needed to retain the UIAlertController in iOS 13.0+
    public var retainedWindow: UIWindow?
    deinit {
        retainedWindow = nil
    }
}
