//
//  ShowTimer.swift
//  Avocado
//
//  Created by TK on 12/29/15.
//  Copyright © 2015 TK. All rights reserved.
//

import Foundation

class ShowTimer {
    
    init() {
    }
    
    func reset() -> String {
        return "\("25"):\("00"):\("00")";
    }
    
    func setTimer(argTime: NSTimeInterval) -> String
    {
        var tmpTime = argTime;
        
        let tmpMinutes = UInt8(tmpTime / 60.0);
        tmpTime -= (NSTimeInterval(tmpMinutes) * 60);
    
        let tmpSeconds = UInt8(tmpTime);
        tmpTime -= NSTimeInterval(tmpSeconds);
        
        let tmpFraction = UInt8(tmpTime * 100);
        
        return "\(String(format: "%02d", tmpMinutes)):\(String(format: "%02d", tmpSeconds)):\(String(format: "%02d", tmpFraction))";
    }
    
    func setTimerOnlyMin(argTime: NSTimeInterval) -> String
    {
        let tmpTime = argTime;
        let tmpMinutes = UInt8(tmpTime / 60.0);
        
        return "\(String(format: "%02d", tmpMinutes)):\("00"):\("00")";
    }
    
    

}
