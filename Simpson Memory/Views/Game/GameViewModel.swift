//
//  GameViewModel.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import SwiftUI


extension GameView {
    class ViewModel: ObservableObject {
        private let imgsName = [
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
        private var totalTime = 60
        
        @Published var timer = Timer()
        
        @Published var currentBoard: Board = Board(columns: 4, rows: 4)
        @Published var faces: [String] = Array(repeating: "", count: 16)
        @Published var moves: [Move?] = Array(repeating: nil, count: 16)
        @Published var currentMoves = 0
        @Published var totalMoves = 0
        @Published var prevMove: Move? = nil
        @Published var isBoardDisable = false
        @Published var points: Int = 0
        @Published var timeRemaining: Int = 60
        @Published var alertItem: AlertItem?
        
        let difficulty: TypeBoard
        
        init(difficulty: TypeBoard) {
            self.difficulty = difficulty
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
                    isBoardDisable = false
                    return
                }
                if prevMove.cardName == currentMove.cardName {
                    currentMoves = 0
                    self.prevMove = nil
                    self.points += 1
                    self.totalMoves += 1
                    self.checkWinCondition()
                    self.isBoardDisable = false
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            self.moves[position] = nil
                            self.moves[prevMove.boardIndex] = nil
                            self.currentMoves = 0
                            self.prevMove = nil
                            self.isBoardDisable = false
                            self.totalMoves += 1
                        }
                    }
                }
            }
        }
        
        func checkWinCondition(){
            if currentBoard.total/2 == points {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.timer.invalidate()
                    self.alertItem = AlertContext.win
                }
            }
        }
        
        func initBorad() {
            changeBoard()
        }
        
        func changeBoard() {
            switch difficulty {
            case .easy:
                currentBoard = Board(columns: 4, rows: 4)
            case .medium:
                currentBoard = Board(columns: 4, rows: 6)
            case .hard:
                currentBoard = Board(columns: 5, rows: 6)
            }
            reset()
        }
        
        func reset() {
            initTimer()
            randomBoard()
            moves = Array(repeating: nil, count: currentBoard.total)
            currentMoves = 0
            self.points = 0
            prevMove = nil
            totalMoves = 0
        }
        
        func randomBoard() {
            var possibleItems = imgsName.shuffled()
            var possibleFaces: [String] = []
            for _ in 0..<(currentBoard.total/2) {
                let randomIndex = (0..<possibleItems.count).randomElement()!
                possibleFaces.append(possibleItems[randomIndex])
                possibleFaces.append(possibleItems[randomIndex])
                possibleItems.remove(at: randomIndex)
            }
            possibleFaces.shuffle()
            self.faces = possibleFaces
        }
        
        func initTimer() {
            timer.invalidate()
            timeRemaining = totalTime
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        
        @objc func updateTime() {
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                alertItem = AlertContext.lose
            }
        }
    }
}
