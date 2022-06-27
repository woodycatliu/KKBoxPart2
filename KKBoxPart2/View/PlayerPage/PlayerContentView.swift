//
//  PlayerContentView.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/26.
//

import UIKit

class PlayerContentView: UIView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 20)
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
    
    let sliderBar: UISlider = {
        let sb = CustomSlider()
        sb.isContinuous = false
        sb.minimumTrackTintColor = UIColor(red: 168 / 255, green: 219 / 255, blue: 251 / 255, alpha: 1)
        sb.thumbTintColor = .white.withAlphaComponent(0.5)
        return sb
    }()
    
    let playBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        btn.setBackgroundImage(UIImage(systemName: "play.circle")?.sd_resizedImage(with: .init(width: 100, height: 100), scaleMode: .aspectFit)?.sd_tintedImage(with: UIColor.lightGray), for: .highlighted)
        return btn
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
        btn.setBackgroundImage(UIImage(systemName: "backward")?.sd_resizedImage(with: .init(width: 60, height: 36), scaleMode: .aspectFit)?.sd_tintedImage(with: UIColor.lightGray), for: .highlighted)
        return btn
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
        btn.setBackgroundImage(UIImage(systemName: "forward")?.sd_resizedImage(with: .init(width: 60, height: 36), scaleMode: .aspectFit)?.sd_tintedImage(with: UIColor.lightGray), for: .highlighted)
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
        
        addSubview(playBtn)
        playBtn.centerInSuperview(.x)
        NSLayoutConstraint.activate([
            playBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playBtn.widthAnchor.constraint(equalTo: playBtn.heightAnchor),
            playBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.40)
        ])
        
        addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor),
            backBtn.heightAnchor.constraint(equalTo: backBtn.widthAnchor, multiplier: 0.60),
            backBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.20),
            backBtn.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: 8)
        ])
        
        addSubview(nextBtn)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor),
            nextBtn.heightAnchor.constraint(equalTo: nextBtn.widthAnchor, multiplier: 0.6),
            nextBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.20),
            nextBtn.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: -8)
        ])
        
        addSubview(sliderBar)
        sliderBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            sliderBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            sliderBar.heightAnchor.constraint(equalToConstant: 40),
            sliderBar.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -10)
        ])
        
        let scroll = UIScrollView()
        scroll.bounces = true
        scroll.zoomScale = 1
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        
        addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            scroll.bottomAnchor.constraint(equalTo: sliderBar.topAnchor, constant: -10)
        ])
        
        scroll.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scroll.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scroll.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scroll.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: scroll.bottomAnchor)
        ])
    }
}

// MARK: setData
extension PlayerContentView {
    
    func setData(_ media: PlayerMediaInfo?) {
        guard let media = media else { return }
        titleLabel.text = media.title
        imageView.sd_setImage(with: media.remoteImage, completed: nil)
    }
}

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var bounds = super.trackRect(forBounds: bounds)
        bounds.size.height = 12
        return bounds
    }
}
