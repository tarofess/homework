//
//  ViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var successAuthLabel: UILabel!
    @IBOutlet weak var managementAccountButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func authorizeUser() -> Bool {
        let realm = try! Realm()
        let users = realm.objects(User).filter("name = %@", userNameTextField.text!)
        
        if users.count == 0 {
            return false
        } else {
            UserManager.sharedManager.currentUser = users.first!
            
            return true
        }
    }
    
    // MARK: - textField

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if authorizeUser() {
            self.successAuthLabel.hidden = false
            self.managementAccountButton.enabled = false
            self.userNameTextField.enabled = false
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("RunTitleViewController", sender: self)
            }
            
            self.view.userInteractionEnabled = false
        }
        
        return true
    }
    
}

