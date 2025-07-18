//
//  GlobalData.swift
//  FieldBlaze
//
//  Created by Sakshi on 20/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation
import UIKit

class GlobalData: NSObject {
    //Customers
    static var allCustomers = [Customer]()
    //Approvals
    static var allApprovalRequest = [Approvals]()
    //Visits
    static var todaysVisits = [VisitsModel]()
    static var allVisits = [VisitsModel]()
    //Products
    static var allProducts = [FetchedProductsModel]()
    static var productsAsStock = [ProductModelToSendAsStock]()
    //Contacts
    static var allContacts = [ContactsModel]()
    //Price book
    static var allPriceBooks = [PriceBookModel]()
    //Sales order
    static var allOrder = [Orders]()
    static var salesOrderLineItem = [SalesOrderLineItemsModel]()
    //Schemes
    static var allSchemes = [SchemeModel]()
    //Tasks
    static var allTasks = [TaskModel]()
    //Announcements
    static var allAnnouncements = [AnnouncementModel]()
    //Stocks
    static var allStocks = [StockDetailsModel]()
    static var stockLineItems = [StockLineItemsModel]()
    //Returns
    static var allReturns = [ReturnModel]()
    static var returnLineItems = [ReturnLineItemModel]()
    //Zones
    static var allZones = [ZoneModel]()
    //Distributers
    static var allDistributer = [DistributerModel]()
    
    
    
    //Glpbal array to store the details of the stock item selected:
    static var globalSelectedStockItem = [ProductModelToSendAsStock]()
}
