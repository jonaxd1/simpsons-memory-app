//
//  StartView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 27/05/22.
//

import SwiftUI

struct StartView: View {
    @State private var difficulty: TypeBoard = .easy
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 5) {
                    Image("simpsons_family")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                    VStack {
                        Text("Choose your difficulty")
                        DifficultyPicker(difficulty: $difficulty)
                    }.padding(.bottom, 20)
                    NavigationLink(destination: GameView(difficulty: difficulty), label: {
                        HStack {
                            Spacer()
                            Text("START")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(Color.init(uiColor: .systemBackground))
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                    })
                    Spacer()
                    Group {
                        Text("Made with ❤️ by Jonathan Torres")
                        Text("torresr.com")
                    }
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(Color.init(uiColor: .label))
                }
                .padding(.horizontal)
            }
        }
        .statusBar(hidden: true)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .preferredColorScheme(.light)
    }
}
