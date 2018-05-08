//
//  BarberController.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import Foundation
import CloudKit
import MapKit

class BarberController {
    
    static let shared = BarberController()
    
    var barbers: [Barber] = []
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    let currentBarberWasSetNotification = Notification.Name("currentBarberWasSet")
    
    var currentBarber: Barber? 
    
    func createBarberWith(username: String, email: String, latitude: Double, longitude: Double, password: String, photoData: Data?, completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let barber = Barber(username: username, email: email, appleUserRef: appleUserRef, latitude: latitude, longitude: longitude, password: password, photoData: photoData)
            
            let barberRecord = CKRecord(barber: barber)
            
            CKContainer.default().publicCloudDatabase.save(barberRecord) { (record, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let record = record, let currentBarber = Barber(cloudKitRecord: record) else { completion(false); return }
                
                self.currentBarber = currentBarber
                completion(true)
            }
        }
    }
    
    func fetchBarberWithEmailPassword(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "email == %@", email)
        let predicate2 = NSPredicate(format: "password == %@", password)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        
        let query = CKQuery(recordType: Barber.recordTypeKey, predicate: compoundPredicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { print(error.localizedDescription) }
            guard let firstRecord = records?.first else { completion(false); return }
            let barber = Barber(cloudKitRecord: firstRecord)
            self.currentBarber = barber
            
            completion(true)
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
    
    func fetchAllNearbyBarbersWith(userLocation: CLLocation, span: MKCoordinateSpan, completion: @escaping () -> Void) {
        
        //This is the farthest Lat point to the left
        let farthestLeft = userLocation.coordinate.latitude + span.latitudeDelta
        //This is the farthest Lat point to the right
        let farthestRight = userLocation.coordinate.latitude - span.latitudeDelta
        //This is the farthest Long point to the top
        let farthestTop = userLocation.coordinate.longitude + span.longitudeDelta
        //This is the farthest Long point to the bottom
        let farthestBottom = userLocation.coordinate.longitude - span.longitudeDelta

        let predicate1 = NSPredicate(format: "latitude < %lf", farthestLeft)
        let predicate2 = NSPredicate(format: "latitude > %lf", farthestRight)
        let predicate3 = NSPredicate(format: "longitude < %lf", farthestTop)
        let predicate4 = NSPredicate(format: "longitude > %lf", farthestBottom)

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        
        let query = CKQuery(recordType: Barber.recordTypeKey, predicate: compoundPredicate)
        
        let ckQueryOperation = CKQueryOperation(query: query)
        
        var records: [CKRecord] = []
        
        ckQueryOperation.recordFetchedBlock = { (record) in
            records.append(record)
        }
        
        ckQueryOperation.queryCompletionBlock = { (_, error) in
            
            
            if let error = error { print("Error fetching barbers for location: \(error)") }
            
            var barbers: [Barber] = []
            
            // This does the same thing as the for-in loop
            
            //            let barbers = records.compactMap({ Barber(cloudKitRecord: $0)})
            
            for barberRecord in records {
                guard let barber = Barber(cloudKitRecord: barberRecord) else { continue }
                barbers.append(barber)
            }
            
            self.barbers = barbers
            // This is Jade telling you to take out the pizza
            completion()
        }
        CKContainer.default().publicCloudDatabase.add(ckQueryOperation)
    }
}





