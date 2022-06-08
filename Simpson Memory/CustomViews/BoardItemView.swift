//
//  BoardItemView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import SwiftUI

struct BoardItemView: View {
    let proxy: GeometryProxy
    let move: Move?
    let face: String
    let board: Board
    
    var body: some View {
        ZStack {
            Color.blue
            // CARD LOGO
            ZStack {
                Color.gray.opacity(0.5)
                Image("simpsons_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .opacity(move == nil ? 1 : 0)
            // CARDS FACES
            if move != nil{
                Image("simpsons_\(face)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(move != nil ? 1 : 0)
            }
        }
        .frame(width: getWidth(), height: getHeight(proxy), alignment: .center)
        .cornerRadius(15)
        .rotation3DEffect(
            .init(degrees: move != nil ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0),
            anchor: .center,
            anchorZ: 0.0,
            perspective: 1.0
        )
        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.0, y: 0.0)
    }
    
    // MARK: CALCULATE WIDTH & HEIGHT
    private func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / CGFloat(board.columns)
    }
    
    private func getHeight(_ proxyReader: GeometryProxy) -> CGFloat {
        let padding = board.rows == 4 ? 120 : 150
        let calculatedHeight = (proxyReader.size.height - CGFloat(padding)) / CGFloat(board.rows)
        return calculatedHeight < 0 ? 129.25 : calculatedHeight
    }
    
}

struct BoardItemView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            BoardItemView(proxy: geometry, move: Move(cardName: "smithers", boardIndex: 1), face: "smithers", board: Board(columns: 4, rows: 4))
        }
    }
}
