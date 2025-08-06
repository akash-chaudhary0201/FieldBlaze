//
//  LayoutModel.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 31/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//
struct LayoutModel {
    var sections: [LayoutSectionModel]

    init(dict: [String: Any]) {
        let sectionDicts = dict["sections"] as? [[String: Any]] ?? []
        self.sections = sectionDicts.map { LayoutSectionModel(dict: $0) }
    }
}

struct LayoutSectionModel {
    var heading: String
    var layoutRows: [LayoutRowModel]

    init(dict: [String: Any]) {
        self.heading = dict["heading"] as? String ?? ""
        let rows = dict["layoutRows"] as? [[String: Any]] ?? []
        self.layoutRows = rows.map { LayoutRowModel(dict: $0) }
    }
}

struct LayoutRowModel {
    var layoutItems: [LayoutItemModel]

    init(dict: [String: Any]) {
        let items = dict["layoutItems"] as? [[String: Any]] ?? []
        self.layoutItems = items.map { LayoutItemModel(dict: $0) }
    }
}


struct LayoutItemModel {
    var label: String
    var editableForNew: Bool
    var editableForUpdate: Bool
    var required: Bool
    var apiName: String

    init(dict: [String: Any]) {
        self.label = dict["label"] as? String ?? ""
        self.editableForNew = dict["editableForNew"] as? Bool ?? false
        self.editableForUpdate = dict["editableForUpdate"] as? Bool ?? false
        self.required = dict["required"] as? Bool ?? false

        if let components = dict["layoutComponents"] as? [[String: Any]],
           let firstComponent = components.first {
            self.apiName = firstComponent["apiName"] as? String ?? ""
        } else {
            self.apiName = ""
        }
    }
}
