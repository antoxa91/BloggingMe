//
//  String + Ext.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 03.11.2022.
//

import Foundation

extension String {
    func isValid() -> Bool { 
        let format = "SELF MATCHES %@"
        //обязательно должны быть буквы маленькие или заглавные, собака, не меньше 2 символов после точки в конце домена
        let regEx = "[a-zA-Z0-9._]+@[a-zA-Z]+\\.[a-zA-z]{2,}"
        return NSPredicate(format: format, regEx).evaluate(with: self)
    }
}
