//
//  AccountManagementViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds

class AccountManagementViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var okAction: UIAlertAction!
    @IBOutlet weak var bannerView2: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
        
        let realm = try! Realm()
        print(realm.objects(User.self))
        
//        let realm = try! Realm()
//        let user = User()
//        user.name = "テスト"
//        try! realm.write {
//            realm.add(user)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.sharedManager.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = UserManager.sharedManager.users[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAtIndexPath indexPath:IndexPath) {
        performSegue(withIdentifier: "RunPowerUpViewController",sender: UserManager.sharedManager.users[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath!){
        if(editingStyle == UITableViewCellEditingStyle.delete){
            let alertController = UIAlertController(title: "アカウントの削除！", message: "このアカウントを削除しちゃう？", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "はい！", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) -> Void in
                UserManager.sharedManager.deleteUser(UserManager.sharedManager.users[indexPath.row])
                UserManager.sharedManager.users.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            })
            let ngAction = UIAlertAction(title: "いいえ！", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(ngAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBAction

    @IBAction func addNewUser(_ sender: AnyObject) {
        self.showAddNewUserAlert()
    }
    
    // MARK: - alertController
    
    func showAddNewUserAlert() {
        let alert:UIAlertController = UIAlertController(title:"登録！", message: "名前を入力してね！", preferredStyle: UIAlertControllerStyle.alert)
        okAction = UIAlertAction(title: "これにする！", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            
            if self.checkHasSameUserNameInDatabase(textField.text!) {
                let user = User()
                user.name = textField.text!
                UserManager.sharedManager.insertUser(user)
                UserManager.sharedManager.users.append(user)
                
                let indexPath = IndexPath(row: UserManager.sharedManager.users.count - 1, section: 0)
                print((indexPath as NSIndexPath).row)
                self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } else {
                self.showFailureAlert()
            }
        })

        let cancelAction:UIAlertAction = UIAlertAction(title: "やーめた！",
            style: UIAlertActionStyle.cancel, handler:{
                (action:UIAlertAction!) -> Void in
        })
        okAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "名前！"
            text.delegate = self
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showFailureAlert() {
        let alertController = UIAlertController(title: "同じ名前が登録されてるよ！", message: "違う名前を入力してね！", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "わかった!", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> Void in
            self.showAddNewUserAlert()
        })
        let ngAction = UIAlertAction(title: "いやだ！", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) -> Void in
            self.showFailureAlert()
        })
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkHasSameUserNameInDatabase(_ name: String!) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@", name) 
        let users = realm.objects(User.self).filter(predicate)
        
        if users.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string.characters.count == 0 {
            okAction.isEnabled = false
        } else {
            okAction.isEnabled = true
        }
        
        return true
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let powerUpVC = segue.destination as! PowerUpViewController
        let user = sender as! User
        powerUpVC.user = user
        powerUpVC.isWantToShowLabels = true
    }
    
    // MARK: - Ad
    
    func setAd() {
        bannerView2.load(GADRequest())
        
        let gadRequest: GADRequest = GADRequest()
        gadRequest.testDevices = ["35813d541edaeba54769a1516fc90516"]
    }
    
}

