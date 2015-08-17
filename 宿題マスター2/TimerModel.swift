//
//  TimerModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class TimerModel {
    private var secForTimer = 60
    private var point = 600
    
    func getPoint() -> Int {
        return self.point
    }
    
    func setPoint(aPointValueForCalc: Int) {
        self.point += aPointValueForCalc
    }
    
    func getSecForTimer() -> Int {
        return self.secForTimer
    }
    
    func setSecForTimer(aSerForTimerValueForCalc: Int) {
        self.secForTimer += aSerForTimerValueForCalc
    }
    
    func initSecForTimer() {
        self.secForTimer = 60
    }
    
    func minusTimeAndPoint() -> Bool{
        if self.getPoint() < 1 {
            return true
        }
        if self.getSecForTimer() < 1 {
            self.initSecForTimer()
        }
        self.setSecForTimer(-1)
        self.setPoint(-1)
        
        return false
    }
    
    func getTimeForTimerLabel() -> String {
        var min = self.getPoint() / 60
        var minString = min.description
        var sec = self.getSecForTimer()
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