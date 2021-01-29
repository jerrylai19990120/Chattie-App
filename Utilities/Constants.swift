//
//  Constants.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-27.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (_ Success: Bool) -> () 

//Segues
let TO_LOGIN = "toLogin"
let TO_SIGNUP = "toSignup"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants
let BASE_URL = "https://chattie-server.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"

//Header
let HEADER: HTTPHeaders = [
    "Content-type": "application/json; charset=utf-8"
]
