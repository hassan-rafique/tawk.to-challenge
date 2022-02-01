//
//  UIVIewControllerExt.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 29/01/2022.
//

import UIKit

extension UIViewController {
    func alert(title: String? = nil, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
