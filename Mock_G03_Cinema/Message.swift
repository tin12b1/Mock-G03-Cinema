//
//  Message.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 7/16/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class UserMessage {
    
    var missingInput: String
    var wrongLogin: String
    var invalidEmailFormat: String
    var passwordShort: String
    var emailUsed: String
    var bookingTableTitle: String
    var signOutError: String
    var passwordMissmatch: String
    var failChangePassword: String
    var successChangePassword: String
    var emailNotExist: String
    var successResetPassword: String
    
    init() {
        missingInput            = "You must input all fields!"
        wrongLogin              = "Wrong email or password!"
        invalidEmailFormat      = "Invalid email format!"
        passwordShort           = "Password must be at least 6 characters!"
        emailUsed               = "Email used by another user!"
        bookingTableTitle       = "LIST OF SEATS YOU BOOKED"
        signOutError            = "Signout Error!"
        passwordMissmatch       = "Password missmatch!"
        failChangePassword      = "Change password failed!"
        successChangePassword   = "Change password successful!"
        emailNotExist           = "Email is not exist in system!"
        successResetPassword    = "Reset password email sent, check your inbox!"
    }
}
