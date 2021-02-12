//
//  CompatibleLayoutGuide.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 11/02/2021.
//

import UIKit

extension UIView {
    
    var compatibleLayoutGuide: UILayoutGuide {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }
}
