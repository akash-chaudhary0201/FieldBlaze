//
//  AllData.swift
//  FieldBlaze
//
//  Created by Sakshi on 08/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct ActionItem {
    let actionTitle: String
    let actionImage: String
}

var actionCollectionData: [ActionItem] = [
    ActionItem(actionTitle: "Customers", actionImage: "customers"),
    ActionItem(actionTitle: "Order", actionImage: "order"),
    ActionItem(actionTitle: "Performance", actionImage: "performance"),
    ActionItem(actionTitle: "Work Day", actionImage: "WorkDay"),
    
    ActionItem(actionTitle: "Approvals", actionImage: "Approvals"),
    ActionItem(actionTitle: "Task", actionImage: "tasks"),
    ActionItem(actionTitle: "Expenses", actionImage: "Expenses"),
    ActionItem(actionTitle: "Beat Plan", actionImage: "Beatplan"),
    
    ActionItem(actionTitle: "Visit", actionImage: "Visit"),
    ActionItem(actionTitle: "Stock Track", actionImage: "stockTrack"),
    ActionItem(actionTitle: "Returns", actionImage: "returns"),
    ActionItem(actionTitle: "Collections", actionImage: "collections"),
    
    ActionItem(actionTitle: "Leave", actionImage: "leave"),
    ActionItem(actionTitle: "Announcement", actionImage: "announcement"),
    ActionItem(actionTitle: "Notes", actionImage: "notes"),
    
]

//Data for Daily Record Table :-
struct DailyRecord{
    let name: String
    let email: String
    let phone: String
    let company:String
    let isCompleted:Bool
}

var dailyRecordData: [DailyRecord] = [
    DailyRecord(name: "John Doe", email: "johndoe@example.com", phone: "+1234567890", company: "ABC Corporation", isCompleted: true),
    DailyRecord(name: "Jane Doe", email: "janedoe@example.com", phone: "+0987654321", company: "XYZ Company", isCompleted: false),
    DailyRecord(name: "Akash", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: false),
    DailyRecord(name: "Sumit", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: true),
    DailyRecord(name: "Rakshit", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: false)
]


struct SalesPersonDataStruct{
    let name:String
    let email:String
    let phone:String
}

struct TodoTasks{
    let title:String
    let description:String
    let isCompleted:Bool
    let id:String
}


