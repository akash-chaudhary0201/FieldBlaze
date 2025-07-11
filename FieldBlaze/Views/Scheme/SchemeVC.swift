//
//  SchemeVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 22/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class SchemeVC: UIViewController {
    
    @IBOutlet weak var schemesTable: UITableView!
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    
    var selectedButtonTagNumber:Int?
    
    var schemeObj = SchemeService()
    
    var allSchemesArray:[SchemeModel] = []
    var filteredSchemeArray:[SchemeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        schemesTable.separatorStyle = .none
        
        Task {
            await schemeObj.getAllSchemes()
            self.allSchemesArray = schemeObj.schemesArray
            self.filteredSchemeArray = self.allSchemesArray
            self.schemesTable.reloadData()
        }

    }

    @IBAction func schemeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func collectionActions(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Button 1 tapped")
            selectedButtonTagNumber = 0
            filteredSchemeArray = allSchemesArray
            self.schemesTable.reloadData()
            
            allButton.backgroundColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
            allButton.setTitleColor(.white, for: .normal)
            orderButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            orderButton.backgroundColor = .white
            productButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            productButton.backgroundColor = .white
            
        case 1:
            print("Button 2 tapped")
            selectedButtonTagNumber = 1
            filterScheme("Order")
            self.schemesTable.reloadData()
            
            orderButton.backgroundColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
            orderButton.setTitleColor(.white, for: .normal)
            allButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            allButton.backgroundColor = .white
            productButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            productButton.backgroundColor = .white

        case 2:
            print("Button 3 tapped")
            selectedButtonTagNumber = 2
            filterScheme("Product")
            self.schemesTable.reloadData()
            
            productButton.backgroundColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
            productButton.setTitleColor(.white, for: .normal)
            allButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            allButton.backgroundColor = .white
            orderButton.setTitleColor(UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255), for: .normal)
            orderButton.backgroundColor = .white
            
        default:
            break
        }
    }
    
    func filterScheme(_ schemeType: String) {
        filteredSchemeArray = allSchemesArray.filter { scheme in
            scheme.schemeType == schemeType
            
        }
    }

}

extension SchemeVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchemeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = schemesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchemeTabCell
        let singleScheme = filteredSchemeArray[indexPath.row]

        cell.schemeNameLabel.text = singleScheme.schemeName
        cell.schemeType.text = singleScheme.schemeType
        if singleScheme.minimumOrder == "<null>"{
            cell.minimumOrderValue.text = "0"
        }else{
            cell.minimumOrderValue.text = singleScheme.minimumOrder
        }
        cell.duration.text = "\(singleScheme.startDate) to \(singleScheme.endDate)"
        cell.discountType.text = singleScheme.discountType
        cell.schemeCode.text = singleScheme.schemeCode
        if singleScheme.schemeStatus == "1"{
            cell.schemeStatus.text = "Active"
        }
        cell.discountValue.text = singleScheme.discountValue
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class SchemeTabCell: UITableViewCell{
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var discountValue: UILabel!
    @IBOutlet weak var discountType: UILabel!
    @IBOutlet weak var schemeCode: UILabel!
    @IBOutlet weak var minimumOrderValue: UILabel!
    @IBOutlet weak var schemeType: UILabel!
    @IBOutlet weak var schemeStatus: UILabel!
    @IBOutlet weak var schemeNameLabel: UILabel!
}
