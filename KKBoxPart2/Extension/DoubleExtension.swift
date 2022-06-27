//
//  DoubleExtension.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/27.
//

import UIKit

extension Double {
    var getMinAndSec: String {
        let timeInterval = self
        var timeInt: Int
        
        if timeInterval >= Double(Int.max) || timeInterval <= Double(Int.min) {
            timeInt = 0
        } else if timeInterval < 0 {
            timeInt = 0
        } else {
            timeInt = Int(timeInterval)
        }
        
        let seconds = timeInt % 60
        let minutes = timeInt / 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
