//
//  PowerUpViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PowerUpViewController: UIViewController {
    
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var currentPowerLabel: UILabel!
    @IBOutlet weak var nextLevelUpLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearLabel: UILabel!
    
    let powerUpModel = PowerUpModel()
    var user: User!
    var isWantToShowLabels = false
    var tapGestureRecognizer: UITapGestureRecognizer!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showUsersImage()
        self.showUpUIAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTapGestureRecognizer() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PowerUpViewController.tappedScreen(_:)))
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
                    self.isWantToShowLabels = true
                    self.showUpUIAppearance()
                    self.showAfterPowerUpImageAndName()
                    self.setPowerValueToLavel()
                }
        })
    }
    
    func showUsersImage() {
        self.usersImage.image = UserManager.sharedManager.getCharacterImageAndName().image
    }
    
    func showUpUIAppearance() {
        if !self.isWantToShowLabels {
            self.setTapGestureRecognizer()
        } else {
            if powerUpModel.getRestOfPowerForNextLevelUp() > 2700 {
                self.currentPowerLabel.text = ""
                self.nextLevelUpLabel.text = ""
                self.characterName.text = user.characterName
            } else {
                self.characterName.text = user.characterName
                self.currentPowerLabel.text = "今のパワー　" + String(user.score)
                self.nextLevelUpLabel.text = "レベルアップまであと　" + String(powerUpModel.getRestOfPowerForNextLevelUp())
            }
        }
        self.characterName.hidden = !self.isWantToShowLabels
        self.currentPowerLabel.hidden = !self.isWantToShowLabels
        self.nextLevelUpLabel.hidden = !self.isWantToShowLabels
        self.backButton.hidden = !self.isWantToShowLabels
    }
    
    func setPowerValueToLavel() {
        if powerUpModel.getRestOfPowerForNextLevelUp() > 2700 {
            self.currentPowerLabel.hidden = true
            self.nextLevelUpLabel.hidden = true
            self.clearLabel.hidden = false
            self.playSound("clear", type: "mp3")
        } else {
            self.currentPowerLabel.text = "今のパワー　" + String(user.score)
            self.nextLevelUpLabel.text = "レベルアップまであと　" + String(powerUpModel.getRestOfPowerForNextLevelUp())

            let character = user.characterName
            
            if user.characterName == character {
                self.playSound("up", type: "wav")
            } else {
                self.playSound("levelup", type: "mp3")
            }
        }
    }
    
    func showAfterPowerUpImageAndName() {
        self.usersImage.image = UserManager.sharedManager.getCharacterImageAndName().image
        self.characterName.text = UserManager.sharedManager.getCharacterImageAndName().name
        
        UserManager.sharedManager.updateUser(user.score, name: user.characterName)
    }
    
    func playSound(path: String, type: String) {
        do {
            let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(path, ofType: type)!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch {
            print("error")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func tappedBackButton(sender: AnyObject) {
        self.showBackAlert()
    }
    
    func showBackAlert() {
        let alertController = UIAlertController(title: "どうしよう？", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let startScreenAction = UIAlertAction(title: "最初の画面に戻る！", style: .Default, handler:{ action in
            self.view.removeGestureRecognizer(self.tapGestureRecognizer)
            self.performSegueWithIdentifier("RunViewController", sender: self)
        })
        let doAgainGameAction = UIAlertAction(title: "もう一回やりたい！", style: .Default, handler:{ action in
            self.view.removeGestureRecognizer(self.tapGestureRecognizer)
            self.performSegueWithIdentifier("RunBackTimerViewController", sender: self)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(startScreenAction)
        alertController.addAction(doAgainGameAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
