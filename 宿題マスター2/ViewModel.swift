//
//  ViewModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class ViewModel {
    var userID: [Int] = []
    var userName: [String] = []

    func authUser(aUserName: String) -> Bool {
        let dbModel = DBModel()
        userID = dbModel.getUser().userID
        userName = dbModel.getUser().userName
        
        var user: Array<String>? = dbModel.getUser().userName
        
        for userStore in user! {
            if aUserName == userStore {
                return true
            }
        }
        
        return false
    }
    
    func getUserID(aUserName: String) -> Int {
        var index = find(userName, aUserName)
        return self.userID[index!]
    }
}