//
//  Date+currentTimeInMilliseconds.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/20/23.
//

import Foundation

extension Date {
    func currentTimeInMilliseconds() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
