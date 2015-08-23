//
//  AccountManagementModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class AccountManagementModel {
    private var userID: [Int] = []
    private var userName: [String] = []
    private var userScore: [Int] = []
    private var userCharacter:[String] = []
    
    init() {
        let dbModel = DBModel()
        userID = dbModel.getUser().userID
        userName = dbModel.getUser().userName
        userScore = dbModel.getUser().score
        userCharacter = dbModel.getUser().characterName
    }
    
    func getUserID() -> [Int] {
        return self.userID
    }
    
    func getUserName() -> [String] {
        return self.userName
    }
    
    func getUserScore() -> [Int] {
        return self.userScore
    }
    
    func getUserCharacter() -> [String] {
        return self.userCharacter
    }
    
    func setUserID(aUserID: Int) {
        self.userID.append(aUserID)
    }
    
    func setUserName(aUserName: String) {
        self.userName.append(aUserName)
    }
    
    func setUserScore(aUserScore: Int) {
        self.userScore.append(aUserScore)
    }
    
    func setUserCharacter(aUserCharacter: String) {
        self.userCharacter.append(aUserCharacter)
    }
    
    func removeUserID(aIndexPath: Int) {
        self.userID.removeAtIndex(aIndexPath)
    }
    
    func removeUserName(aIndexPath: Int) {
        self.userName.removeAtIndex(aIndexPath)
    }
    
    func removeUserScore(aIndexPath: Int) {
        self.userScore.removeAtIndex(aIndexPath)
    }
    
    func removeUserCharacter(aIndexPath: Int) {
        self.userCharacter.removeAtIndex(aIndexPath)
    }
}