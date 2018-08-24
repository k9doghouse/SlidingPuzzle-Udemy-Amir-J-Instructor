//
//  Alerts.swift
//  Sliding Game
//
//  Created by murph on 8/23/18.
//  Copyright © 2018 k9doghouse. All rights reserved.
//

import Foundation
import UIKit

struct Alert
{
    private static func showCompletedAlert(on vc: UIViewController,
                                      with title: String,
                                         message: String)
    {
        let alert = UIAlertController(title: title,
                                    message: message,
                             preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                    handler: nil))
        
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    } // end private static func showCA...
    
    
    static func showCompletedAlert(on vc: UIViewController) {
        showCompletedAlert(on: vc,
                         with: "You arranged all sliding tiles correctly.",
                      message: "Tap the 'Reset Button' to play again.")
    }  // end static func showCompletedAlert()
    
    
    static func showUnableToRetrieveDataAlert(on vc: UIViewController)
    {
        showCompletedAlert(on: vc,
                         with: "Unable to Retrieve Data",
                      message: "Network Error")
    } // end static func showCompletedAction()
} // end struct Alert...
