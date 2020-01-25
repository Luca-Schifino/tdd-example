//
//  UIView+Extension.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

extension UIView {
    
    func hasSubviewOf<T: UIView>(type: T.Type) -> Bool {
        guard getSubviewOf(type: type) != nil else {
            return false
        }
        return true
    }
    
    func getSubviewOf<T: UIView>(type: T.Type) -> UIView? {
        for subview in subviews where subview is T {
            return subview
        }
        return nil
    }
}
