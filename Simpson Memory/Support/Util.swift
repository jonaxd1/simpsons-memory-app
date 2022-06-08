//
//  Util.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 27/05/22.
//

import Foundation
import AVKit

final class Util {
    static var audioPlayer: AVAudioPlayer?
    
    static func playSound(trackName: String) {
        if let sound = Bundle.main.path(forResource: trackName, ofType: "wav") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                audioPlayer?.volume = 0.1
                audioPlayer?.play()
            } catch {
                debugPrint("Audio play error:", error.localizedDescription)
            }
        }
    }
    
    static func playSoundBackground() {
        let trackName = "Loop"
        if let sound = Bundle.main.path(forResource: trackName, ofType: "wav") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.1
                audioPlayer?.play()
            } catch {
                debugPrint("Audio play error:", error.localizedDescription)
            }
        }
    }
}
