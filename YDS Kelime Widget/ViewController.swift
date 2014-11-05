//
//  ViewController.swift
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 11/3/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wordList: NSArray!
    var products: NSArray!

    var priceFormatter: NSNumberFormatter!

    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var descLabel: UILabel!
    
    var count:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        var sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        count = 0
        
        self.purchaseButton.setTitle("Tüm Kelimeleri Satın Al", forState: UIControlState.Normal)
        
        if let arr = sharedDefaults.objectForKey("wordList") as? NSArray {
            
            var isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
            
            if(isPurchased)
            {
                self.purchaseButton.hidden = true
                self.descLabel.hidden = true
                wordList = shuffle(arr)
                updateUI()
            }
            else {
                wordList = shuffle(arr.subarrayWithRange(NSMakeRange(0, 250)))
                updateUI()
            }
        }
        
        //TODO: widget ekle türkçe bilgiler
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        var isPurchased = sharedDefaults.boolForKey("isPurchased")
        
        if ( isPurchased ) {
            
            // purchased here
            self.purchaseButton.hidden = true
            self.descLabel.hidden = true
            
        }
        else {
            self.reload()
            NSNotificationCenter.defaultCenter().addObserver(self, selector:"productPurchased:", name:IAPHelperProductPurchasedNotification, object: nil)
        }

        
        self.priceFormatter = NSNumberFormatter()
        self.priceFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        self.priceFormatter.numberStyle = .CurrencyStyle
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func buyButtonTapped(sender: AnyObject) {
        
        if((products) != nil) {
            
            if(products.count > 0) {
                var product: SKProduct = products[0] as SKProduct
                
                KelimeIAPHelper.sharedInstance().buyProduct(product)

            }
        
        }

        
    }
    
    func productPurchased(notification: NSNotification) {
        var productIdentifier: NSString = notification.object as NSString
        
        self.products.enumerateObjectsUsingBlock { (product, idx, stop) -> Void in
            
            if(productIdentifier.isEqualToString(product.productIdentifier)) {
                
                NSLog("hop aldık")
                var sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
                
                sharedDefaults.setBool(true, forKey: "isPurchased")
                sharedDefaults.synchronize()
                self.reload()
                
                self.count = 0
                
                if let arr = sharedDefaults.objectForKey("wordList") as? NSArray {
                    
                    var isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
                    
                    if(isPurchased)
                    {
                        self.purchaseButton.hidden = true
                        self.descLabel.hidden = true
                        self.wordList = self.shuffle(arr)
                        self.updateUI()
                    }
                }
                
            }
            
            
        }
    }
    
    func reload() {
        self.products = nil
        KelimeIAPHelper.sharedInstance().requestProductsWithCompletionHandler { (success, products) -> Void in
            if(success) {
                self.products = products
                var product: SKProduct = products[0] as SKProduct
                var price = product.price.floatValue
                var currency = product.price
                
                self.purchaseButton.setTitle("Tüm Kelimeleri Satın Al (\(price))", forState:UIControlState.Normal)
            }
        }
        
    }
    
    func restoreTapped(sender: AnyObject) {
        KelimeIAPHelper.sharedInstance().restoreCompletedTransactions()
    }
    
    func updateUI() {
        
        self.wordLabel.text = wordList[count]["word"] as? String
        self.meaningLabel.text = wordList[count]["meaning"] as? String
        
    }
    
    @IBAction func voiceTapped(sender: AnyObject) {
        var synth:AVSpeechSynthesizer = AVSpeechSynthesizer()
        var utterance:AVSpeechUtterance = AVSpeechUtterance(string:wordLabel.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.05
        synth.speakUtterance(utterance)
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        if(count < wordList.count-1) {
            count++
            updateUI()
        }
    }
    
    @IBAction func prevTapped(sender: AnyObject) {
        if (count > 0){
            count--
            updateUI()
        }
        
    }
    
    func shuffle<T>(var list: Array<T>) -> Array<T> {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.removeAtIndex(j), atIndex: i)
        }
        return list
    }
}

