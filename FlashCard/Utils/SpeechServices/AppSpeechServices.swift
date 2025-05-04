//
//  AppSpeechServices.swift
//  FlashCard
//
//  Created by tientm on 09/01/2024.
//

import NaturalLanguage
import AVFoundation

final class SpeechServices {
    
    static let shared = SpeechServices()
    
    private init() {}
    
    private let languageRecognizer = NLLanguageRecognizer()
    private let speechSynthesizer = AVSpeechSynthesizer()

    
    func speakOut(input: String) {
        languageRecognizer.processString(input)
        if let dominantLanguage = languageRecognizer.dominantLanguage {
            Log.info("languageRecognizer: \(dominantLanguage)")
            let utterance = AVSpeechUtterance(string: input)
            utterance.pitchMultiplier = 1.0
            utterance.rate = 0.5
            utterance.voice = AVSpeechSynthesisVoice(language: dominantLanguage.rawValue)
            speechSynthesizer.speak(utterance)
        }
    }
}
