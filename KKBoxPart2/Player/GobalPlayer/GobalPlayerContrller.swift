//
//  GobalPlayerContrller.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation
import Combine

class GobalPlayerContrller: PodcastsPlayController {
    
    
    static let shared: GobalPlayerContrller = GobalPlayerContrller(ModernPlayerController())
    
    private var bag = Set<AnyCancellable>()
    
    private(set) var mediaList: CurrentValueSubject<[PlayerMediaInfo], Never> = .init([])
    
    private(set) var playerState: CurrentValueSubject<PlayerState, Never> = .init(.stopped)
    
    private(set) var pocastState: CurrentValueSubject<PocastPlayState?, Never> = .init(nil)
    
    private(set) var currentMedia: CurrentValueSubject<PlayerMediaInfo?, Never> = .init(nil)

    let controller: PlayerController
        
    init(_ controller: PlayerController) {
        self.controller = controller
        binding()
    }
    
    func load(mediaInfoList list: [PlayerMediaInfo], playId: String) {
        mediaList.send(list)
        play(playId)
    }
    
    func seek(offset: Double) {
        controller.seek(offset: offset)
    }
    
    func seek(position: Double) {
        controller.seek(position: position)
    }
    
    func play(_ id: String?) {
        if isNeedLoadMedia(id) {
            loadMedia(id!)
            return
        }
        controller.play()
    }
    
    func stop() {
        controller.stop()
    }
    
    func pause() {
        controller.pause()
    }
    
    func next() {
        nextIfNeed()
    }
    
    func back() {
        backIfNeed()
    }
    
}

extension GobalPlayerContrller {
    
    private func isNeedLoadMedia(_ id: String?)-> Bool {
        guard let id = id else { return false }
        if let currentId = currentMedia.value?.id {
            return id != currentId
        }
        return true
    }
    
    private func loadMedia(_ id: String) {
        if let index = mediaList.value.firstIndex(where: { id == $0.id }) {
            let info = mediaList.value[index]
            currentMedia.value = info
//            controller.load(mediaInfo: info, isAutoStart: true)
        }
    }
    
    private func nextIfNeed() {
        guard !mediaList.value.isEmpty,
              let id = currentMedia.value?.id,
              let index = mediaList.value.firstIndex(where: { id == $0.id }),
              mediaList.value.indices.contains(index + 1) else { return }
        let info = mediaList.value[index + 1]
        currentMedia.value = info
//        controller.load(mediaInfo: info, isAutoStart: true)
    }
    
    private func backIfNeed() {
        guard !mediaList.value.isEmpty,
              let id = currentMedia.value?.id,
              let index = mediaList.value.firstIndex(where: { id == $0.id }),
              mediaList.value.indices.contains(index - 1) else { return }
        let info = mediaList.value[index - 1]
        currentMedia.value = info
//        controller.load(mediaInfo: info, isAutoStart: true)
    }
    
    private func binding() {
        
        controller.pocastState
            .sink(receiveValue: pocastState.send(_:))
            .store(in: &bag)
        
        controller.playerState
            .sink(receiveValue: playerState.send(_:))
            .store(in: &bag)
        
        controller.playerState
            .filter{ $0 == .end }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.nextIfNeed()
            })
            .store(in: &bag)
        
        currentMedia
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] media in
                self?.controller.load(mediaInfo: media, isAutoStart: true)
            })
            .store(in: &bag)
    }
    
}
