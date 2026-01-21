//
//  CareViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

@MainActor
final class CareViewModel: ObservableObject {
    // MARK: - State
    @Published var isGuideStarted: Bool = false
    @Published private(set) var guide: CareGuide?
    @Published var currentStepIndex: Int = 0
    @Published var notesText: String = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var isFavorite = false
    @Published private(set) var readProgress: Double = 0.0


    private let careId: String
    private let repository: CareGuideRepository
    private let favorites: FavoritesRepository
    
    var currentStep: CareGuideStep? {
        guard let guide = guide, currentStepIndex < guide.steps.count else { return nil }
        return guide.steps[currentStepIndex]
    }
    
    var totalSteps: Int {
        guide?.steps.count ?? 0
    }
    
    var progressTitle: String {
        "Step \(currentStepIndex + 1) of \(totalSteps)"
    }
    
    var firstSentenceOfContent: String {
        guard let firstStep = guide?.steps.first,
              let firstParagraph = firstStep.content.first else {
            return ""
        }
        
        if let firstDotIndex = firstParagraph.firstIndex(of: ".") {
            return String(firstParagraph[...firstDotIndex])
        }
        
        return firstParagraph
    }
    
    var firstSentence: String {
        guide?.steps.first?.content.first?.components(separatedBy: ".").first ?? ""
    }

    init(
        careId: String,
        repository: CareGuideRepository,
        favorites: FavoritesRepository
    ) {
        self.careId = careId
        self.repository = repository
        self.favorites = favorites
    }
    
    func startGuide() {
        isGuideStarted = true
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        
        currentStepIndex = 0
        
        do {
            let allGuides = try repository.fetchAll()
            guard let foundGuide = allGuides.first(where: { $0.id == careId }) else {
                throw NSError(domain: "CareViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Guide not found"])
            }
            self.guide = foundGuide
        
            if let savedProgress = try? repository.fetchProgress(guideId: careId) {
                self.currentStepIndex = Int(savedProgress.currentStepIndex)
                if savedProgress.isCompleted {
                    self.readProgress = 1.0
                } else {
                    calculateProgress()
                }
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isFavorite = favorites.isFavorite(id: careId, type: .care)
        isLoading = false
    }

    func nextStep() {
        guard let guide = guide, currentStepIndex < guide.steps.count - 1 else { return }
        currentStepIndex += 1
        calculateProgress()
        saveProgress()
    }

    func prevStep() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
        calculateProgress()
        saveProgress()
    }

    func completeGuide() {
        self.readProgress = 1.0
        saveProgress(completed: true)
    }
    
    func toggleFavorite() {
        favorites.toggle(id: careId, type: .care)
        isFavorite = favorites.isFavorite(id: careId, type: .care)
    }

    private func calculateProgress() {
        guard totalSteps > 0 else { return }
        
        if currentStepIndex == 0 {
            self.readProgress = 0.0
            return
        }
        
        let calculated = (Double(currentStepIndex) / Double(totalSteps)) * 0.9
        
        if calculated > self.readProgress {
            self.readProgress = calculated
        }
    }

    private func saveProgress(completed: Bool = false) {
        try? repository.updateProgress(
            guideId: careId,
            stepIndex: currentStepIndex,
            completed: completed
        )
    }
}
