//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Laurent Nicolas on 6/12/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var deleteToolbar: UIToolbar!
    @IBOutlet weak var deleteButtonOutlet: UIBarButtonItem!
    
    var memedImage: UIImage!
    var index: Int!
    
    override func viewWillAppear(animated: Bool) {
        detailImageView.image = memedImage
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = true
    }
    
    // Mark - actions
    
    @IBAction func addAction(sender: UIBarButtonItem) {
        pushMemeEditorVC()
    }
    
    @IBAction func deleteButton(sender: UIBarButtonItem) {
        // removing the meme, not deleting the image

        let alert = UIAlertController(title: "Delete Meme", message: "really?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: deleteMeme)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteMeme(action: UIAlertAction!) -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(index)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }

}
