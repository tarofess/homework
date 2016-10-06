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
import RealmSwift

class PowerUpViewController: UIViewController {
    
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var currentPowerLabel: UILabel!
    @IBOutlet weak var nextLevelUpLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearLabel: UILabel!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showUpUIAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PowerUpViewController.tappedScreen(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tappedScreen(_ sender: UITapGestureRecognizer) {
        shiningViewAnimation()
        self.view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    func shiningViewAnimation() {
        UserManager.sharedManager.screenType = ScreenType.PowerUP
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.backgroundColor = UIColor.black
            }, completion: { finished in
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.view.backgroundColor = UIColor.white
                    self.showUpUIAppearance()
                }
        })
    }
    
    func showUpUIAppearance() {
        usersImage.image = UserManager.sharedManager.getCharacterImageAndName().image
        
        var hidden: Bool!
        
        switch UserManager.sharedManager.screenType! {
        case .Confirmation:
            hidden = false
            setCharacterInfomation()
        case .BeforeEvolution:
            hidden = true
            setTapGestureRecognizer()
        case .PowerUP:
            hidden = false
            saveCharacterInfomation()
            powerUp()
            setCharacterInfomation()
        }
        
        characterName.isHidden = hidden
        currentPowerLabel.isHidden = hidden
        nextLevelUpLabel.isHidden = hidden
        backButton.isHidden = hidden
        
        if UserManager.sharedManager.getRestOfPowerForNextLevelUp() > 2700 {
            currentPowerLabel.isHidden = true
            nextLevelUpLabel.isHidden = true
        }
    }
    
    func powerUp() {
        if UserManager.sharedManager.getRestOfPowerForNextLevelUp() > 2700 {
            clearLabel.isHidden = false
            characterName.text = UserManager.sharedManager.getCharacterImageAndName().name
            playSound("clear", type: "mp3")
        } else {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "id = %@", UserManager.sharedManager.currentUser.id)
            let currentCharacter = realm.objects(User.self).filter(predicate).map{$0}
            
            if currentCharacter.first!.characterName == UserManager.sharedManager.getCharacterImageAndName().name {
                playSound("up", type: "wav")
            } else {
                playSound("levelup", type: "mp3")
            }
        }
    }
    
    func setCharacterInfomation() {
        usersImage.image = UserManager.sharedManager.getCharacterImageAndName().image
        characterName.text = UserManager.sharedManager.getCharacterImageAndName().name
        
        if UserManager.sharedManager.getRestOfPowerForNextLevelUp() < 2700 {
            currentPowerLabel.text = "今のパワー　" + String(UserManager.sharedManager.currentUser.score)
            nextLevelUpLabel.text = "レベルアップまであと　" + String(UserManager.sharedManager.getRestOfPowerForNextLevelUp())
        }
    }
    
    func saveCharacterInfomation() {
        UserManager.sharedManager.updateUser(UserManager.sharedManager.currentUserScore, name: UserManager.sharedManager.getCharacterImageAndName().name)
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
        switch UserManager.sharedManager.screenType! {
        case ScreenType.Confirmation:
            dismiss(animated: true, completion: nil)
        case ScreenType.PowerUP:
            showBackAlert()
        default:
            break
        }
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
