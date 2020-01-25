//
//  RatingViewView.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

protocol RatingViewDelegate: AnyObject {
    func willDismissRatingView(withRating rating: Int?)
}

class RatingView: UIView {
    
    // MARK: IBOutlets
    @IBOutlet var contentView: UIView! {
        didSet {
            contentView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.clipsToBounds = true
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            headerView.layer.cornerRadius = 50
            headerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismissViewPanGestureHandler(recognizer:))))

        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()
            collectionView.registerNib(for: RatingCollectionViewCell.self)
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.setTitle("confirm".localized(), for: .normal)
            enableSendButton(false)
        }
    }
    
    // MARK: Variables
    private weak var delegate: RatingViewDelegate?
    private let parentView: UIView
    private let animationsDuration = 0.5
    private let gradeCount = 10
    private var selectedRating: Int?
    private var ratingToSave: Int?
    
    // MARK: Life Cycle
    init(parentView: UIView, delegate: RatingViewDelegate?, initialRating: Int?) {
        self.parentView = parentView
        self.delegate = delegate
        self.selectedRating = initialRating
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        parentView = UIView()
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        configConstraints()
    }
    
    // MARK: Functions
    private func configConstraints() {
        addSubview(contentView)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        transform = CGAffineTransform(translationX: 0, y: contentView.frame.height)
        UIView.animate(withDuration: animationsDuration) {
            self.transform = .identity
        }
    }
    
    private func enableSendButton(_ shouldEnable: Bool = true) {
        confirmButton.isUserInteractionEnabled = shouldEnable
        confirmButton.isEnabled = shouldEnable
    }
    
    @objc func dismissViewPanGestureHandler(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .ended {
            if contentView.frame.minY > contentView.frame.height/4 {
                dismissAnimated()
            } else {
                animateToShow()
            }
        } else {
            let translationY = recognizer.translation(in: contentView).y
            if translationY <= contentView.frame.maxY && translationY > 0 {
                contentView.frame.origin = CGPoint(x: contentView.frame.minX, y: translationY)
            }
        }
    }
    
    private func dismissAnimated() {
        delegate?.willDismissRatingView(withRating: ratingToSave)
        UIView.animate(withDuration: animationsDuration, animations: {
            guard let contentView = self.contentView else { return }
            contentView.frame.origin = CGPoint(x: contentView.frame.minX, y: contentView.frame.minY + contentView.frame.height)
        }) { [ weak self ] _ in
            self?.removeFromSuperview()
        }
    }
    
    private func animateToShow() {
        UIView.animate(withDuration: animationsDuration) {
            guard let contentView = self.contentView else { return }
            contentView.frame.origin = CGPoint(x: contentView.frame.minX, y: 0)
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        ratingToSave = selectedRating
        dismissAnimated()
    }
}

// MARK: - UICollectionViewDataSource
extension RatingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RatingCollectionViewCell? = collectionView.dequeueReusableCell(for: indexPath)
        let grade = indexPath.row + 1
        let selected = selectedRating == grade
        cell?.configure(grade: grade, selected: selected)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RatingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let grade = indexPath.row + 1
        selectedRating = grade
        enableSendButton()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gradeCellWidth = collectionView.frame.width / CGFloat(gradeCount)
        return CGSize(width: gradeCellWidth, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
