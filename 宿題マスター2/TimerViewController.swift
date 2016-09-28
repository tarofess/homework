//
//  TimerViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var completionLabel: UIButton!
    @IBOutlet weak var operateTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    let timerModel = TimerModel()
    var timer: Timer!
    var isTimerStopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if self.isTimerStopped {
            self.operateTimerButton.setTitle("ストップ！", for: UIControlState())
            self.completionLabel.isHidden = true
            self.isTimerStopped = false
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.updateWithTimer), userInfo: nil, repeats: true)
        } else {
            self.operateTimerButton.setTitle("スタート！", for: UIControlState())
            self.completionLabel.isHidden = false
            self.isTimerStopped = true
            
            self.timer.invalidate()
        }
    }
    
    // MARK: - timerProcess
    
    func updateWithTimer() {
        if timerModel.minusTimeAndPoint() {
            self.timer.invalidate()
            performSegue(withIdentifier: "RunGameOverViewController", sender: nil)
        }
        self.timerLabel.text = timerModel.getTimeForTimerLabel()
        self.pointLabel.text = "（" + timerModel.point.description + "ポイント）"
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserManager.sharedManager.users[UserManager.sharedManager.indexPath.row].score = timerModel.point
    }
    
    @IBAction func unwindToTimerViewController(_ segue: UIStoryboardSegue) {}
    
}

