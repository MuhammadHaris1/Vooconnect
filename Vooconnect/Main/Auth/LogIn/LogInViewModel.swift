//
//  LogInViewModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 15/11/22.
//

import Foundation

struct LogInDataModel {
   
    
    // "hnhtechsolutionsemail@gmail.com"
    //"abcd@1234"
    
    var email: String = "hnh@gmail.com"//"hnhtechsolutionsemail@gmail.com"// = "jude@jude.com"
    var password: String = "abcd@1234"// = "Password12!"
    
    var phone: String = String()
    var phoneCode: String = String()
    
    var errorMassageOTP: String = String()
    
    var successMessage: String = String()
    var errorMessage: String = String()
    var navigate: Bool = false
    var isPresentingErrorAlert: Bool = false
    var isPresentingSuccess: Bool = false
    var isPresentingSuccessHome: Bool = false
    
    var errorEmial: Bool = false
    var errorPassword: Bool = false
    
    var errorPhone: Bool = false
    
    var emailError: String = String()
    var passwordError: String = String()
    var emialErrorMessage: String = String()
    
    var phoneError: String = String()
    var phoneErrorMessage: String = String()
    
}

class LogInViewModel: ObservableObject {
    @Published var logInDataModel: LogInDataModel = LogInDataModel()
    private let logInValidation = SignUpValidationn()
    private let logInPhoneValidation = SignUpPhoneValidation()
    private let forgotPasswordValidation = ForgotPasswordValidation()
    private let logInResource = LogInResource()
    @Published var usersList: [Users] = []
    
    init() {
            fetchUsersApi()
        }
    
    // validate the user inputs Email
    func validationUserInputss() -> Bool {
        let result = logInValidation.validationInputs(email: logInDataModel.email, password: logInDataModel.password)
        
        if(result.success == false) {
//            logInDataModel.errorMessage = result.errorMessage ?? "error occured"
            
            logInDataModel.emailError = result.email ?? ""
            if logInDataModel.emailError != "" {
                logInDataModel.errorEmial = true
            } else {
                logInDataModel.errorEmial = false
            }
            
            logInDataModel.passwordError = result.password ?? ""
            if logInDataModel.passwordError != "" {
                logInDataModel.errorPassword = true
            } else {
                logInDataModel.errorPassword = false
            }
            
            logInDataModel.isPresentingErrorAlert = true
            
            return false
        }
        return true
    }
    
    // validate the user inputs Phone
    func validationPhoneNumber() -> Bool {
        let result = logInPhoneValidation.validationPhoneInputs(phone: logInDataModel.phone)
        
        if(result.success == false) {
//            logInDataModel.errorMessage = result.errorMessage ?? "error occured"
            
            logInDataModel.phoneError = result.phone ?? ""
            if logInDataModel.phoneError != "" {
                logInDataModel.errorPhone = true
            }
            
            logInDataModel.isPresentingErrorAlert = true
            
            return false
        }
        return true
    }
    
    // validate the forgot Password
    
    func validateForgotPassword() -> Bool {
        
        let result = forgotPasswordValidation.forgotPasswordInputs(email: logInDataModel.email)
        
        if(result.success == false) {
//            logInDataModel.errorMessage = result.errorMessage ?? "error occured"
            
            logInDataModel.emailError = result.email ?? ""
            if logInDataModel.emailError != "" {
                logInDataModel.errorEmial = true
            }
            
            logInDataModel.isPresentingErrorAlert = true
            
            return false
        }
        return true
        
    }
    
    
    // call the email api
    func logInWithEmailApi() {
        
        let request = SignUpRequest(email: logInDataModel.email, password: logInDataModel.password, remember_me: "no")
        
        logInResource.hittingLogInApi(signupRequest: request) { isSuccess, sussesMessage, succes  in
            
            if isSuccess {
                DispatchQueue.main.async {
                    
                    if succes != nil {
                        self.logInDataModel.successMessage = succes ?? "Login successful."
                        self.logInDataModel.isPresentingSuccess = true
                    } else {
                        self.logInDataModel.successMessage = sussesMessage ?? "Login successful."
                        self.logInDataModel.isPresentingSuccess = true
                    }
                    
                   
                }
                
            } else {
                DispatchQueue.main.async {
                                        
                    if sussesMessage == "Incorrect password!" {
                        self.logInDataModel.passwordError = sussesMessage ?? "Incorrect password!"
                        self.logInDataModel.errorPassword = true
                    } else if sussesMessage == "Password should be 8-32 characters long and contain at least 1 special character!" {
                        
                        self.logInDataModel.passwordError = sussesMessage ?? "Incorrect password!"
                        self.logInDataModel.errorPassword = true
                        
                    } else if sussesMessage == "This email address is not registered!" {
                        
                        self.logInDataModel.emialErrorMessage = sussesMessage ?? "This email address is not registered!"
                        self.logInDataModel.errorEmial = true
//                        This email address is not registered!
                      
                    } else if sussesMessage == "Your account has been deleted. Please contact to support." {
                        
                        self.logInDataModel.emialErrorMessage = sussesMessage ?? "This email address is not registered!"
                        self.logInDataModel.errorEmial = true
                        
                    }
                    else {
                        self.logInDataModel.isPresentingSuccess = true
                        self.logInDataModel.successMessage = "Your OTP is 1234"

                    }
                    
                    if sussesMessage == "This email address is not registered." {
                        self.logInDataModel.emialErrorMessage = sussesMessage ?? "This email address is not registered."
                        self.logInDataModel.errorEmial = true
                    }
                    
                }
            }
            
        }
        
    }
    
    //call the phone api
    func LogInWithPhone() {
        
        let request = SignUpRequestPhone(phone: logInDataModel.phoneCode + logInDataModel.phone, password: "123456784", remember_me: "no")
        
        print("PHONE++++++++++++++", request)
        
        logInResource.hittingLogInWithPhone(logInRequest: request) { isSuccess, sussesMessage in
            
            if isSuccess {
                DispatchQueue.main.async {
                    self.logInDataModel.successMessage = "Your OTP is 1234"
                    self.logInDataModel.isPresentingSuccess = true
                    self.logInDataModel.navigate = true
                }
                
            } else {
                DispatchQueue.main.async {
                    
                    if sussesMessage == "Your phone number is not verified. Please verify your phone number to login." {
                        
                        self.logInDataModel.successMessage = "Your OTP is 1234"
                        self.logInDataModel.isPresentingSuccess = true
                        
                    } else if sussesMessage == "Please enter a valid phone number." {
                        self.logInDataModel.phoneErrorMessage = "Please enter a valid phone number."
                        self.logInDataModel.errorPhone = true
                    } else if sussesMessage == "Invalid login credentials." {
                        self.logInDataModel.phoneErrorMessage = "Invalid login credentials."
                        self.logInDataModel.errorPhone = true
                    }
                    
//                    if sussesMessage == "Failed" {  Invalid login credentials.
//                        self.logInDataModel.phoneErrorMessage = "This phone number is not registered."
//                        self.logInDataModel.errorPhone = true
//                        self.logInDataModel.isPresentingErrorAlert = true
//                    } else {
//                        self.logInDataModel.successMessage = sussesMessage ?? "sjdhbfjsdbf"
//                        self.logInDataModel.isPresentingSuccess = true
////                        self.logInDataModel.navigate = true
//                    }
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    // call the forgot password api
    func forgotPasswordApi() {
        
        let request = ForgotPasswordRequest(email: logInDataModel.email)
        
        logInResource.hittingForgotPassword(forGotPasswordRequest: request) { isSuccess, sussesMessage in
            
            if isSuccess {
                DispatchQueue.main.async {
                    self.logInDataModel.navigate = true
                }
                
            } else {
                DispatchQueue.main.async {
                    if sussesMessage == "Failed" {
                        self.logInDataModel.emialErrorMessage = "This Email Id is not registered."
                        self.logInDataModel.isPresentingErrorAlert = true
                    } else {
                        self.logInDataModel.successMessage = sussesMessage ?? "sjdhbfjsdbf"
                        self.logInDataModel.isPresentingSuccess = true
                    }
                }
            }
            
        }
        
    }
    
    //fetch users
    func fetchUsersApi() {
        print("Yes........come here")
        let urlRequest = URLRequest(url: URL(string: baseURL + EndPoints.users)!)
        print(urlRequest)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode([Users].self, from: data)
                 
                        self.usersList = decodedUsers
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }else{
                print("Error decoding: \(response.statusCode)")
            }
        }

        dataTask.resume()
        
    }
    
    
}
