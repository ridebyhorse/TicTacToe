//
//  TimerManager.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 05.10.2024.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    
    var outOfTime: (() -> Void)?
    var onTimeChange: ((Int) -> Void)?
    private var timer = Timer()
    private var duration: Duration = .none
    var secondsCount: Int = 0
    
    private init() {}
    
    func startTimer() {
        duration = StorageManager.shared.getSettings().duration
        
        switch duration {
        case .none:
            secondsCount = 0
        case .fast:
            secondsCount = 30
        case .normal:
            secondsCount = 60
        case .long:
            secondsCount = 120
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCount), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc private func updateCount() {
        if duration == .none {
            secondsCount += 1
            onTimeChange?(secondsCount)
        } else {
            if secondsCount > 0 {
                secondsCount -= 1
                onTimeChange?(secondsCount)
            } else {
                outOfTime?()
            }
        }
    }
}
