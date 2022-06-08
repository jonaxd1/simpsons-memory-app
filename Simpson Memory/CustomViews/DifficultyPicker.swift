//
//  DifficultyPicker.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 27/05/22.
//

import SwiftUI

struct DifficultyPicker: View {
    @Binding var difficulty: TypeBoard
    
    
    var body: some View {
        Picker("Choose difficulty", selection: $difficulty) {
            Text("Easy").tag(TypeBoard.easy)
            Text("Medium").tag(TypeBoard.medium)
            Text("Hard").tag(TypeBoard.hard)
        }.pickerStyle(.segmented)
    }
}

struct DifficultyPicker_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyPicker(difficulty: .constant(.easy))
    }
}
