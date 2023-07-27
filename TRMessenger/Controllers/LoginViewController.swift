//
//  LoginViewController.swift
//  TRMessenger
//
//  Created by Tushar Khandaker on 26/7/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountLoginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPassword: UILabel!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var singUpLoginToggleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var isShowingSingUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func loginAndRegisterButtonTapped(_ sender: UIButton) {
        if isShowingSingUp {
            
        } else {
            
        }
    }
    
    @IBAction func singUpButtonTapped(_ sender: UIButton) {
        isShowingSingUp = !isShowingSingUp
        showAndHideConfirmPasswordField(isSingUp: isShowingSingUp)
        self.accountLoginLabel.text = self.isShowingSingUp ?  "Have an account?" : "Don't Have an account?"
        let buttonTitle = self.isShowingSingUp ? "Login" : "SingUp"
        self.singUpLoginToggleButton.setTitle(buttonTitle, for: .normal)
        let image = isShowingSingUp ? UIImage(named: "registerBtn") : UIImage(named: "loginBtn")
        self.loginButton.setImage(image, for: .normal)
    }
}

extension LoginViewController {
    
    func showAndHideConfirmPasswordField(isSingUp: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.confirmPasswordView.isHidden = !isSingUp
            self.forgetPassword.isHidden = isSingUp
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
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        togglePlaceHolderAndLabel(textField, isSelected: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        togglePlaceHolderAndLabel(textField, isSelected: false)

    }
}
