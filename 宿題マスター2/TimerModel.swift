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
    
    func minusTimeAndPoint() -> Bool{
        if self.point < 1 {
            return true
        }
        if self.secForTimer < 1 {
            self.secForTimer = 60
        }
        self.secForTimer--
        self.point--
        
        return false
    }
    
    func getTimeForTimerLabel() -> String {
        var min = self.point / 60
        var minString = min.description
        var sec = self.secForTimer
        var secString = sec.description
        
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