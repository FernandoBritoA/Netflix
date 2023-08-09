//
//  Extensions.swift
//  Netflix
//
//  Created by Fernando Brito on 06/08/23.
//

import Foundation
import UIKit

extension String {
    func capitlizeFirstLetter() -> String {
        let firstLetter = self.prefix(1).uppercased()
        let restLetters = self.lowercased().dropFirst()

        return firstLetter + restLetters
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
