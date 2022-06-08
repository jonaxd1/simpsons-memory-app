//
//  Board.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import Foundation

enum TypeBoard {
    case easy
    case medium
    case hard
}

struct Board {
    var columns: Int
    var rows: Int
    var total: Int
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        self.total = rows * columns
    }
}
