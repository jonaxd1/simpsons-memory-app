//
//  GameView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import SwiftUI

struct GameView: View {
    var difficulty: TypeBoard
    @ObservedObject var viewModel: ViewModel
    
    init(difficulty: TypeBoard) {
        let localDifficulty = difficulty
        self.difficulty = localDifficulty
        self.viewModel = ViewModel(difficulty: localDifficulty)
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    Group {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("\(viewModel.timeRemaining)")
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "m.circle.fill")
                                .foregroundColor(.yellow)
                            Text("\(viewModel.totalMoves)")
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(viewModel.points)")
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: viewModel.currentBoard.columns), spacing: 15) {
                    ForEach(0..<viewModel.currentBoard.total, id: \.self) { index in
                        BoardItemView(proxy: proxy, move: viewModel.moves[index], face: viewModel.faces[index], board: viewModel.currentBoard)
                            .onTapGesture(perform: {
                                withAnimation(Animation.easeIn(duration: 0.5)) {
                                    viewModel.processPlayerMove(for: index)
                                }
                            })
                    }
                }
                .disabled(viewModel.isBoardDisable)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(15)
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.reset()
                }))
            }
        }.onAppear {
            viewModel.initBorad()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView(difficulty: .hard)
                .previewInterfaceOrientation(.portrait)
                .previewLayout(.device)
                .previewDevice("iPhone 6")
                .preferredColorScheme(.dark)
        }
    }
}
