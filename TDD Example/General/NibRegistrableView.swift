//
//  NibRegistrableView.swift
//  TDD Example
//
//  Created by Luca Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

public protocol NibRegistrableView: UIView {
    static var nibName: String { get }
    static var reuseId: String { get }
}

public extension NibRegistrableView {
    static var nibName: String { return String(describing: Self.self) }
    static var reuseId: String { return String(describing: Self.self) }
    static var nib: UINib { return UINib(nibName: nibName, bundle: Bundle(for: self)) }
    
    static func instantiateFromNib() -> Self? {
        return self.nib.instantiate(withOwner: nil, options: nil).first as? Self
    }
}

public typealias NibRegistrableTableViewCell = NibRegistrableView & UITableViewCell
public typealias NibRegistrableCollectionViewCell = NibRegistrableView & UICollectionViewCell
public typealias NibRegistrableTableViewHeaderFooterView = NibRegistrableView & UITableViewHeaderFooterView

public extension UITableView {
    func registerNib(for cellClass: NibRegistrableTableViewCell.Type) {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseId)
    }
    
    func registerHeaderNib(for headerFooterClass: NibRegistrableTableViewHeaderFooterView.Type) {
        register(headerFooterClass.nib, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseId)
    }
    
    func dequeueReusableCell<T: NibRegistrableTableViewCell>() -> T? {
        return dequeueReusableCell(withIdentifier: T.reuseId) as? T
    }
    
    func dequeueReusableHeaderFooter<T: NibRegistrableTableViewHeaderFooterView>() -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseId) as? T
    }
}

public extension UICollectionView {
    func registerNib(for cellClass: NibRegistrableCollectionViewCell.Type) {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseId)
    }
    
    func dequeueReusableCell<T: NibRegistrableCollectionViewCell>(for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T
    }
}
