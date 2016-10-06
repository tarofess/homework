//
//  ViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var successAuthLabel: UILabel!
    @IBOutlet weak var managementAccountButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.endIgnoringInteractionEvents()
        userNameTextField.text = ""
        successAuthLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func authorizeUser() -> Bool {
        let realm = try! Realm()
        let users = realm.objects(User.self).filter("name = %@", userNameTextField.text!)
        
        if users.count == 0 {
            return false
        } else {
            UserManager.sharedManager.currentUser = users.first!
            
            return true
        }
    }
    
    // MARK: - textField

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if authorizeUser() {
            successAuthLabel.isHidden = false
            
            let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.performSegue(withIdentifier: "RunTitleViewController", sender: self)
            }
            
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        return true
    }
    
    // MARK:- Ad
    
    func setAd() {
        bannerView.load(GADRequest())
    }
    
}

