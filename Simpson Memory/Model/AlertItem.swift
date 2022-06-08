//
//  AlertItem.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 27/05/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID().uuidString
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let win      = AlertItem(title: Text("Woo-hoo!!"), message: Text("Congratulations! You Win :)"), buttonTitle: Text("Play Again"))
    static let lose     = AlertItem(title: Text("D'oh!"), message: Text("Time's up, you lose :("), buttonTitle: Text("Try Again"))
}

