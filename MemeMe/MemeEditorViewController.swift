//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Laurent Nicolas on 6/8/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButtonImage: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    var inited = false
    var memedImage: UIImage!
    // after picking a picture, when calling textField.resignFirstResponder()
    // the observer may notify twice, making sure we don't shift more than once
    var shifted_view = false
    
    let memeMeTextAttributes = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3,
    ]
    
    override func viewWillAppear(animated: Bool) {
        
        for textField in [topTextField, bottomTextField] {
            textField.delegate = self
            textField.tag = 0
            textField.defaultTextAttributes = memeMeTextAttributes
            textField.textAlignment = NSTextAlignment.Center
        }
        if !inited {
            shareButton.enabled = false
            topTextField.text    = "TOP TEXT"
            bottomTextField.text = "BOTTOM TEXT"
            inited = true
        }
        
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = false
        cameraButtonImage.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK - textField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 0 {
            textField.text = ""
            textField.tag = 1
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK - move view when keyboard shows up or is dismissed
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() && !self.shifted_view {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            shifted_view = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() && self.shifted_view {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            shifted_view = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue    // CGRect
        return keyBoardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // Mark - Button Actions
    
    func presentPickerController(type: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        presentPickerController(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        presentPickerController(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        memedImage = generateMemeImage()
        let activities = [memedImage]
        let activityVC = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        activityVC.completionWithItemsHandler = activityVCCompletion
        activityVC.navigationController?.navigationBarHidden = true
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK - activity VC completion handler
    
    func activityVCCompletion(activityType: String!, completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) {
        save()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Mark - UIImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK - meme management (save, generate image)
    
    func save() {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image!, memedImage: memedImage)
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
        
        // add meme to memes array in application delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemeImage() -> UIImage {
        // Hide toolbar and navbar
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = true
        topToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.toolbarHidden = false
        topToolBar.hidden = false
        return memedImage
    }
}
