//
//  ViewController.swift
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 11/3/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

import UIKit
import StoreKit

func shuffle<T>(list: Array<T>) -> Array<T> {
    var list = list
    for i in 0..<list.count {
        let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
        list.insert(list.removeAtIndex(j), atIndex: i)
    }
    return list
}

class ViewController: UIViewController {

    var wordList: [[String:AnyObject]]!
    var products: [AnyObject]?
    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var descLabel: UILabel!
    
    var synth:AVSpeechSynthesizer!
    var count:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.synth = AVSpeechSynthesizer()

        // iOS 8 bug fix
        let dummyUtterance:AVSpeechUtterance = AVSpeechUtterance(string:" ")
        dummyUtterance.voice = AVSpeechSynthesisVoice()
        dummyUtterance.rate = AVSpeechUtteranceMaximumSpeechRate
        self.synth.speakUtterance(dummyUtterance)
        
        
        let sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        count = 0
        
        self.purchaseButton.setTitle("Tüm Kelimeleri Satın Al", forState: UIControlState.Normal)
        
        if let arr = sharedDefaults.objectForKey("wordList") as? [[String:AnyObject]] {
            
            let isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
            
            if(isPurchased)
            {
                self.purchaseButton.hidden = true
                self.descLabel.hidden = true
                wordList = shuffle(arr)
                updateUI()
            }
            else {
                
                if arr.count < 500 {
                    wordList = shuffle(Array(arr[0..<arr.count]))
//                    wordList = shuffle(arr.subarrayWithRange(NSMakeRange(0, arr.count)))
                }
                else {
                    wordList = shuffle(Array(arr[0..<500]))
//                    wordList = shuffle(arr.subarrayWithRange(NSMakeRange(0, 500)))
                }
                
                updateUI()
            }
        }
        
        //TODO: widget ekle türkçe bilgiler
    }
    
    @IBAction func feedbackTapped(sender: AnyObject) {
        
        let feedbackViewController:CTFeedbackViewController = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(), localizedTopics: CTFeedbackViewController.defaultTopics())
        feedbackViewController.toRecipients = ["ahmet@guncelcaps.com"]
        feedbackViewController.useHTML = false
        self.navigationController?.pushViewController(feedbackViewController, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        let isPurchased = sharedDefaults.boolForKey("isPurchased")
        
        if ( isPurchased ) {
            
            // purchased here
            self.purchaseButton.hidden = true
            self.descLabel.hidden = true
            
        }
        else {
            self.reload()
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.productPurchased(_:)), name:IAPHelperProductPurchasedNotification, object: nil)
        }
        

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func buyButtonTapped(sender: AnyObject) {
        
        
        if let productList = products {
            
            if productList.count > 0 {
                if let product = productList[0] as? SKProduct {
                    KelimeIAPHelper.shared.buyProduct(product)
                }
            }
        }
    }
    
    @IBAction func restoreButtonTapped(sender: AnyObject) {
        KelimeIAPHelper.shared.restoreCompletedTransactions()
    }
    
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        
        if let productList = products {
            
            if productList.count > 0 {
                
                for product in productList {

                    if productIdentifier == product.productIdentifier {
                        let sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
                        
                        sharedDefaults.setBool(true, forKey: "isPurchased")
                        sharedDefaults.synchronize()
                        self.reload()
                        
                        self.count = 0
                        
                        if let arr = sharedDefaults.objectForKey("wordList") as? [[String:AnyObject]] {
                            
                            let isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
                            
                            if(isPurchased)
                            {
                                self.purchaseButton.hidden = true
                                self.descLabel.hidden = true
                                self.wordList = shuffle(arr)
                                self.updateUI()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func reload() {
        self.products = nil
        KelimeIAPHelper.shared.requestProductsWithCompletionHandler { (success, products) -> Void in
            if(success) {
                self.products = products as [AnyObject]
            }
        }
        
    }
    
    func restoreTapped(sender: AnyObject) {
        KelimeIAPHelper.shared.restoreCompletedTransactions()
    }
    
    func updateUI() {
        
        self.wordLabel.text = wordList[count]["word"] as? String
        self.meaningLabel.text = wordList[count]["meaning"] as? String
        
    }
    
    @IBAction func voiceTapped(sender: AnyObject) {
        let text =  wordLabel.text
        let utterance:AVSpeechUtterance = AVSpeechUtterance(string:text!)
        
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.05
        self.synth.speakUtterance(utterance)
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        if(count < wordList.count-1) {
            count += 1
            updateUI()
        }
    }
    
    @IBAction func prevTapped(sender: AnyObject) {
        if (count > 0){
            count -= 1
            updateUI()
        }
        
    }
    

}

