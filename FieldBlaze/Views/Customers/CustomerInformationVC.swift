//
//  CustomerInformationVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerInformationVC: UIViewController {
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var customerDetailCollection: UICollectionView!
    
    @IBOutlet weak var customerDetailsView: UIView!
    
    var detailCollectionArray:[String] = ["Detail", "Contacts", "Orders", "Beat Plan", "Visits", "Stocks", "Returns"]
    var customerName:String?
    var customerId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------------------------------
        let storyboard = UIStoryboard(name:"Customers", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
        secondVC.accountId = self.customerId
        
        addChild(secondVC)
        secondVC.view.frame = customerDetailsView.bounds
        customerDetailsView.addSubview(secondVC.view)
        secondVC.didMove(toParent: self)
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomerInformationVC:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailCollectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = customerDetailCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailCustomerCell
        cell.detailLabel.text = detailCollectionArray[indexPath.row]
        cell.cellView.backgroundColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
        cell.cellView.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Logic to remove previously added views:
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        //Logic to add view now:
        let storyboard = UIStoryboard(name: "Customers", bundle: nil)
        var newVC: UIViewController?
        
        switch indexPath.row {
        case 0:
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
                detailVC.accountId = customerId  
                newVC = detailVC
            }
        case 1:
            if let contactVC = storyboard.instantiateViewController(withIdentifier: "CustomersContactVC") as? CustomersContactVC{
                contactVC.accountId = customerId
                newVC = contactVC
            }
        default:
            print("Not implemented yet")
            return
        }
        
        if let secondVC = newVC {
            addChild(secondVC)
            secondVC.view.frame = customerDetailsView.bounds
            customerDetailsView.addSubview(secondVC.view)
            secondVC.didMove(toParent: self)
        }
    }
}

class DetailCustomerCell:UICollectionViewCell{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
}

struct CustomerTableStruct {
    let title: String
    let value: String
}

class CustomerOrderCell:UITableViewCell{
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesPersonLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
}
