//
//  DBHelper.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class DBModel {
    let realm = RLMRealm.defaultRealm()
    private var autoIncrementID = 0
    
    // MARK: - create
    
    func insertUser(aUserName: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        autoIncrementID = ud.integerForKey("autoIncrementKey")
        
        let user = User()
        user.id = autoIncrementID
        user.userName = aUserName
        user.characterName = "あかちゃん"
        
        realm.transactionWithBlock({ () -> Void in
            self.realm.addObject(user)
        })
        autoIncrementID++
        
        ud.setInteger(autoIncrementID, forKey: "autoIncrementKey")
    }
    
    // MARK: - read
    
    func getUser() -> (userID: [Int], userName: [String], score: [Int], characterName: [String]) {
        var userIDArray: [Int] = []
        var userNameArray: [String] = []
        var scoreArray: [Int] = []
        var characterNameArray: [String] = []
        
        let users = User.allObjects()
        
        for item in users {
            var user = item as! User
            userIDArray.append(user.id)
            userNameArray.append(user.userName)
            scoreArray.append(user.score)
            characterNameArray.append(user.characterName)
        }
        
        return (userIDArray, userNameArray, scoreArray, characterNameArray)
    }
    
    func getSpecificUsersData(aUserID: Int) -> (userID: Int, userName: String, userScore: Int, userCharacter: String) {
        var userID = 0
        var userName = ""
        var userScore = 0
        var userCharacter = ""
        var user = User.objectsWhere("id == %d", aUserID)
        
        for item in user {
            var specificUser = item as! User
            userID = specificUser.id
            userName = specificUser.userName
            userScore = specificUser.score
            userCharacter = specificUser.characterName
        }
        
        return (userID, userName, userScore, userCharacter)
    }
    
    // MARK: - update
    
    func updateScore(aUserID: Int, aNewScore: Int, aCharacterName: String) {
        let user = User()
        var userOldScore = self.getSpecificUsersData(aUserID).userScore
        user.id = aUserID
        user.userName = self.getSpecificUsersData(aUserID).userName
        user.score = userOldScore + aNewScore
        user.characterName = aCharacterName
        
        realm.transactionWithBlock({ () -> Void in
            self.realm.addOrUpdateObject(user)
        })
    }
    
    // MARK: - delete
    
    func deleteUser(aUserID: Int) {
        realm.transactionWithBlock( { () -> Void in
            self.realm.deleteObjects(User.objectsWhere("id == %d", aUserID))
        })
    }
    
    // MARK: - searchIfRegisterSameUserName
    
    func hasSameUserNameInDatabase(aUserName: String) -> Bool {
        let users = User.allObjects()
        
        for item in users {
            var user = item as! User
            
            if aUserName == user.userName {
                return true
            }
        }
        
        return false
    }
    
    func getAutoIncrementID() -> Int {
        return self.autoIncrementID
    }
}
