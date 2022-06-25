//
//  UIViewExtension.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit

extension UIView {
    
    func fullSuperview_(_ offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
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
