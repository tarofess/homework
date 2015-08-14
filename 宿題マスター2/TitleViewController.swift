//
//  TitleViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController: UIViewController {
    @IBOutlet weak var currentUsersImage: UIImageView!
    @IBOutlet weak var fireImageView: UIImageView!
    
    let model = TitleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var animationSeq = [
            UIImage(named: "fire001.png")!,
            UIImage(named: "fire002.png")!,
            UIImage(named: "fire003.png")!,
            UIImage(named: "fire004.png")!,
            UIImage(named: "fire005.png")!,
            UIImage(named: "fire006.png")!,
            UIImage(named: "fire007.png")!,
            UIImage(named: "fire008.png")!,
            UIImage(named: "fire009.png")!,
            UIImage(named: "fire010.png")!,
            UIImage(named: "fire011.png")!,
            UIImage(named: "fire012.png")!,
            UIImage(named: "fire013.png")!,
            UIImage(named: "fire014.png")!,
            UIImage(named: "fire015.png")!
        ]
        fireImageView.animationImages = animationSeq
        fireImageView.animationDuration = 1.2
        fireImageView.animationRepeatCount = 0
        fireImageView.startAnimating()
        
        self.showUsersImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showUsersImage() {
        let imageManagement = ImageManagement()
        self.currentUsersImage.image = imageManagement.showUsersImage()
        
//        var usersScore = 0
//        var userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
//        
//        let dbModel = DBModel()
//        usersScore = dbModel.getSpecificUsersScore(userName)
//        
//        println("userName: \(userName)  userScore: \(usersScore)")
//        
//        let imageManagement = ImageManagement()
//        self.currentUsersImage.image = imageManagement.showUsersImage(usersScore)
    }
    
    // MARK: - segue
    
    @IBAction func unwindAction(segue: UIStoryboardSegue) {}
}

