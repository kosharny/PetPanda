//
//  ContentView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var vm: TestDataViewModel

    init(coreDataStack: CoreDataStack, importer: ContentImporter) {
        _vm = StateObject(wrappedValue: TestDataViewModel(coreDataStack: coreDataStack, importer: importer))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    if let error = vm.errorMessage {
                        Text(error).foregroundColor(.red)
                    }

                    // MARK: Articles
                    Group {
                        Text("Articles").font(.title2).bold()
                        ForEach(vm.articles) { article in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title).bold()
                                Text("Category: \(article.categoryId)").font(.subheadline).foregroundColor(.gray)
                                Text("Read time: \(article.readTime) min").font(.caption)
                                ProgressView(value: article.readProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                    .frame(height: 4)
                            }
                            .padding(4)
                        }
                    }

                    Divider()

                    // MARK: Care Guides
                    Group {
                        Text("Care Guides").font(.title2).bold()
                        ForEach(vm.guides) { guide in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(guide.title).bold()
                                Text("Difficulty: \(guide.difficulty)").font(.subheadline).foregroundColor(.gray)
                                Text("Duration: \(guide.duration) min").font(.caption)
                                Text("Steps: \(guide.steps.count)").font(.caption2)
                            }
                            .padding(4)
                        }
                    }

                    Divider()

                    // MARK: Quizzes
                    Group {
                        Text("Quizzes").font(.title2).bold()
                        ForEach(vm.quizzes) { quiz in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(quiz.title).bold()
                                Text("Duration: \(quiz.duration) min").font(.subheadline).foregroundColor(.gray)
                                Text("Questions: \(quiz.questions.count)").font(.caption)
                            }
                            .padding(4)
                        }
                    }

                }
                .padding()
            }
            .navigationTitle("PetPanda Test Data")
            .task {
                await vm.loadData()
            }
        }
    }
}
