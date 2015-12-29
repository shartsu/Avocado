//
//  StateTrans.swift
//  Avocado
//
//  Created by TK on 12/28/15.
//  Copyright © 2015 TK. All rights reserved.
//

import Foundation

class StateTimer {
    
    //1 reset
    //2 moving
    //3 suspend
    
    private var statement = Int();
    
    init() {
        statement = 0;
    }
    
    func statecheck() -> Int {
        return statement;
    }
    
    func reset() -> String {
        statement = 1;
        return "▶";
    }
    
    func start() -> String {
        statement = 2;
        return "||";
    }
    
    func suspend() -> String {
        statement = 3;
        return "▶";
    }
    
}