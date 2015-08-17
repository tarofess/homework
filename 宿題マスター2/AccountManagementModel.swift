//
//  AccountManagementModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class AccountManagementModel {
     var userName: [String] = []
     var userScore: [Int] = []
    var userCharacter:[String] = []
    
    init() {
        let dbModel = DBModel()
        userName = dbModel.getUser().userName
        userScore = dbModel.getUser().score
        userCharacter = dbModel.getUser().characterName
    }
    
    func getUserName() -> [String] {
        return self.userName
    }
    
    func setUserName(aUserName: String) {
        self.userName.append(aUserName)
    }
}