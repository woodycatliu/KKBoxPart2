//
//  MainVCUseCase.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import UIKit
import Combine

typealias FrontPageEnvionment = Any?

enum FrontPageNavigatedAction {
    case mediaInfoPage(_ media: PlayerMediaInfo, _ cache: [PlayerMediaInfo])
}

protocol FrontPageUseCase {
    var navigateReducer: NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment> { get }
    func convertRssInfo(_ info: EpisodeInfo, items: [EpisodeItem])-> (album: AlbumMediaInfo, mediaList: [PlayerMediaInfo])
    func updateAlbumInfo(newAlbumInfo new: AlbumMediaInfo, oldAlbumInfo old: inout AlbumMediaInfo?)
    func updateMediaList(newMediaList new: [PlayerMediaInfo], oldMediaList old: inout [PlayerMediaInfo]?)
    func cellDidSelected(_ indexPath: IndexPath, _ mediaList: [PlayerMediaInfo])
}

extension FrontPageUseCase {
    
    func updateAlbumInfo(newAlbumInfo new: AlbumMediaInfo, oldAlbumInfo old: inout AlbumMediaInfo?) {
        updateState(new, &old)
    }

    func updateMediaList(newMediaList new: [PlayerMediaInfo], oldMediaList old: inout [PlayerMediaInfo]?) {
        updateState(new, &old)
    }

    private func updateState<T>(_ new: T, _ old: inout T?) {
        old = new
    }
}


struct DefaultFrontPageCase: FrontPageUseCase {
    
    var navigateReducer: NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment>

    func convertRssInfo(_ info: EpisodeInfo, items: [EpisodeItem]) -> (album: AlbumMediaInfo, mediaList: [PlayerMediaInfo]) {
        let album = Album(title: info.title, image: info.image)
        let mediaList = items.map {
            Media(link: $0.link, title: $0.title, albumTitle: info.title, imageData: nil, remoteImage: URL(string: $0.image), artist: $0.summary, date: $0.date)
        }
        return (album, mediaList)
    }
    
    func cellDidSelected(_ indexPath: IndexPath, _ mediaList: [PlayerMediaInfo]) {
        guard mediaList.indices.contains(indexPath.row) else { return }
        let media = mediaList[indexPath.row]
        navigateReducer(.mediaInfoPage(media, mediaList), GobalPlayerContrller.shared)
    }
}


let FrontPageNavigatedReducer: (_ completion: @escaping (PlayerMediaInfo, [PlayerMediaInfo])->())-> NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment> = { completion in
    return { action, _ in
        switch action {
        case .mediaInfoPage(let media, let list):
            completion(media, list)
        }
    }
}
