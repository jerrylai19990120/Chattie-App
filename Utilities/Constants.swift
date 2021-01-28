//
//  Constants.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-27.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> () 

//Segues
let TO_LOGIN = "toLogin"
let TO_SIGNUP = "toSignup"
let UNWIND = "unwindToChannel"


//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants
let BASE_URL = "https://chattie-server.herokuapp.com/"
let URL_REGISTER = "\(BASE_URL)account/register"
