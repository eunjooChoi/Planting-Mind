//
//  SettingsView.swift
//  PlantingMind
//
//  Created by 최은주 on 4/9/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SettingsViewModel
    
    @State var showImporter: Bool = false
    @State var showExporter: Bool = false
    @State var showImportAlert: Bool = false
    @State var showEmptyRecordAlert: Bool = false
    @State var showExportSuccessAlert: Bool = false
    @State var showImportSuccessAlert: Bool = false
    
    @State private var importedURL: URL = URL(string: "www.apple.com")!
    
    var body: some View {
        NavigationStack() {
            List {
                Section {
                    Button(action: {
                        if viewModel.checkExportable() {
                            showExporter.toggle()
                        } else {
                            showEmptyRecordAlert.toggle()
                        }
                    }, label: {
                        Text("export")
                            .foregroundStyle(Color.Custom.general)
                    })
                    .fileExporter(isPresented: $showExporter,
                                  document: viewModel.setupMindDocument(),
                                  contentType: .mind,
                                  defaultFilename: "Planting-Mind-Backup") { result in
                        switch result {
                        case .success:
                            showExportSuccessAlert.toggle()
                        case .failure(let error):
                            let _ = print(error.localizedDescription )
                        }
                    }
                    .alert("empty_record", isPresented: $showEmptyRecordAlert) {
                        Button("ok", role: .cancel) { }
                    }
                    .alert("export_success", isPresented: $showExportSuccessAlert) {
                        Button("ok", role: .cancel) { }
                    }
                    
                    Button(action: {
                        showImporter.toggle()
                    }, label: {
                        Text("import")
                            .foregroundStyle(Color.Custom.general)
                    })
                    .fileImporter(isPresented: $showImporter, allowedContentTypes: [.mind], onCompletion: { result in
                        switch result {
                        case .success(let url):
                            importedURL = url
                            showImportAlert.toggle()
                        case .failure(let error):
                            let _ = print(error.localizedDescription )
                        }
                    })
                    .alert("import_remove_all_record_alert", isPresented: $showImportAlert) {
                        Button("ok", role: .destructive) {
                            viewModel.importData(url: importedURL)
                        }
                        
                        Button("cancel", role: .cancel) { }
                    }
                    .alert("import_success", isPresented: $viewModel.showImportSuccessAlert) {
                        Button("ok", role: .cancel) { }
                    }
                }
            }
            .navigationTitle("settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.Custom.general)
                    })
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(context: CoreDataStack(.inMemory).persistentContainer.viewContext))
}
