//
//  TodayViewController.swift
//  YDSKelime
//
//  Created by Ahmet Yalcinkaya on 11/5/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var wordList: NSArray!
    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!

    var count:NSInteger = 0
    var synth:AVSpeechSynthesizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.synth = AVSpeechSynthesizer()

        // iOS 8 bug fix
        var dummyUtterance:AVSpeechUtterance = AVSpeechUtterance(string:" ")
        dummyUtterance.voice = AVSpeechSynthesisVoice()
        dummyUtterance.rate = AVSpeechUtteranceMaximumSpeechRate
        self.synth.speakUtterance(dummyUtterance)
        
        
        var sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        count = 0
        
        if let arr = sharedDefaults.objectForKey("wordList") as? NSArray {
            
            var isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
            
            if(isPurchased)
            {
                wordList = shuffle(arr)
                updateUI()
            }
            else {
                wordList = shuffle(arr.subarrayWithRange(NSMakeRange(0, 400)))
                updateUI()
            }
        }
    }
    
    func updateUI() {
        
        self.wordLabel.text = wordList[count]["word"] as? String
        self.meaningLabel.text = wordList[count]["meaning"] as? String
        
    }
    
    @IBAction func voiceTapped(sender: AnyObject) {
        var utterance:AVSpeechUtterance = AVSpeechUtterance(string:wordLabel.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.05
        self.synth.speakUtterance(utterance)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func shuffle<T>(var list: Array<T>) -> Array<T> {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.removeAtIndex(j), atIndex: i)
        }
        return list
    }
    
}
