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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startFireAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.showUsersImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startFireAnimation() {
        let animationSeq = [
            UIImage(named: "fire001")!,
            UIImage(named: "fire002")!,
            UIImage(named: "fire003")!,
            UIImage(named: "fire004")!,
            UIImage(named: "fire005")!,
            UIImage(named: "fire006")!,
            UIImage(named: "fire007")!,
            UIImage(named: "fire008")!,
            UIImage(named: "fire009")!,
            UIImage(named: "fire010")!,
            UIImage(named: "fire011")!,
            UIImage(named: "fire012")!,
            UIImage(named: "fire013")!,
            UIImage(named: "fire014")!,
            UIImage(named: "fire015")!
        ]
        fireImageView.animationImages = animationSeq
        fireImageView.animationDuration = 1.2
        fireImageView.animationRepeatCount = 0
        fireImageView.startAnimating()
    }
    
    func showUsersImage() {
        self.currentUsersImage.image = UserManager.sharedManager.getCharacterImageAndName().image
    }
    
}

