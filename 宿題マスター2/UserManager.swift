//
//  UserManager.swift
//  宿題マスター2
//
//  Created by taro on 2016/09/12.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class UserManager: NSObject {
    
    static let sharedManager = UserManager()
    var users = Array<User>()
    var currentUser: User!
    
    private override init() {}
    
    func getUserFromDB() {
        let realm = try! Realm()
        users = realm.objects(User).map{$0}
    }

}
