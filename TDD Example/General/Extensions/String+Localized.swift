//
//  String+Localized.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns localized string from key.
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
