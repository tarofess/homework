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
    
    let model = PowerUpModel()
    var userScore = 0
    var characterNameStore = ""
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
                    self.isWantToShowLabels = true
                    self.showUpUIAppearance()
                    self.showAfterPowerUpImageAndName()
                    self.setPowerValueToLavel()
                    self.saveData()
                }
        })
    }
    
    func showUsersImage() {
        let imageManagement = ImageManagement()
        self.usersImage.image = imageManagement.showUsersImageAndName().characterImage
    }
    
    func saveData() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        model.saveData(userDefault.objectForKey("userName") as! String, aScore: userScore, aCharacterName: self.characterName.text!)
    }
    
    func showUpUIAppearance() {
        if !self.isWantToShowLabels {
            self.setTapGestureRecognizer()
        } else {
            self.characterName.text = characterNameStore
            self.currentPowerLabel.text = "今のパワー　" + String(model.getUsersCurrentPower())
            self.nextLevelUpLabel.text = "レベルアップまであと　" + String(model.getRestOfPowerForNextLevelUp())
        }
        self.characterName.hidden = !self.isWantToShowLabels
        self.currentPowerLabel.hidden = !self.isWantToShowLabels
        self.nextLevelUpLabel.hidden = !self.isWantToShowLabels
        self.backButton.hidden = !self.isWantToShowLabels
    }
    
    func setPowerValueToLavel() {
        if model.getRestOfPowerForNextLevelUp() == 5000 {
            self.currentPowerLabel.hidden = true
            self.nextLevelUpLabel.hidden = true
            self.clearLabel.hidden = false
            self.playSound("clear", type: "mp3")
        } else {
            self.currentPowerLabel.text = "今のパワー　" + String(model.getUsersCurrentPower())
            self.nextLevelUpLabel.text = "レベルアップまであと　" + String(model.getRestOfPowerForNextLevelUp())
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let dbModel = DBModel()
            var character = dbModel.getSpecificUsersData(userDefault.objectForKey("userName") as! String).userCharacter
            
            if self.characterName.text! == character {
                self.playSound("up", type: "wav")
            } else {
                self.playSound("levelup", type: "mp3")
            }
        }
    }
    
    func showAfterPowerUpImageAndName() {
        let imageManagement = ImageManagement()
        self.usersImage.image = imageManagement.showUsersImageAndName().characterImage
        self.characterName.text = imageManagement.showUsersImageAndName().characterName
    }
    
    func playSound(path: String, type: String) {
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(path, ofType: type)!)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
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

