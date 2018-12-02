//
//  UIViewHelper.swift
//  Gatherley
//
//  Created by apple on 20/03/18.
//  Copyright © 2018 CodeToArt Technology. All rights reserved.
//

import Foundation
import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    
    func constraintsEqualToSuperView(commonConstant: CGFloat = 0) {
        if let superview = self.superview {
            NSLayoutConstraint.activate(
                [
                    self.topAnchor.constraint(
                        equalTo: superview.topAnchor,
                        constant: commonConstant
                    ),
                    self.bottomAnchor.constraint(
                        equalTo: superview.bottomAnchor,
                        constant: -commonConstant
                    ),
                    self.leadingAnchor.constraint(
                        equalTo: superview.leadingAnchor,
                        constant: commonConstant
                    ),
                    self.trailingAnchor.constraint(
                        equalTo: superview.trailingAnchor,
                        constant: -commonConstant
                    )
                ]
            )
        }
    }
    
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 0.0
    }
    
    func setBorder(_ width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadowToView(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }
}
