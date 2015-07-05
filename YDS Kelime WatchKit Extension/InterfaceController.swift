//
//  InterfaceController.swift
//  YDS Kelime WatchKit Extension
//
//  Created by Ahmet Yalcinkaya on 7/4/15.
//  Copyright (c) 2015 Hayal Co. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var wordLabel: WKInterfaceLabel!
    @IBOutlet var meaningLabel: WKInterfaceLabel!
    
    var wordList: [[String:AnyObject]]!
    var count:Int = 0

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let sharedDefaults:NSUserDefaults = NSUserDefaults(suiteName: "group.hayal.yds")!
        
        count = 0
        
        if let arr = sharedDefaults.objectForKey("wordList") as? [[String:AnyObject]] {
            
            let isPurchased:Bool = sharedDefaults.boolForKey("isPurchased")
            
            if(isPurchased)
            {
                wordList = shuffle(arr)
                updateUI()
            }
            else {
                wordList = shuffle(Array(arr[0..<500]))
                
                //                wordList = shuffle(arr.subarrayWithRange(NSMakeRange(0, 500)))
                updateUI()
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateUI() {
        
        wordLabel.setText(wordList[count]["word"] as? String)
        meaningLabel.setText(wordList[count]["meaning"] as? String)
        
    }
    
    @IBAction func nextTapped() {
        if(count < wordList.count-1) {
            count++
            updateUI()
        }
    }
    
    @IBAction func prevTapped() {
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
