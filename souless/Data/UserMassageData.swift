//
//  UserMassageData.swift
//  souless
//
//  Created by Влад Третьяк on 11/29/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import Foundation

class UserMessageData {
    var userName: String?
    var userImage: String?
    var userEmail: String?
    var userId: String
    
    init(userNm: String, userEm: String, userImg: String, UserId: String) {
        userName = userNm
        userEmail = userEm
        userImage = userImg
        userId = UserId
    }
    
}

class currentMessages : NSObject {
    var text : String?
    var fromId : String?
    var toId: String?
    var timestamp : NSNumber?
    
    init(fromIdd: String, textt: String, timestampp: NSNumber, toIdd: String) {
        fromId = fromIdd
        text = textt
        timestamp = timestampp
        toId = toIdd
    }
}
