//
//  DataStore.swift
//  AutomativeService
//
//  Created by Sergey Morenko on 12/11/17.
//  Copyright © 2017 Sergey Morenko. All rights reserved.
//

import Foundation
import SQLite

final class DataStore {
    static let instance = DataStore()
    public let db: Connection!
    
    private init(){
        let fileName = "TinyAutomativeService.sqlite"
        
        let dirs = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString]
        
        let path = dirs[0].appendingPathComponent(fileName)
        print(path)
        
        db = try! Connection(path)
        
    }
    
    func create() throws {
        try IssueRepository.instance.createTable()
    }
}
