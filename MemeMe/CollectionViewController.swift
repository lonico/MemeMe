//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Laurent Nicolas on 6/7/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var memes = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = false
        
        if memes.count == 0 {
            pushMemeEditorVC()
        }
        collectionView.reloadData()
    }

    // MARK - CollectionView Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.collectionCellImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    // MARK - CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        memeDetailVC.memeImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    // Mark - push meme editor VC
    
    func pushMemeEditorVC() {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        
        memeEditorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
        //presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    
    @IBAction func addAction(sender: UIBarButtonItem) {
        pushMemeEditorVC()
    }

}

