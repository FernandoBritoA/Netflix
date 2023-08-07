//
//  Extensions.swift
//  Netflix
//
//  Created by Fernando Brito on 06/08/23.
//

import Foundation

extension String {
    func capitlizeFirstLetter() -> String{
        let firstLetter = self.prefix(1).uppercased()
        let restLetters = self.lowercased().dropFirst()
        
        return firstLetter + restLetters
    }
}
