//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Laurent Nicolas on 6/7/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes = [Meme]()
    
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
        
        println("CollectionViewController count: \(memes.count)")
        if memes.count == 0 {
            println("TODO: push editor")
            pushMemeEditorVC()
        }

    }

    // MARK - CollectionView Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("cVcount: \(memes.count)")
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.collectionCellImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
        //presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    

}

