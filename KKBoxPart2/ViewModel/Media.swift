//
//  Media.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation

struct Media: PlayerMediaInfo {
    
    var id: String = UUID().uuidString
    
    var mp3: String
    
    var title: String?
    
    var albumTitle: String?
    
    var imageData: Data?
    
    var remoteImage: URL?
    
    var artist: String?
    
    var date: Date

}

struct MediaCellViewModel: CellViewModelProtocol {
    var identifier: String {
        return MediaInfoCell.description()
    }
    var media: Media
}
