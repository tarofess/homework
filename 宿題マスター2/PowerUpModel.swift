//
//  PowerUpModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import RealmSwift

class PowerUpModel {
    
    func saveData(aScore: Int, aCharacterName: String) {
        let realm = try! Realm()
        try! realm.write({
            UserManager.sharedManager.currentUser.score = aScore
            UserManager.sharedManager.currentUser.characterName = aCharacterName
        })
    }
    
    func getRestOfPowerForNextLevelUp() -> Int {
        let userScore = UserManager.sharedManager.currentUser.score
        
        if userScore <= 200 {
            return 200 - userScore
        } else if userScore > 200 && userScore <= 500 {
            return 500 - userScore
        } else if userScore > 500 && userScore <= 900 {
            return 900 - userScore
        } else if userScore > 900 && userScore <= 1400 {
            return 1400 - userScore
        } else if userScore > 1400 && userScore <= 2000 {
            return 2000 - userScore
        } else if userScore > 2000 && userScore <= 2700 {
            return 2700 - userScore
        } else {
            return 5000
        }
    }
    
}