//
//  PodcastsPlayController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation
import Combine

protocol PodcastsPlayController {
    var playerState: CurrentValueSubject<PlayerState, Never> { get }
    
    var pocastState: CurrentValueSubject<PocastPlayState?, Never> { get }
    
    var mediaList: CurrentValueSubject<[PlayerMediaInfo], Never> { get }
    
    var currentMedia: CurrentValueSubject<PlayerMediaInfo?, Never> { get }
    
    func load(mediaInfoList list: [PlayerMediaInfo], playId: String)
    // 播放偏移秒數
    func seek(offset: Double)
    // 指定播放第幾秒
    func seek(position: Double)
        
    func play(_ id: String?)
    
    func stop()
    
    func pause()
    
    func next()
    
    func back()
}
