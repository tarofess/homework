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
        
        realm.transactionWithBlock({ () -> Void in
            self.realm.addObject(user)
        })
        autoIncrementID++
        
        ud.setInteger(autoIncrementID, forKey: "autoIncrementKey")
    }
    
    // MARK: - read
    
    func getUser() -> (userName: [String], score: [Int]) {
        var userNameArray: [String] = []
        var scoreArray: [Int] = []
        
        let users = User.allObjects()
        
        for item in users {
            var user = item as! User
            userNameArray.append(user.userName)
            scoreArray.append(user.score)
        }
        
        return (userNameArray, scoreArray)
    }
    
    func getSpecificUsersScore(aUserName: String) -> Int {
        var userScore = 0
        var user = User.objectsWhere("userName == %@", aUserName)
        
        for item in user {
            var specificUser = item as! User
            userScore = specificUser.score
        }
        
        return userScore
    }
    
//    func getAllUserName() -> [String] {
//        var userArray: [String] = []
//        let users = User.allObjects()
//        
//        for item in users {
//            var user = item as! User
//            userArray.append(user.userName)
//        }
//        
//        return userArray
//    }
    
    // MARK: - update
    
    func updateScore(aUserName: String, aNewScore: Int) {
        let user = User()
        user.userName = aUserName
        user.score = aNewScore
        
        realm.transactionWithBlock({ () -> Void in
            self.realm.addOrUpdateObject(user)
        })
    }
    
    // MARK: - delete
    
    func deleteUser(aUserName: String) {
        realm.transactionWithBlock( { () -> Void in
            self.realm.deleteObjects(User.objectsWhere("userName == %@", aUserName))
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
}
