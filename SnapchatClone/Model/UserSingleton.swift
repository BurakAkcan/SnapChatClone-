//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import Foundation

class UserSingleton{
    
    static let sharedInstance = UserSingleton()
    
    var email:String = ""
    var username:String = ""
    
    private init(){ }
}
