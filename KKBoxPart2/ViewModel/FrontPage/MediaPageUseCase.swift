//
//  MediaPageUseCase.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/25.
//

import Foundation

protocol MediaPageUseCase {
    func play(_ mediaInfo: PlayerMediaInfo, fullList list: [PlayerMediaInfo])
}
