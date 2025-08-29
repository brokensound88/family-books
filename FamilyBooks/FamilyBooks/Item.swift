//
//  Item.swift
//  FamilyBooks
//
//  Created by Rohan Kumar on 29/8/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
