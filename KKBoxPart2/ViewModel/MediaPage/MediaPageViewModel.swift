//
//  MediaPageViewModel.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import Combine

protocol MediaPageViewModelProtocol {
    var media: CurrentValueSubject<Media?, Never> { get }
    func play()
}

class MediaPageViewModel: MediaPageViewModelProtocol {

    let useCase: MediaPageUseCase
    
    private(set) var media: CurrentValueSubject<Media?, Never> = .init(nil)
    
    private var fullList: [Media] = []

    
    init(_ useCase: MediaPageUseCase, media: Media, fullList: [Media]) {
        self.useCase = useCase
        self.fullList = fullList
        self.media.value = media
    }
    
    func play() {
        guard let media = media.value else {
            return
        }
        useCase.play(media, fullList: fullList)
    }
    
}
