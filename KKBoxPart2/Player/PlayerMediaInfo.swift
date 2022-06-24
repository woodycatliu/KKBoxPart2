//
//  PodcastMediaInfo.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation

protocol PlayerMediaInfo {
    var id: String { get }
    var link: String { get }
    var title: String? { get }
    var albumTitle: String? { get }
    var imageData: Data? { get }
    var remoteImage: URL? { get }
    var artist: String? { get }
}