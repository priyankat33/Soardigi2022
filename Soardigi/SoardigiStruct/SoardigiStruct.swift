//
//  SoardigiStruct.swift
//  Soardigi
//
//  Created by Developer on 19/10/22.
//

import Foundation

struct ValidationMessage {
     static let kSelectProfileImage = "Please select Profile image"
    static let kFirstName = "Please enter name"
    static let kTitle = "Please enter title"
    static let kCaption = "Please enter caption"
    
     static let kFirstNameAlphabatics = "First name contains only alphabatics"
     static let kLastNameAlphabatics = "Last name contains only alphabatics"
    static let kLastName = "Please enter last name"
    static let kEmail = "Please enter email"
    static let kUsername = "Please enter name"
    
    static let kSelected = "Please select atleast one service"
    
    static let kSelectedTime = "Please select time"
    
    static let kReview = "Please enter review"
    static let kRating = "Please select rating"
    
    static let kSelectedLocation = "Please select location"
    
    static let kSelectImage = "Please select image"
    static let kUsernameValidation = "Please enter only alphabets in name"
    
    static let kUsernameCount = "The name should not be more than 25 characters"
  
    static let kValidEmail = "Please enter a valid email"
    static let kPassword = "Please enter password"
     static let kPhone = "Please enter phone number"
    static let kOldPassword = "Please enter the old password"
    static let kPasswordLength = "Password should be minimum of 8 characters and maximum of 30 characters"
    
    static let kPhoneLength = "Phone number should be minimum of 10 digits and maximum of 15 digits"
    static let kNewPassword = "Please enter new password"
    static let kConfirmPassword = "Please enter confirm password"
    static let kPasswordNotMatch = "Password and confirm password does not match"
    
    static let kOldPasswordNotMatch = "Old password and new password shuold not be same"
    static let kTermsConditions = "Please accept Terms & Conditions"
    
    
    static let kCardName = "Please enter the card holder name"
    static let kCardNumber = "Please enter card number"
    static let kExpiration = "Please enter expiration date"
    static let kCVV = "Please enter CVV"
    
}


struct API {
    
    static let kSendPasswordResetLink = "sendPasswordResetLink"
    static let kLogin      =   "check-mobile"
    static let kSendOtpCode      =   "sendOtpCode"
    static let kVerifyOtpCode      =   "register"
    static let kRegisterOTP    =   "register-otp"
    static let kLoginOTP    =   "login"
    static let kLanguageGet    =   "language-get"
    static let kLanguageSave    =   "language-save"
    static let kHomePage   =   "home-page"
    static let kChangeBusiness = "change-business"
    
}
