//
//  ModernConfig.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import ModernAVPlayer
import AVFoundation


struct ModernConfig: PlayerConfiguration {
    
    // Buffering State
    let rateObservingTimeout: TimeInterval = 3
    let rateObservingTickTime: TimeInterval = 0.3

    let preferredTimescale = CMTimeScale(NSEC_PER_SEC)
    let periodicPlayingTime: CMTime
    let audioSessionCategory = AVAudioSession.Category.playback
    let audioSessionCategoryOptions: AVAudioSession.CategoryOptions = []

    // Reachability Service
    let reachabilityURLSessionTimeout: TimeInterval = 3
    //swiftlint:disable:next force_unwrapping
    let reachabilityNetworkTestingURL = URL(string: "https://www.google.com")!
    let reachabilityNetworkTestingTickTime: TimeInterval = 3
    let reachabilityNetworkTestingIteration: UInt = 10

    // RemoteCommandExample is used for example
    var useDefaultRemoteCommand = true
    
    let allowsExternalPlayback = true

    // AVPlayerItem Init Service
    let itemLoadedAssetKeys = ["playable", "duration"]

    init() {
        periodicPlayingTime = CMTime(seconds: 0.1, preferredTimescale: preferredTimescale)
    }
    
}
