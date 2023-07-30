//
//  LoginViewController.swift
//  TRMessenger
//
//  Created by Tushar Khandaker on 26/7/23.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var confirmPasswordView: UIView!

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPassword: UILabel!
    @IBOutlet weak var accountLoginLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var singUpLoginToggleButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var isShowingSingUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
        if isInputValidData(for: "password") {

        } else {
            ProgressHUD.showFailed("Email Needed")
        }
    }
    
    @IBAction func loginAndRegisterButtonTapped(_ sender: UIButton) {
        
        if isInputValidData(for: isShowingSingUp ? "signup" : "login") {
            isShowingSingUp ? registerUser() : loginUser()
        } else {
            ProgressHUD.showFailed("All Field Required")
        }
    }
    
    @IBAction func singUpButtonTapped(_ sender: UIButton) {
        isShowingSingUp = !isShowingSingUp
        showAndHideConfirmPasswordField(isSingUp: isShowingSingUp)
        self.accountLoginLabel.text = self.isShowingSingUp ?  "Have an account?" : "Don't Have an account?"
        let buttonTitle = self.isShowingSingUp ? "Login" : "SingUp"
        self.singUpLoginToggleButton.setTitle(buttonTitle, for: .normal)
    }
}

extension LoginViewController {
    
    func showAndHideConfirmPasswordField(isSingUp: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.confirmPasswordView.isHidden = !isSingUp
            self.forgetPassword.isHidden = isSingUp
            let image = isSingUp ? UIImage(named: "registerBtn") : UIImage(named: "loginBtn")
            self.loginButton.setImage(image, for: .normal)
        }
    }
    
    func isInputValidData(for type: String)-> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "signup":
            return emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    func togglePlaceHolderAndLabel(_ selectedTextField: UITextField, isSelected: Bool) {
        
        switch selectedTextField {
        case emailTextField:
            emailLabel.isHidden = isSelected ? false : true
            selectedTextField.placeholder = isSelected ? "" : "Email"
            
        case passwordTextField:
            passwordLabel.isHidden = isSelected ? false : true
            selectedTextField.placeholder = isSelected ? "" : "Password"
            
        case confirmPasswordTextField:
            confirmPassword.isHidden = isSelected ? false : true
            selectedTextField.placeholder = isSelected ? "" : "Confirm Password"
            
        default:
            print("OK")
        }
    }
    
    func registerUser () {
        
        if passwordTextField.text == confirmPasswordTextField.text {
            FirebaseUserListener.shared.registrationUser(with: emailTextField.text!, and: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSucceed("Verification Email Sent")
                    //Unhide email verification buttn
                } else {
                    ProgressHUD.showFailed("\(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            ProgressHUD.showError("Password dosen't Match")
        }
    }
    
    func loginUser() {
        FirebaseUserListener.shared.loginUser(with: emailTextField.text!, and: passwordTextField.text!) { error, isEmailVerified in
            if error == nil {
                if isEmailVerified {
                    print("Successfully login ",UserModel.currentUser?.userEmail)
                } else {
                    ProgressHUD.showFailed("Email not verified, Please verify email")
                    //unhide resend email verification button
                }
                
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        togglePlaceHolderAndLabel(textField, isSelected: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        togglePlaceHolderAndLabel(textField, isSelected: false)
    }
}
