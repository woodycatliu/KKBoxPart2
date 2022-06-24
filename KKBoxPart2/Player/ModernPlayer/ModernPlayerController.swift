//
//  ModernPlayerController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Combine
import ModernAVPlayer

class ModernPlayerController: PlayerController {
    private(set) var playerState: CurrentValueSubject<PlayerState, Never> = .init(.stopped)
    
    private(set) var pocastState: CurrentValueSubject<PocastPlayState?, Never> = .init(nil)
    
    private let player: ModernAVPlayer
    
    init(_ config: PlayerConfiguration = ModernConfig(), remoteCommands: [ModernAVPlayerRemoteCommand]? = nil) {
        player = ModernAVPlayer(config: ModernConfig())
        player.delegate = self
        player.loopMode = false
        player.remoteCommands = nil
    }
    
    func load(mediaInfo info: PlayerMediaInfo, isAutoStart: Bool) {
        guard let url = URL(string: info.link) else {
            playerState.send(.failed)
            return
        }
        let metaData = ModernAVPlayerMediaMetadata(title: info.title, albumTitle: nil, artist: info.artist, image: nil, remoteImageUrl: info.remoteImage)
        
        let mediadata = ModernAVPlayerMedia(url: url, type: .clip, metadata: metaData, assetOptions: nil)
        player.load(media: mediadata, autostart: isAutoStart, position: 0)
    }
    
    func seek(offset: Double) {
        player.seek(offset: offset)
    }
    
    func seek(position: Double) {
        player.seek(position: position)
    }
    
    func stop() {
        player.stop()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }

    
}

// MARK: ModernAVPlayerDelegate
extension ModernPlayerController: ModernAVPlayerDelegate {
    
    func modernAVPlayer(_ player: ModernAVPlayer, didStateChange state: ModernAVPlayer.State) {
        playerState.send(PlayerState.getState(from: state))
    }
    
    func modernAVPlayer(_ player: ModernAVPlayer, didCurrentMediaChange media: PlayerMedia?) {}
    
    func modernAVPlayer(_ player: ModernAVPlayer, didCurrentTimeChange currentTime: Double) {
        var state = pocastState.value
        state?.position = currentTime
        pocastState.send(state)
    }
    
    func modernAVPlayer(_ player: ModernAVPlayer, didItemDurationChange itemDuration: Double?) {
        guard let itemDuration = itemDuration else { return }
        var state = pocastState.value
        state?.duration = itemDuration
        pocastState.send(state)
    }
    
    func modernAVPlayer(_ player: ModernAVPlayer, didItemPlayToEndTime endTime: Double) {
        playerState.send(.end)
    }
    
}

// MARK: extension PlayerState
extension PlayerState {
    
    static func getState(from: ModernAVPlayer.State) -> PlayerState {
        switch from {
        case .buffering:
            return .buffering
        //讀取失敗
        case .failed:
            return .failed
        case .initialization:
            // init 時候的狀態
            return .loading
        case .loaded:
            return .canPlay
        case .loading:
            return .loading
        case .paused:
            return .canPlay
        case .playing:
            return .canPause
        case .stopped:
            return .stopped
        case .waitingForNetwork:
            return .canPlay
        }
    }
    
}

