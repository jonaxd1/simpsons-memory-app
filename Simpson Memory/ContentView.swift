//
//  ContentView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 03/05/22.
//
/** SONIDOS **/
// START: https://elements.envato.com/es/funny-loop-EHLAHAA
// WIN: https://elements.envato.com/es/big-band-prize-EBSRPZT
// CORRECT: https://elements.envato.com/es/simple-win-83ES7TF
// FAIL: https://elements.envato.com/es/mallet-drum-fail-D96GXMC
// TOUCH BUTTON: https://elements.envato.com/es/game-button-select-pop-ZY7SBW7
// FLIP CARD: https://elements.envato.com/es/cardboard-game-card-flip-ESW3UTN

import SwiftUI

let imgsName = [
    "apu",
    "barney",
    "bart1",
    "bart2",
    "bart3",
    "bob",
    "burns",
    "comics",
    "family",
    "homero1",
    "jefe_gorgory",
    "krusty",
    "lisa",
    "maggie",
    "marge1",
    "martin",
    "milhouse",
    "moe",
    "nelson",
    "skinner",
    "smithers"
]

struct ContentView: View {
    @State private var currentBoardConfig: Board = Board(columns: 4, rows: 4)
    @State private var faces: [String] = Array(repeating: "", count: 16)
    @State private var moves: [Move?] = Array(repeating: nil, count: 16)
    @State private var difficulty: TypeBoard = .hard
    @State private var currentMoves = 0
    @State private var prevMove: Move? = nil
    @State private var isBoardDisable = false
    @State private var points: Int = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("3")
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(points)")
                        }
                    }
                    Picker("Choose difficulty", selection: $difficulty) {
                        Text("Easy").tag(TypeBoard.easy)
                        Text("Medium").tag(TypeBoard.medium)
                        Text("Hard").tag(TypeBoard.hard)
                    }.pickerStyle(.segmented).onChange(of: difficulty) { _ in
                        self.changeBoard()
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: currentBoardConfig.columns), spacing: 15) {
                        ForEach(0..<currentBoardConfig.total, id: \.self) { index in
                            ZStack {
                                Color.blue
                                // CARD LOGO
                                ZStack {
                                    Color.gray.opacity(0.5)
                                    Image("simpsons_logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .opacity(moves[index] == nil ? 1 : 0)
                                // CARDS FACES
                                Image("simpsons_\(faces[index])")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(moves[index] != nil ? 1 : 0)
                            }
                            .frame(width: getWidth(), height: getHeight(proxy), alignment: .center)
                            .cornerRadius(15)
                            .rotation3DEffect(
                                .init(degrees: moves[index] != nil ? 180 : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 1.0
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.0, y: 0.0)
                            .onTapGesture(perform: {
                                withAnimation(Animation.easeIn(duration: 0.5)) {
                                    processPlayerMove(for: index)
                                }
                            })
                        }
                    }
                    .disabled(isBoardDisable)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(15)
                .navigationTitle("Simpsons Memo")
                .navigationBarHidden(true)
            }.onAppear {
                initBorad()
            }
        }
    }
    
    func isPositionFlipped(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index })
    }
    
    func processPlayerMove(for position: Int) {
        if isPositionFlipped(in: moves, forIndex: position) { return }
        let currentMove = Move(cardName: "\(faces[position])", boardIndex: position)
        
        if currentMoves < 1 {
            prevMove = currentMove
        }
        if currentMoves < 2 {
            currentMoves += 1
            moves[position] = currentMove
        }
        if currentMoves == 2 {
            isBoardDisable = true
            guard let prevMove = prevMove else {
                return
            }
            if prevMove.cardName == currentMove.cardName {
                currentMoves = 0
                self.prevMove = nil
                self.points += 1
                isBoardDisable = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    withAnimation(Animation.easeOut(duration: 0.5)) {
                        moves[position] = nil
                        moves[prevMove.boardIndex] = nil
                        currentMoves = 0
                        self.prevMove = nil
                        isBoardDisable = false
                    }
                }
            }
        }
    }
    
    // MARK: CALCULATE WIDTH & HEIGHT
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / CGFloat(currentBoardConfig.columns)
    }
    
    func getHeight(_ proxyReader: GeometryProxy) -> CGFloat {
        let padding = currentBoardConfig.rows == 4 ? 150 : 180
        let calculatedHeight = (proxyReader.size.height - CGFloat(padding)) / CGFloat(currentBoardConfig.rows)
        return calculatedHeight < 0 ? 129.25 : calculatedHeight
    }
    
    func initBorad() {
        changeBoard()
    }
    
    func changeBoard() {
        switch difficulty {
        case .easy:
            currentBoardConfig = Board(columns: 4, rows: 4)
        case .medium:
            currentBoardConfig = Board(columns: 4, rows: 6)
        case .hard:
            currentBoardConfig = Board(columns: 5, rows: 6)
        }
        randomBoard()
        moves = Array(repeating: nil, count: currentBoardConfig.total)
        currentMoves = 0
        self.points = 0
        prevMove = nil
    }
    
    func randomBoard() {
        var possibleItems = imgsName.shuffled()
        var possibleFaces: [String] = []
        for _ in 0..<(currentBoardConfig.total/2) {
            let randomIndex = (0..<possibleItems.count).randomElement()!
            possibleFaces.append(possibleItems[randomIndex])
            possibleFaces.append(possibleItems[randomIndex])
            possibleItems.remove(at: randomIndex)
        }
        possibleFaces.shuffle()
        self.faces = possibleFaces
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
