//
//  HapticsManager.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 19.10.2022.
//

import UIKit

class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

