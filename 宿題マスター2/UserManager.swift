//
//  UserManager.swift
//  宿題マスター2
//
//  Created by taro on 2016/09/12.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import RealmSwift

enum ScreenType {
    case Confirmation
    case BeforeEvolution
    case PowerUP
}

class UserManager: NSObject {
    
    static let sharedManager = UserManager()
    var users = [User]()
    let realm = try! Realm()
    var currentUser: User!
    var currentUserScore: Int!
    var screenType: ScreenType!
    
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
            currentUser.score = score
            currentUser.characterName = name
        })
    }
    
    func deleteUser(_ user: User) {
        try! realm.write({
            realm.delete(user)
        })
    }
    
    func getCharacterImageAndName() -> (image: UIImage, name: String) {
        let usersScore = currentUser.score
        
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
    
    func getRestOfPowerForNextLevelUp() -> Int {
        let userScore = currentUser.score
        
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
