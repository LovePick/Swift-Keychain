//
//  ViewController.swift
//  KeychainExample
//
//  Created by Supapon Pucknavin on 23/12/2565 BE.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPassword()
        
    }
    
    func getPassword() {
        
        guard let data = KeychainManager.get(service: "facebook.com", account: "pick") else {
            print("Failed to read password")
            return
        }
        
        let password = String(decoding: data, as: UTF8.self)
        print("ReadPassword: \(password)")
    }
    
    func save() {
        do {
            try KeychainManager.save(service: "facebook.com", account: "pick", password: "something".data(using: .utf8) ?? Data())
            
        } catch {
            print(error)
        }
    }
    
}
class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
        
    }
    static func save(service: String, account: String, password: Data) throws {
        // service, account, password, class,
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("Saved")
    }
    
    
    static func get(service: String, account: String) -> Data? {
        
        // service, account, class, return-data, matchlimit
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        
        print("Read status: \(status)")
        
        return result as? Data
    }
    
    
    
}



