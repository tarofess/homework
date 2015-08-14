//
//  PowerUpViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class PowerUpViewController: UIViewController {
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var currentPowerLabel: UILabel!
    @IBOutlet weak var nextLevelUpLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let model = PowerUpModel()
    var userScore = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTapGestureRecognizer()
        self.showUsersImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTapGestureRecognizer() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedScreen:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tappedScreen(sender: UITapGestureRecognizer) {
        self.shiningViewAnimation()
        self.view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func shiningViewAnimation() {
        UIView.animateWithDuration(0.4, animations: {
            self.view.backgroundColor = UIColor.blackColor()
            }, completion: { finished in
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.view.backgroundColor = UIColor.whiteColor()
                    self.saveData()
                    self.showUpUIAppearance()
                    self.showAfterPowerUpImage()
                }
        })
    }
    
    func showUsersImage() {
        let imageManagement = ImageManagement()
        self.usersImage.image = imageManagement.showUsersImage()
    }
    
    func showAfterPowerUpImage() {
        let imageManagement = ImageManagement()
        self.usersImage.image = imageManagement.showUsersImage()
    }
    
    func showUpUIAppearance() {
        self.characterName.hidden = false
        self.currentPowerLabel.hidden = false
        self.nextLevelUpLabel.hidden = false
        self.backButton.hidden = false
    }
    
    func saveData() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let dbModel = DBModel()
        dbModel.updateScore(userDefault.objectForKey("userName") as! String, aNewScore: userScore)
    }
    
    @IBAction func tappedBackButton(sender: AnyObject) {
        self.showBackAlert()
    }
    
    func showBackAlert() {
        let alertController = UIAlertController(title: "どうしよう？", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let startScreenAction = UIAlertAction(title: "最初の画面に戻る！", style: .Default, handler:{ action in
            self.performSegueWithIdentifier("RunViewController", sender: self)
        })
        let doAgainGameAction = UIAlertAction(title: "もう一回やりたい！", style: .Default, handler:{ action in
            self.performSegueWithIdentifier("UnwindTitleViewController", sender: self)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(startScreenAction)
        alertController.addAction(doAgainGameAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

