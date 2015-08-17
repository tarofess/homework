//
//  PowerUpModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class PowerUpModel {
    
    func saveData(aUserName: String, aScore: Int, aCharacterName: String) {
        let dbModel = DBModel()
        dbModel.updateScore(aUserName, aNewScore: aScore, aCharacterName: aCharacterName)
    }
    
    func getUsersCurrentPower() -> Int {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let dbModel = DBModel()
        
        return dbModel.getSpecificUsersData(userDefault.objectForKey("userName") as! String).userScore
    }
    
    func getRestOfPowerForNextLevelUp() -> Int {
        var currentUserScore = self.getUsersCurrentPower()
        
        if currentUserScore <= 200 {
            return 200 - currentUserScore
        } else if currentUserScore > 200 && currentUserScore <= 500 {
            return 500 - currentUserScore
        } else if currentUserScore > 500 && currentUserScore <= 900 {
            return 900 - currentUserScore
        } else if currentUserScore > 900 && currentUserScore <= 1400 {
            return 1400 - currentUserScore
        } else if currentUserScore > 1400 && currentUserScore <= 2000 {
            return 2000 - currentUserScore
        } else if currentUserScore > 2000 && currentUserScore <= 2700 {
            return 2700 - currentUserScore
        } else {
            return 5000
        }
    }
}