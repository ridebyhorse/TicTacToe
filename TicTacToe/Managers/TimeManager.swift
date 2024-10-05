//
//  TimeManager.swift
//  TicTacToe
//
//  Created by Kate Kashko on 5.10.2024.
//
import Foundation
import Combine

final class TimeManager: ObservableObject {
    static let shared = TimeManager(duration: TimeManager.convertDurationToTimeInterval(StorageManager.shared.getSettings().duration))

    @Published var timeRemaining: TimeInterval
    private var timer: Timer?
    private let duration: TimeInterval
    private let storageManager = StorageManager.shared

//    private init() {
//        // Load duration from settings
//        let settings = storageManager.getSettings()
//        self.duration = Self.convertDurationToTimeInterval(settings.duration)
//        self.timeRemaining = duration
//    }
    init(duration: TimeInterval) {  // Accept the duration passed in the initializer
        self.duration = duration
        self.timeRemaining = duration
    }

    func startTimer() {
        stopTimer() 
//        timer?.invalidate()
        timeRemaining = duration // Reset the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    public static func convertDurationToTimeInterval(_ duration: Duration) -> TimeInterval {
        switch duration {
        case .none: return 0
        case .fast: return 30
        case .normal: return 60
        case .long: return 120
        }
    }
}
