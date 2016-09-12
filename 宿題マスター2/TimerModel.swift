//
//  TimerModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class TimerModel {
    
    var secForTimer = 60
    var point = 600
    
    func initSecForTimer() {
        self.secForTimer = 60
    }
    
    func minusTimeAndPoint() -> Bool{
        if point < 1 {
            return true
        }
        if secForTimer < 1 {
            self.initSecForTimer()
        }
        secForTimer -= 1
        point -= 1
        
        return false
    }
    
    func getTimeForTimerLabel() -> String {
        let min = point / 60
        let minString = min.description
        let sec = secForTimer
        let secString = sec.description
        
        if min < 10 {
            if sec < 10 {
                return "0" + minString + ":" + "0" + secString
            } else {
                return "0" + minString + ":" + secString
            }
        } else {
            return minString + ":" + secString
        }
    }
    
}