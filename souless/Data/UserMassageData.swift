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
    
    init(userNm: String, userEm: String, userImg: String) {
        userName = userNm
        userEmail = userEm
        userImage = userImg
    }
    
}
