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
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = false
        
        if memes.count == 0 {
            pushMemeEditorVC()
        }
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopEditing()
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
        memeDetailVC.memes = memes
        memeDetailVC.index = indexPath.row
        memeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // removing the meme, not deleting the image
        memes.removeAtIndex(indexPath.row)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
    }
    
    // Mark - action button
    
    @IBAction func addButton(sender: UIBarButtonItem) {
            pushMemeEditorVC()
    }
    
    @IBAction func editButton(sender: UIBarButtonItem) {
        if self.editing {
            tableView.editing = false
            editButton.title = "Edit"
            self.editing = false
        } else {
            tableView.editing = true
            editButton.title = "Done"
            self.editing = true
        }
    }
    
    // Mark reset editing state
    
    func stopEditing() {
        if self.editing {
            tableView.editing = false
            editButton.title = "Edit"
            self.editing = false
        }
    }
    
    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
}

