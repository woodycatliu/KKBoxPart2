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
    case mediaInfoPage(_ media: Media, _ cache: [Media])
}

protocol FrontPageUseCase {
    var navigateReducer: NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment> { get }
    func convertRssInfo(_ info: EpisodeInfo, items: [EpisodeItem])-> (album: Album, mediaList: [Media])
    func updateAlbumInfo(newAlbumInfo new: Album, oldAlbumInfo old: inout Album?)
    func updateMediaList(newMediaList new: [Media], oldMediaList old: inout [Media]?)
    func cellDidSelected(_ indexPath: IndexPath, _ mediaList: [Media])
    func fetchRss(_ url: URL)-> KKParser.ParsePublisher
}

extension FrontPageUseCase {
    func updateAlbumInfo(newAlbumInfo new: Album, oldAlbumInfo old: inout Album?) {
        updateState(new, &old)
    }

    func updateMediaList(newMediaList new: [Media], oldMediaList old: inout [Media]?) {
        updateState(new, &old)
    }

    private func updateState<T>(_ new: T, _ old: inout T?) {
        old = new
    }
}


struct DefaultFrontPageCase: FrontPageUseCase {
    
    /// output: (EpisodeInfo, [EpisodeItem])
    func fetchRss(_ url: URL) -> KKParser.ParsePublisher {
        return KKParser.publish(url)
    }
    
    var navigateReducer: NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment>

    func convertRssInfo(_ info: EpisodeInfo, items: [EpisodeItem]) -> (album: Album, mediaList: [Media]) {
        let album = Album(title: info.title, image: info.image)
        let mediaList = items.map {
            Media(link: $0.link, title: $0.title, albumTitle: info.title, imageData: nil, remoteImage: URL(string: $0.image), artist: $0.summary, date: $0.date)
        }
        return (album, mediaList)
    }
    
    func cellDidSelected(_ indexPath: IndexPath, _ mediaList: [Media]) {
        guard mediaList.indices.contains(indexPath.row) else { return }
        let media = mediaList[indexPath.row]
        navigateReducer(.mediaInfoPage(media, mediaList), GobalPlayerContrller.shared)
    }
}


let FrontPageNavigatedReducer: (_ completion: @escaping (Media, [Media])->())-> NavigatedCaseReducer<FrontPageNavigatedAction, FrontPageEnvionment> = { completion in
    return { action, _ in
        switch action {
        case .mediaInfoPage(let media, let list):
            completion(media, list)
        }
    }
}

let CreateFrontTransitionCase: (UIViewController)->(Media, [Media])->() = { vc in
    return { [weak vc] media, list in
        let mediaPage = ViewController()
        vc?.navigationController?.pushViewController(mediaPage, animated: true)
    }
}

