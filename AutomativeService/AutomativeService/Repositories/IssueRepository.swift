//
//  IssueRepository.swift
//  AutomativeService
//
//  Created by Sergey Morenko on 12/11/17.
//  Copyright © 2017 Sergey Morenko. All rights reserved.
//

import Foundation
import SQLite

final class IssueRepository {
    
    private let _table = Table("Issue")
    static let instance = IssueRepository()
    
    private init(){
    }
    
    public func createTable() throws {
        
        let tableQuery = _table.create(ifNotExists: true){ t in
            t.column(Columns.id, primaryKey: true)
            t.column(Columns.firstName)
            t.column(Columns.lastName)
            t.column(Columns.phone)
            t.column(Columns.email)
            t.column(Columns.vehicleColor)
            t.column(Columns.vehiclePC)
            t.column(Columns.vehicleMake)
            t.column(Columns.vehicleModel)
            t.column(Columns.vehicleVIN)
            t.column(Columns.workNeeded)
            t.column(Columns.dayNeeded)
            t.column(Columns.estimate)
            t.column(Columns.contactPreference)
        }
        
        try DataStore.instance.db.run(tableQuery)
    }
    
    public func getAll() -> [IssueEntity] {
        var result = [IssueEntity]()
        
        if let rows = try? DataStore.instance.db.prepare(_table){
            rows.forEach{ row in
                let item = IssueEntity(id: row[Columns.id], dayNeeded: row[Columns.dayNeeded], estimate: row[Columns.estimate])
                item.firstName = row[Columns.firstName]
                item.lastName = row[Columns.lastName]
                item.phone = row[Columns.phone]
                item.email = row[Columns.email]
                item.vehicleColor = row[Columns.vehicleColor]
                item.vehiclePC = row[Columns.vehiclePC]
                item.vehicleMake = row[Columns.vehicleMake]
                item.vehicleModel = row[Columns.vehicleModel]
                item.vehicleVIN = row[Columns.vehicleVIN]
                item.workNeeded = row[Columns.workNeeded]
                item.contactPreference = ContactPreference(rawValue: row[Columns.contactPreference]) ?? ContactPreference.any
                
                result.append(item)
            }
        }
        return result
    }
    
    public func saveOrUpdate(entity: IssueEntity) -> Void {
        _ = try? DataStore.instance.db.transaction {[unowned self] in
            if entity.isNew {
                let query = self._table.insert(Columns.firstName <- entity.firstName,
                                               Columns.lastName <- entity.lastName,
                                               Columns.phone <- entity.phone,
                                               Columns.email <- entity.email,
                                               Columns.vehicleColor <- entity.vehicleColor,
                                               Columns.vehiclePC <- entity.vehiclePC,
                                               Columns.vehicleMake <- entity.vehicleMake,
                                               Columns.vehicleModel <- entity.vehicleModel,
                                               Columns.vehicleVIN <- entity.vehicleVIN,
                                               Columns.workNeeded <- entity.workNeeded,
                                               Columns.dayNeeded <- entity.dayNeeded,
                                               Columns.estimate <- entity.estimate,
                                               Columns.contactPreference <- entity.contactPreference.rawValue)
                
                if let id  = try? DataStore.instance.db.run(query){
                    entity.id = id
                }
            } else {
                let query = self._table.filter(Columns.id == entity.id)
                    .update(Columns.firstName <- entity.firstName,
                            Columns.lastName <- entity.lastName,
                            Columns.phone <- entity.phone,
                            Columns.email <- entity.email,
                            Columns.vehicleColor <- entity.vehicleColor,
                            Columns.vehiclePC <- entity.vehiclePC,
                            Columns.vehicleMake <- entity.vehicleMake,
                            Columns.vehicleModel <- entity.vehicleModel,
                            Columns.vehicleVIN <- entity.vehicleVIN,
                            Columns.workNeeded <- entity.workNeeded,
                            Columns.dayNeeded <- entity.dayNeeded,
                            Columns.estimate <- entity.estimate,
                            Columns.contactPreference <- entity.contactPreference.rawValue)
               _ = try? DataStore.instance.db.run(query)
            }
        }
    }
    
    public func remove(entity: IssueEntity) -> Void {
        _ = _table.filter(Columns.id == entity.id).delete()
    }
    
    private struct Columns {
        static let id = Expression<Int64>("id")
        static let firstName = Expression<String>("firstName")
        static let lastName = Expression<String>("lastName")
        static let phone = Expression<String>("phone")
        static let email = Expression<String>("email")
        static let vehicleColor = Expression<String>("vehicleColor")
        static let vehiclePC = Expression<String>("vehiclePC")
        static let vehicleMake = Expression<String>("vehicleMake")
        static let vehicleModel = Expression<String>("vehicleModel")
        static let vehicleVIN = Expression<String>("vehicleVIN")
        static let workNeeded = Expression<String>("workNeeded")
        static let dayNeeded = Expression<Int>("dayNeeded")
        static let estimate = Expression<Date>("estimate")
        static let contactPreference = Expression<String>("contactPreference")
    }
}
