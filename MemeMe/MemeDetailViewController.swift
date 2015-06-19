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
    var memeImage: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        detailImageView.image = memeImage
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = true
    }
    
    @IBAction func addAction(sender: AnyObject) {
        pushMemeEditorVC()
    }

    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }

}
