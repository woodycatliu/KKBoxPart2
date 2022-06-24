//
//  Podcast.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Combine

protocol PlayerController {
    var playerState: CurrentValueSubject<PlayerState, Never> { get }
    
    var pocastState: CurrentValueSubject<PocastPlayState?, Never> { get }
    
    func load(mediaInfo info: PlayerMediaInfo, isAutoStart: Bool)
    // 播放偏移秒數
    func seek(offset: Double)
    // 指定播放第幾秒
    func seek(position: Double)
    
    func stop()
    
    func play()
    
    func pause()
}
