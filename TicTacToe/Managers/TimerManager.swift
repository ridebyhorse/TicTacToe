//
//  TimerManager.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 05.10.2024.
//

import Foundation

final class TimerManager {
    static let shared = TimerManager()
    
    var outOfTime: (() -> Void)?
    var onTimeChange: ((Int) -> Void)?
    private var timer = Timer()
    private var duration: Duration = Duration(isSelectedDuration: false, valueDuration: nil) // Начальное значение
    var secondsCount: Int = 0
    
    private init() {}
    
    func startTimer() {
        let settings = StorageManager.shared.getSettings()
        duration = settings.duration
        
        if duration.isSelectedDuration, let valueDuration = duration.valueDuration {
            secondsCount = valueDuration
        } else {
            secondsCount = 0 
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCount), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc private func updateCount() {
        if !duration.isSelectedDuration {
            secondsCount += 1
            onTimeChange?(secondsCount)
        } else if secondsCount > 0 {
            secondsCount -= 1
            onTimeChange?(secondsCount)
        } else {
            outOfTime?()
            stopTimer()
        }
    }
}
