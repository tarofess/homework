//
//  ViewController.swift
//  宿題マスター2
//
//  Created by taro on 2015/07/26.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var successAuthLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let model = ViewModel()
    var txtActiveField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNotification()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.successAuthLabel.hidden = true
        self.userNameTextField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - notification
    
    func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo =  notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            self.view.frame.origin.y -= txtLimit - kbdLimit
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - textField

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var isSuccessAuth = model.authUser(textField.text)
        
        if isSuccessAuth {
            successAuthLabel.hidden = false
            let userDefault =  NSUserDefaults.standardUserDefaults()
            userDefault.setObject(textField.text, forKey: "userName")
            userDefault.synchronize()
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("RunTitleViewController", sender: self)
            }
        } else {
            successAuthLabel.hidden = true
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        txtActiveField = textField
        
        return true
    }
}

