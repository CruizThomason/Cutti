//
//  Barber.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import Foundation
import CloudKit

class Barber {
    
    fileprivate let usernameKey = "username"
    fileprivate let emailKey = "email"
    fileprivate let appleUserRefKey = "appleUserRef"
    fileprivate let latitudeKey = "latitude"
    fileprivate let longitudeKey = "longitude"
    fileprivate let passwordKey = "password"
    static let recordTypeKey = "Barber"
    
    
    var username: String
    var email: String
    var latitude: Double
    var longitude: Double
    var password: String
    
    let appleUserRef: CKReference
    
    var cloudKitRecordID: CKRecordID?
    
    init(username: String, email: String, appleUserRef: CKReference, latitude: Double, longitude: Double, password: String) {
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.latitude = latitude
        self.longitude = longitude
        self.password = password
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[usernameKey] as? String,
            let email = cloudKitRecord[emailKey] as? String,
            let appleUserRef = cloudKitRecord[appleUserRefKey] as? CKReference,
        // Add latitude and longitude here
            let latitude = cloudKitRecord[latitudeKey] as? Double,
            let longitude = cloudKitRecord[longitudeKey] as? Double,
            let password = cloudKitRecord[passwordKey] as? String
            else { return nil }
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.latitude = latitude
        self.longitude = longitude
        self.password = password
    }
}

extension CKRecord {
    
    convenience init(barber: Barber) {
        
        let recordID = barber.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Barber.recordTypeKey, recordID: recordID)
        
        self.setValue(barber.username, forKey: barber.usernameKey)
        self.setValue(barber.email, forKey: barber.emailKey)
        self.setValue(barber.appleUserRef, forKey: barber.appleUserRefKey)
        // Add latitude and longitude here
        self.setValue(barber.latitude, forKey: barber.latitudeKey)
        self.setValue(barber.longitude, forKey: barber.longitudeKey)
        self.setValue(barber.password, forKey: barber.passwordKey)
    }
}

