//
//  AccountManagementViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class AccountManagementViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var defaultAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - tableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.sharedManager.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = UserManager.sharedManager.users[indexPath.row].name
        
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        performSegueWithIdentifier("RunPowerUpViewController",sender: UserManager.sharedManager.users[indexPath.row])
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let alertController = UIAlertController(title: "アカウントの削除！", message: "このアカウントを削除しちゃう？", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "はい！", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
                
                let dbModel = DBModel()
                dbModel.deleteUser(self.model.getUserID()[indexPath.row])
                
                self.model.removeUserID(indexPath.row)
                self.model.removeUserName(indexPath.row)
                self.model.removeUserScore(indexPath.row)
                self.model.removeUserCharacter(indexPath.row)
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let ngAction = UIAlertAction(title: "いいえ！", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alertController.addAction(ngAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBAction

    @IBAction func addNewUser(sender: AnyObject) {
        self.showAddNewUserAlert()
    }
    
    // MARK: - alertController
    
    func showAddNewUserAlert() {
        let alert:UIAlertController = UIAlertController(title:"登録！",
            message: "名前を入力してね！",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel！",
            style: UIAlertActionStyle.Cancel, handler:{
                (action:UIAlertAction!) -> Void in
        })
        self.defaultAction = UIAlertAction(title: "OK！",
            style: UIAlertActionStyle.Default, handler:{ (action:UIAlertAction!) -> Void in
                let textField = alert.textFields![0] as! UITextField
                let dbModel = DBModel()
                
                if !dbModel.hasSameUserNameInDatabase(textField.text) {
                    dbModel.insertUser(textField.text)
                    
                    self.model.setUserID(dbModel.getAutoIncrementID() - 1)
                    self.model.setUserName(textField.text)
                    self.model.setUserScore(0)
                    self.model.setUserCharacter("あかちゃん")
                    let indexPath = NSIndexPath(forRow: count(self.model.getUserName()) - 1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                } else {
                    self.showFailureAlert()
                }
        })
        defaultAction!.enabled = false
        alert.addAction(cancelAction)
        alert.addAction(defaultAction!)
        
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "名前！"
            text.delegate = self
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showFailureAlert() {
        let alertController = UIAlertController(title: "同じ名前が登録されてるよ！", message: "違う名前を入力してね！", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "わかった!", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
            self.showAddNewUserAlert()
        })
        let ngAction = UIAlertAction(title: "いやだ！", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) -> Void in
            self.showFailureAlert()
        })
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(textField.text!.utf16) + count(string.utf16) - range.length
        
        if newLength >= 1 {
            self.defaultAction!.enabled = true
        } else {
            self.defaultAction!.enabled = false
        }
        
        return true
    }
    
    // MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let powerUpVC = segue.destinationViewController as! PowerUpViewController
        let user = sender as! User
        powerUpVC.user = user
        powerUpVC.isWantToShowLabels = true
    }
    
}

