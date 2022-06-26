//
//  Gobal.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

let Domain: String = "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss"

let MediaFormater: DateFormatter = {
    let fo = DateFormatter()
    fo.dateFormat = "YYYY/MM/dd"
    return fo
}()
