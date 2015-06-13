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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = false
        
        println("TableViewController count: \(memes.count)")
        if memes.count == 0 {
            println("TODO: push editor")
            pushMemeEditorVC()
        }
        self.tableView.reloadData()
    }

    // MARK - table data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("tVcount: \(memes.count)")
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! TableViewCell
        cell.rowImage.image = memes[indexPath.row].memedImage
        cell.topText.text = memes[indexPath.row].topText
        cell.bottomText.text = memes[indexPath.row].bottomText
        println("topText")
        println(cell.topText.text)
        return cell
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
        //presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    
}

