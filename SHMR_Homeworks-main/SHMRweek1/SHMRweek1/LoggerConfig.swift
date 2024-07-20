//
//  LoggerConfig.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 12.07.2024.
//

import Foundation
import CocoaLumberjack

class LoggerConfig {
    
    static func configure() {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLog.add(DDTTYLogger.sharedInstance!) 
    }
    
}
