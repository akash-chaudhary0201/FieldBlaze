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
    static var customerVisits = [VisitsModel]()
    //Products
    static var allProducts = [FetchedProductsModel]()
    static var productsAsStock = [ProductModelToSendAsStock]()
    static var productAccordingToPB = [FetchedProductPriceBook]()
    //Contacts
    static var allContacts = [ContactsModel]()
    //Price book
    static var allPriceBooks = [PriceBookModel]()
    //Sales order
    static var allOrder = [Orders]()
    static var customerOrders = [Orders]()
    static var salesOrderLineItem = [SalesOrderLineItemsModel]()
    static var salesOrderCart = [SalesCartModel]()
    //Schemes
    static var allSchemes = [SchemeModel]()
    //Tasks
    static var allTasks = [TaskModel]()
    //Announcements
    static var allAnnouncements = [AnnouncementModel]()
    //Stocks
    static var allStocks = [StockDetailsModel]()
    static var customerStocks = [StockDetailsModel]()
    static var stockLineItems = [StockLineItemsModel]()
    //Returns
    static var allReturns = [ReturnModel]()
    static var customerReturn = [ReturnModel]()
    static var returnLineItems = [ReturnLineItemModel]()
    //Zones
    static var allZones = [ZoneModel]()
    //Distributers
    static var allDistributer = [DistributerModel]()
    //Leaves
    static var allLeaves = [LeaveModel]()
    //Notes
    static var allNotes = [NotesModel]()
    //Beats
    static var allBeats = [BeatModel]()
    //Assigned customer to a beat:
    static var assignedAccounts = [AssignedAccountModel]()
    //Expense
    static var allExpenses = [ExpenseModel]()
    //DSR
    static var dsr = [DSRModel]()
    //Payment terms:
    static var allPaymentTerms = [PaymentTermsModel]()
    //Account type:
    static var accountType = [AccountTypeModel]()
    
    
    //--------------------------------------------------------------------//
    
    //Logged in user:
    static var loggedInUserInfo = [UserModel]()
    
    //Glpbal array to store the details of the stock item selected:
    static var globalSelectedStockItem = [ProductModelToSendAsStock]()
    
    //Global array to store selecte item to return:
    static var selectedReturnItem = [ItmeToReturnModel]()
}
