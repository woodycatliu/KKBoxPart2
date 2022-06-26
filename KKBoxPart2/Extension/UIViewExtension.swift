//
//  UIViewExtension.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit

extension UIView {
    
    func fullSuperview(_ offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: offset.top),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: offset.left),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: offset.right),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: offset.bottom)
        ])
    }
    
    enum Center {
        case x, y, both
    }
    
    func centerInSuperview(_ centerCase: Center = .both) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        switch centerCase {
        case .x:
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        case .y:
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        case .both:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
        }
    }
}

extension UITableView {
    func layoutTableHeaderViewIfNeeded() {
        tableHeaderView?.layoutIfNeeded()
        tableHeaderView = tableHeaderView
    }
}

extension UIActivityIndicatorView {
    static func Configure(_ isShow: Bool, _ view: UIView) {
        if isShow {
            let ac = UIActivityIndicatorView()
            ac.style = .large
            ac.tag = 9999
            ac.tintColor = UIColor.gray
            ac.backgroundColor = .white
            view.addSubview(ac)
            ac.fullSuperview()
            ac.startAnimating()
            view.bringSubviewToFront(ac)
            return
        }
        view.viewWithTag(9999)?.removeFromSuperview()
    }
}
