//
//  PostsData.swift
//  souless
//
//  Created by Влад Третьяк on 11/24/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import Foundation

class Posts {
    var caption : String
    var photoUrl : String?
    var user: String?
    var profileImage: String?
    
    init(captionText: String, photoUrlString: String, userName: String, profileImageUrl: String) {
        caption = captionText
        photoUrl = photoUrlString
        user = userName
        profileImage = profileImageUrl
    }
}
