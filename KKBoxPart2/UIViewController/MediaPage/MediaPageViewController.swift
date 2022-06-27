//
//  MediaPageViewController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/26.
//

import UIKit
import Combine

class MediaPageViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    let contentView: MeidiaContentView = MeidiaContentView()
    
    var viewModel: MediaPageViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        confiugreUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func confiugreUI() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        view.backgroundColor = .white
        contentView.fullSuperview()
        contentView.button.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }

    private func binding() {
        viewModel?.media
            .receive(on: RunLoop.main)
            .sink(receiveValue: contentView.setData(_:))
            .store(in: &bag)
    }
    
}

// MARK: BTN
extension MediaPageViewController {
    @objc func clickBtn() {
        viewModel?.play()
    }
}
