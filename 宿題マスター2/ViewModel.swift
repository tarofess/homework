//
//  ViewModel.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class ViewModel {

    func authUser(userName: String) -> Bool {
        let dbModel = DBModel()
        var user: Array<String>? = dbModel.getUser().userName
        
        for userStore in user! {
            if userName == userStore {
                return true
            }
        }
        
        return false
    }
}