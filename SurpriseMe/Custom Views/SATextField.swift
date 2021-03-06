//
//  SATextField.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class SATextField: UITextField{
    
    var typeText : TextFieldType?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    func setupTextField(){
        tintColor = .white
        textColor = .darkGray
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        autocorrectionType = .no
        layer.cornerRadius = 25.0
        clipsToBounds = true
        
        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView = indentView
        leftViewMode = .always
    }
    
    func checkValidationNew(sender : SATextField, errorLabel : UILabel , type: TextFieldType){//-> Bool{
        if sender.text!.isEmpty{
//            print("Text is empty, please enter....")

            setupErrorMessage(textField: sender, errorLabel: errorLabel, textFieldType: type, message: type.getErrorMessage)

        }
        
        sender.typeText = type
        //return
        if !sender.typeText!.checkPattern(text: sender.text!){
            setupErrorMessage(textField: sender, errorLabel: errorLabel, textFieldType: type, message: type.getErrorMessage)
        } else{
            setTextFieldValid(sender: sender, errorLabel: errorLabel)
        }

    }
    
    func setupErrorMessage(textField : SATextField , errorLabel : UILabel, textFieldType : TextFieldType, message: String) {

        textField.layer.borderColor = UIColor.red.cgColor

        /* Here, I am using AutoLayout to lay out the errorMessage on the screen.
         If you used storyboard, delete every line in this function except where
         we set the message to hidden */
        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.isHidden = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = message
        
        errorLabel.textColor = .red
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor , constant: 16),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4)
            ])
    }
    
    func setTextFieldValid(sender : SATextField , errorLabel: UILabel){
        sender.layer.borderColor = UIColor.blue.cgColor
        
        errorLabel.text = nil
        errorLabel.isHidden = true

    }
}

enum TextFieldType{
    case isEmail , isPassword , isID , isGeneral
    
    func checkPattern(text: String)-> Bool{
        switch self{
        case .isEmail:
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                
                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailPred.evaluate(with: text)
        case .isPassword:
            //todo check if the same password as database
            
            if text.count < 6{
                return false
            }
            return true
        case .isID:
            if text.count != 9 {
                return false
            }
            return true
            
        case .isGeneral:
            if text.count < 1 {
                return false
            }
            
            return true
            
        }
        
        
    }
    
    var getErrorMessage:String{
        switch self{
        case .isEmail:
            return "Your email must be in email@email.com format"
        case .isPassword:
            return "Your password must be 6 digits long or more.."
        case .isID:
            return "Your ID must be 9 characters"
            
        case .isGeneral:
            return "Box is empty, you must fill the details"

        }
    }
    
}

