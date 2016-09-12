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
    var timer: NSTimer!
    var isTimerStopped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - buttonAction
    
    @IBAction func tappedCompletionLabel(sender: AnyObject) {
        let alertController = UIAlertController(title: "どうしよう？", message: "パワーアップさせよう！", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "はい！", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("RunPowerUpViewController", sender: nil)
        })
        let ngAction = UIAlertAction(title: "いいえ！", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func operateTimer(sender: AnyObject) {
        if self.isTimerStopped {
            self.operateTimerButton.setTitle("ストップ！", forState: UIControlState.Normal)
            self.completionLabel.hidden = true
            self.isTimerStopped = false
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerViewController.updateWithTimer), userInfo: nil, repeats: true)
        } else {
            self.operateTimerButton.setTitle("スタート！", forState: UIControlState.Normal)
            self.completionLabel.hidden = false
            self.isTimerStopped = true
            
            self.timer.invalidate()
        }
    }
    
    // MARK: - timerProcess
    
    func updateWithTimer() {
        if timerModel.minusTimeAndPoint() {
            self.timer.invalidate()
            performSegueWithIdentifier("RunGameOverViewController", sender: nil)
        }
        self.timerLabel.text = timerModel.getTimeForTimerLabel()
        self.pointLabel.text = "（" + timerModel.point.description + "ポイント）"
    }
    
    // MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserManager.sharedManager.currentUser.score = timerModel.point
    }
    
    @IBAction func unwindToTimerViewController(segue: UIStoryboardSegue) {}
    
}

