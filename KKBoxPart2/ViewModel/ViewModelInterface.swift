//
//  ViewModelInterface.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit

protocol TableViewModelProtocol {
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> CellViewModelProtocol?
}

protocol TableViewModelSelectedProtocol {
    func didSelectedCell(_ indexPath: IndexPath)
}

protocol CellViewModelProtocol {
    var identifier: String { get }
}

protocol CellViewModelConfigureHandler: UITableViewCell {
    func configureCell(_ viewModel: CellViewModelProtocol)
}
