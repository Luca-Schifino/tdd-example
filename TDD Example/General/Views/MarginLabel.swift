//
//  MarginLabel.swift
//  TDD Example
//
//  Created by Luca Schifino on 25/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

open class MarginLabel: UILabel {

    open var insets: UIEdgeInsets = UIEdgeInsets() {
        didSet {
            super.invalidateIntrinsicContentSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }

    override open func drawText(in rect: CGRect) {
        return super.drawText(in: rect.inset(by: insets))
    }
}
