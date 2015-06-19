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
        let a = self.view.frame.size
        println(a.height, a.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
