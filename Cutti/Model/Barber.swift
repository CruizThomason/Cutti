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
    
    static let usernameKey = "username"
    static let emailKey = "email"
    static let appleUserRefKey = "appleUserRef"
    static let recordTypeKey = "User"
    
    var username: String
    var email: String
    
    
    let appleUserRef: CKReference
    
    var cloudKitRecordID: CKRecordID?
    
    init(username: String, email: String, appleUserRef: CKReference) {
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[Barber.usernameKey] as? String,
            let email = cloudKitRecord[Barber.emailKey] as? String,
            let appleUserRef = cloudKitRecord[Barber.appleUserRefKey] as? CKReference else { return nil }
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

extension CKRecord {
    
    convenience init(barber: Barber) {
        
        let recordID = barber.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Barber.recordTypeKey, recordID: recordID)
        
        self.setValue(barber.username, forKey: Barber.usernameKey)
        self.setValue(barber.email, forKey: Barber.emailKey)
        self.setValue(barber.appleUserRef, forKey: Barber.appleUserRefKey)
    }
}

