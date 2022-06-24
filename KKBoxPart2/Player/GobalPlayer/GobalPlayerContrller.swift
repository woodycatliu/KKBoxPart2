//
//  GobalPlayerContrller.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation
import Combine

class GobalPlayerContrller: PodcastsPlayController {
    
    private var bag = Set<AnyCancellable>()
    
    private(set) var mediaList: CurrentValueSubject<[PlayerMediaInfo], Never> = .init([])
    
    private(set) var playerState: CurrentValueSubject<PlayerState, Never> = .init(.stopped)
    
    private(set) var pocastState: CurrentValueSubject<PocastPlayState?, Never> = .init(nil)
    
    let controller: PlayerController
    
    private(set) var currentMedia: PlayerMediaInfo?
    
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
        guard let id = id,
              let currentId = currentMedia?.id else {
                  return false
              }
        return id != currentId
    }
    
    private func loadMedia(_ id: String) {
        if let index = mediaList.value.firstIndex(where: { id == $0.id }) {
            let info = mediaList.value[index]
            currentMedia = info
            controller.load(mediaInfo: info, isAutoStart: true)
        }
    }
    
    private func nextIfNeed() {
        guard !mediaList.value.isEmpty,
              let id = currentMedia?.id,
              let index = mediaList.value.firstIndex(where: { id == $0.id }),
              mediaList.value.indices.contains(index + 1) else { return }
        let info = mediaList.value[index + 1]
        currentMedia = info
        controller.load(mediaInfo: info, isAutoStart: true)
    }
    
    private func backIfNeed() {
        guard !mediaList.value.isEmpty,
              let id = currentMedia?.id,
              let index = mediaList.value.firstIndex(where: { id == $0.id }),
              mediaList.value.indices.contains(index - 1) else { return }
        let info = mediaList.value[index - 1]
        currentMedia = info
        controller.load(mediaInfo: info, isAutoStart: true)
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
    }
    
}
