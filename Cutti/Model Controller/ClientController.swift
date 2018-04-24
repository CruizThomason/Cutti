//
//  ClientController.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import Foundation
import CloudKit

class ClientController {
    
    static let shared = ClientController()
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    let currentClientWasSetNotification = Notification.Name("currentClientWasSet")
    
    var currentClient: Client? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentClientWasSetNotification, object: nil)
            }
        }
    }
    
    func createClientWith(username: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let client = Client(username: username, email: email, appleUserRef: appleUserRef)
            
            let clientRecord = CKRecord(client: client)
            
            CKContainer.default().publicCloudDatabase.save(clientRecord) { (record, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let record = record, let currentClient = Client(cloudKitRecord: record) else { completion(false); return }
                
                self.currentClient = currentClient
                completion(true)
            }
        }
    }
    
    func fetchCurrentClient(completion: @escaping (_ success: Bool) -> Void = { _ in}) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "appleUserRef == %&", appleUserReference)
            
            self.cloudKitManager.fetchRecordsWithType(Client.recordTypeKey, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                guard let currentClientRecord = records?.first else { completion(false); return }
                
                let currentClient = Client(cloudKitRecord: currentClientRecord)
                
                self.currentClient = currentClient
                
                completion(true)
            })
        }
    }
    
    func updateCurrentClient(username: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let currentClient = currentClient else { completion(false); return }
        
        currentClient.username = username
        currentClient.email = email
        
        let currentClientRecord = CKRecord(client: currentClient)
        
        let op = CKModifyRecordsOperation(recordsToSave: [currentClientRecord], recordIDsToDelete: nil)
        
        op.modifyRecordsCompletionBlock = { (_,_, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            completion(true)
        }
        CKContainer.default().publicCloudDatabase.add(op)
    }
}



