//
//  PodcastMediaInfo.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation

protocol PlayerMediaInfo {
    var id: String { get }
    var mp3: String { get }
    var title: String? { get }
    var albumTitle: String? { get }
    var imageData: Data? { get }
    var remoteImage: URL? { get }
    var artist: String? { get }
    var date: Date { get }
}

protocol AlbumMediaInfo {
    var title: String? { get }
    var image: String? { get }
}


