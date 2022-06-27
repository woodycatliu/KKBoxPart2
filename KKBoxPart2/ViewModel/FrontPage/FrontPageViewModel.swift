//
//  FrontPageViewModel.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import Combine
import Foundation

typealias FrontPageCell = CellViewModelProtocol

protocol FrontViewModelProtocol: TableViewModelProtocol, TableViewModelSelectedProtocol {
    var album: CurrentValueSubject<Album?, Never> { get }
    var mediaList: CurrentValueSubject<[Media]?, Never> { get }
    func fetch(url: URL?)
}

class FrontPageViewModel: FrontViewModelProtocol {
    
    private var bag = Set<AnyCancellable>()
    
    private(set) var album: CurrentValueSubject<Album?, Never> = .init(nil)
    
    private(set) var mediaList: CurrentValueSubject<[Media]?, Never> = .init(nil)
    
    let useCase: FrontPageUseCase
        
    init(_ useCase: FrontPageUseCase) {
        self.useCase = useCase
    }
    
    var numbersOfSection: Int = 1
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return mediaList.value?.count ?? 0
    }
    
    func dataModelFoRowAt(_ indexPath: IndexPath) -> CellViewModelProtocol? {
        guard let mediaList = mediaList.value,
              mediaList.indices.contains(indexPath.row) else {
                  return nil
              }
        return MediaCellViewModel(media: mediaList[indexPath.row])
    }
    
    func didSelectedCell(_ indexPath: IndexPath) {
        guard let mediaList = mediaList.value else {
            return
        }
        useCase.cellDidSelected(indexPath, mediaList)
    }
    
}

extension FrontPageViewModel {
    
    func fetch(url: URL?) {
        guard let url = url else { return }
        useCase.fetchRss(url)
            .map {[unowned self] in return self.useCase.convertRssInfo($0.0, items: $0.1)}
            .sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] in
                self.useCase.updateMediaList(newMediaList: $0.mediaList, oldMediaList: &self.mediaList.value)
                self.useCase.updateAlbumInfo(newAlbumInfo: $0.album, oldAlbumInfo: &self.album.value)
            })
            .store(in: &bag)
    }
}
