//
//  MediaPageUseCase.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import Foundation

typealias MediaPageEnvionment = Any?

enum MediaPageNavigatedAction {
    case playerPage(_ media: PlayerMediaInfo, _ cache: [PlayerMediaInfo])
}

protocol MediaPageUseCase {
    var navigateReducer: NavigatedCaseReducer<MediaPageNavigatedAction, MediaPageEnvionment> { get }
    func play(_ mediaInfo: PlayerMediaInfo, fullList list: [PlayerMediaInfo])
}


struct DefaultMediaPageCase: MediaPageUseCase {
    var navigateReducer: NavigatedCaseReducer<MediaPageNavigatedAction, MediaPageEnvionment>
    
    func play(_ mediaInfo: PlayerMediaInfo, fullList list: [PlayerMediaInfo]) {
        navigateReducer(.playerPage(mediaInfo, list), nil)
    }
}

let MediaPageNavigatedReducer: (_ completion: @escaping (PlayerMediaInfo, [PlayerMediaInfo])->())-> NavigatedCaseReducer<MediaPageNavigatedAction, MediaPageEnvionment> = { completion in
    return { action, _ in
        switch action {
        case .playerPage(let media, let list):
            completion(media, list)
        }
    }
}
