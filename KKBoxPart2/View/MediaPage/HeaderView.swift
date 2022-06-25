//
//  HeaderView.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit

class HeaderView: UIView {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray5
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        imageView.fullSuperview()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.7).isActive = true
    }
}
