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
    var users = [User]()
    var indexPath: IndexPath!
    let realm = try! Realm()
    
    fileprivate override init() {}
    
    func getUserFromDB() {
        users = realm.objects(User.self).map{$0}
    }
    
    func insertUser(_ user: User) {
        try! realm.write({
            realm.add(user)
        })
    }
    
    func updateUser(_ score: Int, name: String) {
        let realm = try! Realm()
        try! realm.write({
            UserManager.sharedManager.users[indexPath.row].score = score
            UserManager.sharedManager.users[indexPath.row].characterName = name
        })
    }
    
    func deleteUser(_ user: User) {
        try! realm.write({
            realm.delete(user)
        })
    }
    
    func getCharacterImageAndName() -> (image: UIImage, name: String) {
        let usersScore = UserManager.sharedManager.users[indexPath.row].score
        
        if usersScore <= 200 {
            return (UIImage(named: "baby.png")!, "あかちゃん")
        } else if usersScore > 200 && usersScore <= 500 {
            return (UIImage(named: "soccer.png")!, "サッカープレイヤー")
        } else if usersScore > 500 && usersScore <= 900 {
            return (UIImage(named: "ninja.png")!, "ニンジャ")
        } else if usersScore > 900 && usersScore <= 1400 {
            return (UIImage(named: "gun.png")!, "ガンマン")
        } else if usersScore > 1400 && usersScore <= 2000 {
            return (UIImage(named: "magic.png")!, "まほうつかい")
        } else if usersScore > 2000 && usersScore <= 2700 {
            return (UIImage(named: "wiseman.png")!, "かみさま")
        } else {
            return (UIImage(named: "hero")!, "さいきょうのヒーロー")
        }
    }

}
