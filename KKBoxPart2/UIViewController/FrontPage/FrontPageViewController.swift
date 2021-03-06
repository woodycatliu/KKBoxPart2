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
        tv.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        tv.register(MediaInfoCell.self, forCellReuseIdentifier: MediaInfoCell.description())
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureUI()
        binding()
        fetch()
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
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.fullSuperview()
        tableView.tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
    }
    
    private func configureViewModel() {
        let useCase = DefaultFrontPageCase(navigateReducer: FrontPageNavigatedReducer(CreateFrontTransitionCase(self)))
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
        
        // set loading view
        viewModel?.mediaList
            .map { $0 == nil }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                UIActivityIndicatorView.Configure($0, self.view)
            })
            .store(in: &bag)
    }
    
    private func fetch() {
        DispatchQueue.global().async {
            self.viewModel?.fetch(url: URL(string: Domain))
        }
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
