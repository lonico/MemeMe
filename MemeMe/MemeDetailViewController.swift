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
    var memes = [Meme]()
    var index: Int!
    
    override func viewWillAppear(animated: Bool) {
        detailImageView.image = memes[index].memedImage
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = true
    }
    
    // Mark - actions
    
    @IBAction func addAction(sender: AnyObject) {
        pushMemeEditorVC()
    }
    
    @IBAction func deleteButton(sender: AnyObject) {
        // removing the meme, not deleting the image
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
