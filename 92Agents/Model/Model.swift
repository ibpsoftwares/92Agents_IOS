//
//  Model.swift
//  92Agents
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
final class Model {
    
    // Can't init is singleton
    public init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: Model = Model()
    
    //MARK: Local Variable
    
    var accessToken = String()
    var userRole = String()
    var userID = String()
     var user = String()
}
