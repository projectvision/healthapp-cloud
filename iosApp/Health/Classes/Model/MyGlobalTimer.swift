//
//  MyGlobalTimer.swift
//  Yabbit
//
//  Created by Apple on 07/10/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

import Foundation
class MyGlobalTimer: NSObject {
    
    let sharedTimer: MyGlobalTimer = MyGlobalTimer()
    var internalTimer: NSTimer?
    
    func startTimer(){
        guard self.internalTimer != nil else {
            fatalError("Timer already intialized, how did we get here with a singleton?!")
        }
        self.internalTimer = NSTimer.scheduledTimerWithTimeInterval(28800, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        guard self.internalTimer != nil else {
            fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
    }
    
    func fireTimerAction(sender: AnyObject?){
        debugPrint("Timer Fired! \(sender)")
    }
    
}
