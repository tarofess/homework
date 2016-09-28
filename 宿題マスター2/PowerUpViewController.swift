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
    
    func tappedScreen(_ sender: UITapGestureRecognizer) {
        self.shiningViewAnimation()
        self.view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func shiningViewAnimation() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.backgroundColor = UIColor.black
            }, completion: { finished in
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.view.backgroundColor = UIColor.white
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
        self.characterName.isHidden = !self.isWantToShowLabels
        self.currentPowerLabel.isHidden = !self.isWantToShowLabels
        self.nextLevelUpLabel.isHidden = !self.isWantToShowLabels
        self.backButton.isHidden = !self.isWantToShowLabels
    }
    
    func setPowerValueToLavel() {
        if powerUpModel.getRestOfPowerForNextLevelUp() > 2700 {
            self.currentPowerLabel.isHidden = true
            self.nextLevelUpLabel.isHidden = true
            self.clearLabel.isHidden = false
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
    
    func playSound(_ path: String, type: String) {
        do {
            let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: path, ofType: type)!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch {
            print("error")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func tappedBackButton(_ sender: AnyObject) {
        self.showBackAlert()
    }
    
    func showBackAlert() {
        let alertController = UIAlertController(title: "どうしよう？", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let startScreenAction = UIAlertAction(title: "最初の画面に戻る！", style: .default, handler:{ action in
            self.view.removeGestureRecognizer(self.tapGestureRecognizer)
            self.performSegue(withIdentifier: "RunViewController", sender: self)
        })
        let doAgainGameAction = UIAlertAction(title: "もう一回やりたい！", style: .default, handler:{ action in
            self.view.removeGestureRecognizer(self.tapGestureRecognizer)
            self.performSegue(withIdentifier: "RunBackTimerViewController", sender: self)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(startScreenAction)
        alertController.addAction(doAgainGameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
