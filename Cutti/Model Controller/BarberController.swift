//
//  BarberController.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import Foundation
import CloudKit

class BarberController {
    
    static let shared = BarberController()
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    let currentBarberWasSetNotification = Notification.Name("currentBarberWasSet")
    
    var currentBarber: Barber? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentBarberWasSetNotification, object: nil)
            }
        }
    }
    
    func createBarberWith(username: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let barber = Barber(username: username, email: email, appleUserRef: appleUserRef)
            
            let barberRecord = CKRecord(barber: barber)
            
            CKContainer.default().publicCloudDatabase.save(barberRecord) { (record, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let record = record, let currentBarber = Barber(cloudKitRecord: record) else { completion(false); return }
                
                self.currentBarber = currentBarber
                completion(true)
            }
        }
    }
    
    func fetchCurrentBarber(completion: @escaping (_ success: Bool) -> Void = { _ in}) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print(error.localizedDescription) }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserReference)
            
            self.cloudKitManager.fetchRecordsWithType(Barber.recordTypeKey, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                guard let currentBarberRecord = records?.first else { completion(false); return }
                
                let currentBarber = Barber(cloudKitRecord: currentBarberRecord)
                
                self.currentBarber = currentBarber
                
                completion(true)
            })
        }
    }
    
    func updateCurrentBarber(username: String, email: String, completion: @escaping ( _ success: Bool) -> Void) {
        
        guard let currentBarber = currentBarber else { completion(false); return }
        
        currentBarber.username = username
        currentBarber.email = email
        
        let currentBarberRecord = CKRecord(barber: currentBarber)
        
        let op = CKModifyRecordsOperation(recordsToSave: [currentBarberRecord], recordIDsToDelete: nil)
        
        op.modifyRecordsCompletionBlock = { (_,_, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            completion(true)
        }
        CKContainer.default().publicCloudDatabase.add(op)
    }
}





