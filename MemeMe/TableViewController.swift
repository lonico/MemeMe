//
//  TableViewController.swift
//  MemeMe
//
//  Created by Laurent Nicolas on 6/7/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes: [Meme]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = false
        
        if memes.count == 0 {
            pushMemeEditorVC()
        }
        self.tableView.reloadData()
    }

    // MARK - table data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! TableViewCell
        cell.rowImage.image = memes[indexPath.row].memedImage
        cell.topText.text = memes[indexPath.row].topText
        cell.bottomText.text = memes[indexPath.row].bottomText
        return cell
    }
    
    // Mark - table delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        memeDetailVC.memeImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    // Mark - action button
    
    @IBAction func AddButton(sender: UIButton) {
        pushMemeEditorVC()
    }
    
    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
}

