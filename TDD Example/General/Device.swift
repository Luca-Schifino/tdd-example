//
//  Device.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

struct Device {
    
    static var topSafeAreaInset: CGFloat = {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 44
    }()
    
    static var bottomSafeAreaInset: CGFloat = {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 34
    }()
}
