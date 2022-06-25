//
//  FrontPageViewController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import UIKit
import Combine

class FrontPageViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    var viewModel: FrontViewModelProtocol?
    
    let headerView: HeaderView = HeaderView()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(MediaInfoCell.self, forCellReuseIdentifier: MediaInfoCell.description())
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureUI()
        binding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.layoutTableHeaderViewIfNeeded()
        super.viewDidAppear(animated)
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.fullSuperview()
        tableView.tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
    }
    
    private func configureViewModel() {
        let reducer = FrontPageNavigatedReducer { [weak self] media, list in
            self?.navigationController?.pushViewController(ViewController(), animated: true)
        }
        let useCase = DefaultFrontPageCase(navigateReducer: reducer)
        viewModel = FrontPageViewModel(useCase)
    }
    
    private func binding() {
        viewModel?.album
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] album in
                guard let image = album?.image else { return }
                self?.headerView.imageView.sd_setImage(with: URL(string: image), completed: nil)
            }).store(in: &bag)
        
        viewModel?.mediaList
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &bag)
    }
 
}

// MARK: UITableViewDataSource
extension FrontPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.dataModelFoRowAt(indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as? CellViewModelConfigureHandler else {
                  fatalError("\(self) missing Cell")
              }
        cell.configureCell(cellViewModel)
        return cell
    }

}

// MARK: UITableViewDelegate
extension FrontPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectedCell(indexPath)
    }
}
