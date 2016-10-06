//
//  TimerViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class TimerViewController: UIViewController {
    
    @IBOutlet weak var completionLabel: UIButton!
    @IBOutlet weak var operateTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bannerView3: GADBannerView!
    
    let timerModel = TimerModel()
    var timer: Timer!
    var isTimerStopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - buttonAction
    
    @IBAction func tappedCompletionLabel(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "どうしよう？", message: "パワーアップさせよう！", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "はい！", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "RunPowerUpViewController", sender: nil)
        })
        let ngAction = UIAlertAction(title: "いいえ！", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func operateTimer(_ sender: AnyObject) {
        if isTimerStopped {
            operateTimerButton.setTitle("ストップ！", for: UIControlState())
            completionLabel.isHidden = true
            isTimerStopped = false
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.updateWithTimer), userInfo: nil, repeats: true)
        } else {
            operateTimerButton.setTitle("スタート！", for: UIControlState())
            completionLabel.isHidden = false
            isTimerStopped = true
            
            timer.invalidate()
        }
    }
    
    // MARK: - timerProcess
    
    func updateWithTimer() {
        if timerModel.minusTimeAndPoint() {
            timer.invalidate()
            performSegue(withIdentifier: "RunGameOverViewController", sender: nil)
        }
        timerLabel.text = timerModel.getTimeForTimerLabel()
        pointLabel.text = "（" + timerModel.point.description + "ポイント）"
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserManager.sharedManager.currentUserScore = UserManager.sharedManager.currentUser.score + timerModel.point
        UserManager.sharedManager.screenType = ScreenType.BeforeEvolution
    }
    
    @IBAction func unwindToTimerViewController(_ segue: UIStoryboardSegue) {}
    
    // MARK: Ad
    
    func setAd() {
        bannerView3.load(GADRequest())
    }
    
}

