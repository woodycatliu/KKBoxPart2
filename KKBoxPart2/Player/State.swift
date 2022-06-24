//
//  PlayerState.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation

enum PlayerState {
    
    case buffering
    
    case loading
    
    case canPause
    
    case canPlay
        
    case stopped
    
    case end
    
    case failed
    
}

struct PocastPlayState {
    var position: Double
    var duration: Double
    var pocastLink: String
}
