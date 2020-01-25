//
//  UIViewController+Rating.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private var modalMaskTag: Int {
        get {
            return 1001
        }
    }
    
    func showRatingView(delegate: RatingViewDelegate) {
        let ratingView = RatingView(parentView: view, delegate: delegate)
        view.addSubview(ratingView)
    }
    
    func addModalMaskView() {
        let maskView = UIView(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        maskView.alpha = 0
        maskView.tag = modalMaskTag
        UIView.animate(withDuration: 0.2) {
            maskView.alpha = 1
        }
        self.view.addSubview(maskView)
        self.view.bringSubviewToFront(maskView)
    }
    
    func removeModalMaskView() {
        self.view.subviews.forEach { (view) in
            if view.tag == modalMaskTag {
                view.removeFromSuperview()
            }
        }
    }
}
