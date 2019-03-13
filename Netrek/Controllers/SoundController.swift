//
//  soundController.swift
//  Netrek
//
//  Created by Darrell Root on 3/13/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AVFoundation

enum Sound: String, CaseIterable {
    case explosion = "399303__deleted-user-5405837__explosion-012.mp3"
    case torpedo = "175269__jonccox__gun-zap2.wav"
    case laser = "175265__jonccox__gun-thumper.wav"
    case plasma = "175267__jonccox__gun-plasma.wav"
    case detonate = "175270__jonccox__gun-zap.wav"
    case shield = "71852__ludvique__digital-whoosh-soft.wav"
}
class SoundController {
    let soundThreads = 8
    //private var audioList: [AVAudioPlayer] = []
    private var soundList: [Sound:[AVAudioPlayer]] = [:]
    init() {
        for soundCandidate in Sound.allCases {
            if let pathToSound = Bundle.main.url(forResource: soundCandidate.rawValue, withExtension: "") {
                var audioList: [AVAudioPlayer] = []
                for _ in 0..<soundThreads {
                    if let audioPlayer = try? AVAudioPlayer(contentsOf: pathToSound) {
                
                        audioPlayer.prepareToPlay()
                        audioList.append(audioPlayer)
                    }
                }
                soundList[soundCandidate] = audioList
            }
        }
    }
    func play(sound: Sound, volume: Float) {
        if let audioList = soundList[sound] {
            for soundNumber in 0 ..< soundThreads {
                if !audioList[soundNumber].isPlaying {
                    audioList[soundNumber].setVolume(volume, fadeDuration: 0.0)
                    audioList[soundNumber].play()
                    return
                }
            }
        }
     }
}
