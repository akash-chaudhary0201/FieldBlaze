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
    static var allCustomers = [Customer]()
    static var allApprovalRequest = [Approvals]()
    static var todaysVisits = [VisitsModel]()
    static var allVisits = [VisitsModel]()
    static var allProducts = [FetchedProductsModel]()
    static var allContacts = [ContactsModel]()
    static var allPriceBooks = [PriceBookModel]()
    static var allOrder = [Orders]()
    static var salesOrderLineItem = [SalesOrderLineItemsModel]()
    static var allSchemes = [SchemeModel]()
    static var allTasks = [TaskModel]()
    static var allAnnouncements = [AnnouncementModel]()
}
