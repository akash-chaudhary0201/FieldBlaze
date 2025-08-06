//
//  CustomerService.swift
//  FieldBlaze
//
//  Created by Sakshi on 18/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

class CustomerService {
    let webRequest = BaseWebService()
    let endPoint = EndPoints()
    
    var allCustomerArray:[Customer] = []
    
    var singleCustomer:Customer?
    var paymentTerms:[PaymentTermsModel] = []
    
    //New function to get all customers:
    public static func getAllCustomers(_ userId:String) async{
        let soqlQuery = """
                SELECT Id, Name, CreatedDate,  ParentId, Type, PI_Payment_Terms__c, RE_Price_Book__r.Id, RE_Price_Book__r.Name, BillingAddress FROM Account where OwnerId = '\(userId)' ORDER BY CreatedDate DESC
            """
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return
        }
        
        GlobalData.allCustomers.removeAll()
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let customerDictArray = json["records"] as? [[String : Any]]{
                for customerDict in customerDictArray {
                    GlobalData.allCustomers.append(Customer(dict: customerDict))
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //Function to get a customer based on account id:
    public static func getCustomerBasedOnAccountId(_ accountId:String) async -> Customer?{
        let soqlQuery = "SELECT Id, Name, PH_WhatsApp_Number__c, Parent.Name,  Phone, Description, TX_Last_Name__c, TX_First_Name__c, TX_PAN__c, TX_GST__c, ParentId, CB_Is_Active__c, CB_Is_Primary__c,   Type, PI_Payment_Terms__c, RE_Price_Book__r.Id, RE_Price_Book__r.Name, RE_Zone__r.Name ,BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, CB_SameAsBilling__c, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet FROM Account Where Id = '\(accountId)'"
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return nil
            
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return nil
        }
        
        do{
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let customerDictArray = jsonData["records"] as? [[String: Any]],
               let firstCustomerDict = customerDictArray.first {
                let customer = Customer(dict: firstCustomerDict)
                return customer
                
            }
        }catch{
            print("error")
        }
        return nil
    }
    
    //Function to get all zone names:
    public static func getZoneNames() async{
        let soqlQuery = "Select Id, Name from Zone__c"
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            GlobalData.allZones.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for record in records{
                    GlobalData.allZones.append(ZoneModel(dict: record))
                }
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    //Function to get all distributers:
    public static func getDistributers()async{
        let soqlQuery = "SELECT Id, Name FROM Account where Type  = 'Distributor'"
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else{
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            GlobalData.allDistributer.removeAll()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
               let records = jsonData["records"] as? [[String:Any]]{
                for record in records{
                    GlobalData.allDistributer.append(DistributerModel(dict: record))
                }
            }
        }catch{
            print("Error")
        }
    }
    
//    //Function to get payment terms names:
//    func getPaymentTermsNames() async{
//        let soqlQuery = "Select PI_Payment_Terms__c from Account where PI_Payment_Terms__c!=null"
//        
//        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let instanceUrl = Defaults.instanceUrl else {
//            return
//        }
//        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
//        
//        guard let url = URL(string: fullUrl) else{
//            return
//        }
//        
//        do{
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
//            
//            GlobalData.allPaymentTerms.removeAll()
//            
//            let (data, _) = try await URLSession.shared.data(for: request)
//            
//            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
//               let records = jsonData["records"] as? [[String:Any]]{
//                for record in records{
////                    GlobalData.allPaymentTerms.append(PaymentTermsModel)
//                }
//            }
//        }catch{
//            print("Error: \(error)")
//        }
//    }
    
    //Function to get all Account based on zone:
    func geAccountBasedOnZone(_ zoneId:String, _ userId:String)async{
        let soqlQuery = """
                          SELECT Id, Name, CreatedDate, Owner.Name, OwnerId,   ParentId, Type, PI_Payment_Terms__c, Phone,  RE_Price_Book__r.Id, RE_Price_Book__r.Name, BillingCity FROM Account where RE_Zone__r.Id = '\(zoneId)' and OwnerId  = '\(userId)' ORDER BY CreatedDate DESC
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.allCustomers.removeAll()
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let customerDictArray = json["records"] as? [[String : Any]]{
                for customerDict in customerDictArray {
                    GlobalData.allCustomers.append(Customer(dict: customerDict))
                }
            }
        }catch{
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //Function to get all Account based on distributer:
    func geAccountBasedOnDistributer(_ distributerId:String)async{
        let soqlQuery = """
                        SELECT Id, Name, CreatedDate, Owner.Name,  ParentId, Type, PI_Payment_Terms__c, Phone,  RE_Price_Book__r.Id, RE_Price_Book__r.Name, BillingCity  FROM Account where Type  = 'Distributor' and Parent.Id  = '\(distributerId)' ORDER BY CreatedDate DESC
            """
        
        guard let encodedQuery = soqlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instanceUrl = Defaults.instanceUrl else {
            return
        }
        
        let fullUrl = "\(instanceUrl)/services/data/v59.0/query/?q=\(encodedQuery)"
        
        guard let url = URL(string: fullUrl) else {
            return
        }
        
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(Defaults.accessToken!)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            GlobalData.allCustomers.removeAll()
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let customerDictArray = json["records"] as? [[String : Any]]{
                for customerDict in customerDictArray {
                    GlobalData.allCustomers.append(Customer(dict: customerDict))
                }
            }
        }catch{
            print("Error: \(error.localizedDescription)")
        }
    }
}
