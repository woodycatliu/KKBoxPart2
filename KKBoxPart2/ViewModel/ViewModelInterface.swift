//
//  ViewModelInterface.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import Foundation

protocol TableViewModelProtocol {
    associatedtype DataModelForCell
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> DataModelForCell?
}

protocol TableViewModelSelectedProtocol {
    func didSelectedCell(_ indexPath: IndexPath)
}

protocol CellViewModelProtocol {
    var identifier: String { get }
}

protocol CellViewModelConfigureHandler {
    func configureCell(_ viewModel: CellViewModelProtocol)
}
