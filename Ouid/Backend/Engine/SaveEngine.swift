//
//  File.swift
//  
//
//  Created by Kevin Laminto on 6/4/21.
//

import Foundation

struct SaveEngine {
    var savedEntries = [Entry]()
    
    struct SaveData: Codable {
        let savedEntries: [Entry]
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("SavedDatas")
            
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                
                let savedData = try decoder.decode(SaveData.self, from: data)
                self.savedEntries = savedData.savedEntries
            }
        } catch let error {
            fatalError(error.localizedDescription)
            
        }
    }
    
    public mutating func save(_ entry: Entry) {
        if savedEntries.contains(entry) {
            savedEntries.removeAll(where: { $0 == entry })
        } else {
            savedEntries.append(entry)
        }
        
        save()
    }
    
    /**
     This function will delete the stored datas inside the app. (faovurited items, resident, etc)
     */
    public func deleteAppData() {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path

        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                    if fileName == "SavedDatas" {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
            }

        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    // MARK: - Private methods
    private func save() {
        do {
            let savedData = SaveData(savedEntries: savedEntries)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving data: \(error.localizedDescription)")
        }
        
        encoder.dataEncodingStrategy = .base64
    }
}
