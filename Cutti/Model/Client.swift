//
//  Client.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import Foundation
import CloudKit

class Client {
    
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
        guard let username = cloudKitRecord[Client.usernameKey] as? String,
            let email = cloudKitRecord[Client.emailKey] as? String,
            let appleUserRef = cloudKitRecord[Client.appleUserRefKey] as? CKReference else { return nil }
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
}

extension CKRecord {
    
    convenience init(client: Client) {
        
        let recordID = client.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Client.recordTypeKey, recordID: recordID)
        
        self.setValue(client.username, forKey: Client.usernameKey)
        self.setValue(client.email, forKey: Client.emailKey)
        self.setValue(client.appleUserRef, forKey: Client.appleUserRefKey)
    }
}
