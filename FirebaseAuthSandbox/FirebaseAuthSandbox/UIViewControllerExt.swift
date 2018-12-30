//
//  UIViewControllerExt.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/29/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import Foundation
import UIKit

private var kSpinnerAssociatedObjectKey = "_UIViewController_SpinnerAssociatedObject"

extension UIViewController {
    func displaySpinner(completion: (() -> Void)? = nil) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        
        objc_setAssociatedObject(self, &kSpinnerAssociatedObjectKey, spinnerView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            self.view.addSubview(spinnerView)
            if completion != nil {
                completion!()
            }
        }
    }
    
    func removeSpinner(completion: (() -> Void)? = nil) {
        let spinnerView = objc_getAssociatedObject(self, &kSpinnerAssociatedObjectKey) as? UIView
        
        if spinnerView != nil {
            DispatchQueue.main.async {
                spinnerView!.removeFromSuperview()
                if completion != nil {
                    completion!()
                }
            }
        }
        
        objc_setAssociatedObject(self, kSpinnerAssociatedObjectKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func showMessagePrompt(_ message: String?, handler: ((_ action: UIAlertAction?) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

