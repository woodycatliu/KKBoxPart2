//
//  Media.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation

struct Media: PlayerMediaInfo {
    
    var id: String = UUID().uuidString
    
    var link: String
    
    var title: String?
    
    var albumTitle: String?
    
    var imageData: Data?
    
    var remoteImage: URL?
    
    var artist: String?
    
    var date: Date

    
}