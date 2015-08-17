//
//  ImageManagement.swift
//  宿題マスター2
//
//  Created by taro on 2015/08/13.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class ImageManagement: NSObject {
    func showUsersImageAndName() -> (characterImage: UIImage, characterName: String) {
        var usersScore = 0
        var userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
        
        let dbModel = DBModel()
        usersScore = dbModel.getSpecificUsersData(userName).userScore
        
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