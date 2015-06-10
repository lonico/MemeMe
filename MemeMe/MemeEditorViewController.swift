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
    var inited = false
    var memedImage: UIImage!
    
    let memeMeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 2
    ]
    
    override func viewWillAppear(animated: Bool) {
        
        if !inited {
            shareButton.enabled = false
            topTextField.text    = "TOP TEXT"
            bottomTextField.text = "BOTTOM TEXT"
            inited = true
        }
        for textField in [topTextField, bottomTextField] {
            textField.delegate = self
            textField.tag = 0
            textField.defaultTextAttributes = memeMeTextAttributes
            textField.textColor = UIColor.blueColor()
            textField.textAlignment = NSTextAlignment.Center
            //textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
            
        }

        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = false
        self.tabBarController?.hidesBottomBarWhenPushed = true
        cameraButtonImage.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK - textField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 0 {
            textField.text = ""
            textField.tag = 1
        }
    }
    
    // Mark - Button Actions
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        memedImage = generateMemeImage()
        let activities = [memedImage]
        let activityVC = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        activityVC.completionWithItemsHandler = activityVCCompletion
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK - activity VC completion
    
    func activityVCCompletion(activityType: String!, completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) {
        println(returnedItems)
        save()
        self.dismissViewControllerAnimated(true, completion: nil)
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
        // TODO: Hide toolbar and navbar
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.toolbarHidden = false
        self.navigationController?.navigationBarHidden = false
        
        return memedImage
    }
}