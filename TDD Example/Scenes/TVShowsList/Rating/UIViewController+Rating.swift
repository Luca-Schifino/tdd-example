//
//  UIViewController+Rating.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showRatingView() {
        let ratingView = RatingView(parentView: view)
        view.addSubview(ratingView)
    }
}
