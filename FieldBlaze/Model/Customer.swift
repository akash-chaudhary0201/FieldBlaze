import Foundation

struct Customer {
    
    var id: String?
    var name: String?
    var type: String?
    var parentId: String?
    var parentName: String?
    
    var ownerName:String?
    
    var txFirstName: String?
    var txLastName: String?
    var txPAN: String?
    var txGST: String?
    
    var phone: String?
    var whatsapp: String?
    
    var billingStreet: String?
    var billingCity: String?
    var billingState: String?
    var billingCountry: String?
    var billingPostalCode: String?
    
    var shippingStreet: String?
    var shippingCity: String?
    var shippingState: String?
    var shippingCountry: String?
    var shippingPostalCode: String?
    
    var cbSameAsBilling: String?
    var cbIsPrimary: String?
    var cbIsActive: String?
    
    var piPaymentTerms: String?
    
    var reZoneId: String?
    var reZoneName:String?
    var rePriceBookId: String?
    var rePriceBookName: String?
    
    var description:String?
    
    init(dict: [String: Any]) {
        self.id = dict["Id"] as? String
        self.name = dict["Name"] as? String
        self.type = dict["Type"] as? String
        
        self.parentId = dict["ParentId"] as? String
        if let parent = dict["Parent"] as? [String: Any] {
            self.parentName = parent["Name"] as? String
        }
        
        self.txFirstName = dict["TX_First_Name__c"] as? String
        self.txLastName = dict["TX_Last_Name__c"] as? String
        self.txPAN = dict["TX_PAN__c"] as? String
        self.txGST = dict["TX_GST__c"] as? String
        
        self.phone = dict["Phone"] as? String
        self.whatsapp = dict["PH_WhatsApp_Number__c"] as? String
        
        self.billingStreet = dict["BillingStreet"] as? String
        self.billingCity = dict["BillingCity"] as? String
        self.billingState = dict["BillingState"] as? String
        self.billingCountry = dict["BillingCountry"] as? String
        self.billingPostalCode = dict["BillingPostalCode"] as? String
        
        self.shippingStreet = dict["ShippingStreet"] as? String
        self.shippingCity = dict["ShippingCity"] as? String
        self.shippingState = dict["ShippingState"] as? String
        self.shippingCountry = dict["ShippingCountry"] as? String
        self.shippingPostalCode = dict["ShippingPostalCode"] as? String
        
        if let zoneDet = dict["RE_Zone__r"] as? [String:Any]{
            self.reZoneName = zoneDet["Name"] as? String
        }
        
        self.cbSameAsBilling = dict["CB_SameAsBilling__c"] as? String
        self.cbIsPrimary = dict["CB_Is_Primary__c"] as? String
        self.cbIsActive = dict["CB_Is_Active__c"] as? String
        
        self.piPaymentTerms = dict["PI_Payment_Terms__c"] as? String
        
        self.reZoneId = dict["RE_Zone__c"] as? String
        
        if let priceBook = dict["RE_Price_Book__r"] as? [String: Any] {
            self.rePriceBookId = priceBook["Id"] as? String
            self.rePriceBookName = priceBook["Name"] as? String
        }
        
        if let owner = dict["Owner"] as? [String:Any]{
            self.ownerName = owner["Name"] as? String
        }
        
        self.description = dict["Description"] as? String
    }
}

