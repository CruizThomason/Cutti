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
    
    fileprivate let usernameKey = "username"
    fileprivate let emailKey = "email"
    fileprivate let appleUserRefKey = "appleUserRef"
    fileprivate let passwordKey = "password"
    static let recordTypeKey = "Client"
    
    var username: String
    var email: String
    var password: String
    
    
    let appleUserRef: CKReference
    
    var cloudKitRecordID: CKRecordID?
    
    init(username: String, email: String, appleUserRef: CKReference, password: String) {
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.password = password
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[usernameKey] as? String,
            let email = cloudKitRecord[emailKey] as? String,
            let appleUserRef = cloudKitRecord[appleUserRefKey] as? CKReference,
            let password = cloudKitRecord[passwordKey] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.password = password
    }
}

extension CKRecord {
    
    convenience init(client: Client) {
        
        let recordID = client.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Client.recordTypeKey, recordID: recordID)
        
        self.setValue(client.username, forKey: client.usernameKey)
        self.setValue(client.email, forKey: client.emailKey)
        self.setValue(client.appleUserRef, forKey: client.appleUserRefKey)
        self.setValue(client.password, forKey: client.passwordKey)
    }
}
