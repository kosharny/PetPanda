//
//  PetPandaApp.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI
import CoreData

@main
struct PetPandaApp: App {
//    let persistenceController = PersistenceController.shared
    let container = PersistenceController.shared.container
//    let coreDataStack = CoreDataStack()
//    var importer: ContentImporter {
//            ContentImporter(coreDataStack: coreDataStack)
//        }
    
    
    var body: some Scene {
        WindowGroup {
            RootView(conteiner: container)
//            ContentView(coreDataStack: coreDataStack, importer: importer)
//                .onAppear {
//                    importContentIfNeeded()
//                }
        }
    }
    
//    private func importContentIfNeeded() {
//        let importer = ContentImporter(
//            coreDataStack: coreDataStack
//        )
//        
//        DispatchQueue.global(qos: .userInitiated).async {
////            try? importer.importAll()
//        }
//    }
}
