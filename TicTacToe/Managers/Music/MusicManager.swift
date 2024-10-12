//
//  MusicManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import AVKit

final class MusicManager {
    static let shared = MusicManager()
    private let storageManager = StorageManager.shared
    private var musicPlayer = AVAudioPlayer()
    private var soundPlayer = AVAudioPlayer()
    private var settings: GameSettings?
    
    private init() {}
    
    func playMusic() {
        settings = storageManager.getSettings()
        guard let settings, settings.isSelecttedMusic, !musicPlayer.isPlaying else { return }
        if let urlMusic = MusicStorage.getMusicFor(settings.musicStyle) {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: urlMusic)
                musicPlayer.numberOfLoops =  -1
                musicPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopMusic() {
        musicPlayer.stop()
    }
    
    func playSoundFor(_ state: SoundState) {
        if let urlSound = MusicStorage.getSoundFor(state) {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: urlSound)
                soundPlayer.play()
            } catch {
                print(error)
            }
        }
    }
}
