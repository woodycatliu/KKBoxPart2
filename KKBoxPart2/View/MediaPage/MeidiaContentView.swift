//
//  MeidiaContentView.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/26.
//

import UIKit

class MeidiaContentView: UIView {
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 3
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 18)
        lb.textColor = UIColor.black
        return lb
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.borderColor = UIColor.systemGray3.cgColor
        iv.layer.borderWidth = 0.75
        iv.layer.cornerRadius = 7
        iv.layer.masksToBounds = true
        return iv
    }()

    let summaryLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 14.5)
        lb.textColor = UIColor.black
        return lb
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        btn.setBackgroundImage(UIImage(systemName: "play.circle")?.sd_resizedImage(with: .init(width: 100, height: 100), scaleMode: .aspectFit)?.sd_tintedImage(with: UIColor.lightGray), for: .highlighted)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confiugreUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func confiugreUI() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 7.5),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        imageView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.centerYAnchor)
        ])
        
        addSubview(button)
        button.centerInSuperview(.x)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
        
        let scroll = UIScrollView()
        scroll.bounces = true
        scroll.zoomScale = 1
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false

        addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            scroll.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -3)
        ])
        
        scroll.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: scroll.topAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: scroll.safeAreaLayoutGuide.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: scroll.safeAreaLayoutGuide.trailingAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: scroll.bottomAnchor)
        ])
    }
}

// MARK: setData
extension MeidiaContentView {
    
    func setData(_ media: Media?) {
        guard let media = media else { return }
        titleLabel.text = media.title
        summaryLabel.text = media.artist
        imageView.sd_setImage(with: media.remoteImage, completed: nil)
    }
}
