//
//  MediaInfoCell.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit

class MediaInfoCell: UITableViewCell {
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray5
        return iv
    }()

    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 12)
        return lb
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 14.5)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        let height = imgView.heightAnchor.constraint(equalToConstant: 80)
        height.priority = .init(999)
        height.isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -2),
            dateLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -3)
        ])
        
    }

}

extension MediaInfoCell: CellViewModelConfigureHandler {
    
    func configureCell(_ viewModel: CellViewModelProtocol) {
        guard let media = viewModel as? Media else {
            fatalError("CellViewModel can not as Media")
        }
            titleLabel.text = media.title
            dateLabel.text = media.date.formatted(date: .numeric, time: .shortened)
        imgView.sd_setImage(with: media.remoteImage, completed: nil)
        }

}
