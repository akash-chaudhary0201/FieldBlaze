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
    
    @IBOutlet weak var containerView: UIView!
    
    var currentChildVC: UIViewController?
    
    var detailCollectionArray:[String] = ["Detail", "Contacts", "Orders", "Beat Plan", "Visits", "Stocks", "Returns"]
    var customerName:String?
    var customerId:String?
    
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerDetailCollection.allowsMultipleSelection = false
        
        let indexPath = IndexPath(item: 0, section: 0)
        customerDetailCollection.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.collectionView(customerDetailCollection, didSelectItemAt: indexPath)
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
        let title = detailCollectionArray[indexPath.row]
        cell.configure(text: title, isSelected: indexPath.row == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        customerDetailCollection.reloadData()
        
        if let current = currentChildVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        let selectedItem = detailCollectionArray[indexPath.row]
        var newVC: UIViewController?
        
        let storyboard = UIStoryboard(name: "Customers", bundle: nil)
        
        switch selectedItem {
        case "Detail":
            if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        case "Contacts":
            if let vc = storyboard.instantiateViewController(withIdentifier: "CustomerContactVC") as? CustomerContactVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        case "Orders":
            if let vc = storyboard.instantiateViewController(withIdentifier: "CustomerOrderVC") as? CustomerOrderVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        case "Beat Plan":
            newVC = storyboard.instantiateViewController(withIdentifier: "CustomerBeatVC")
        case "Visits":
            if let vc = storyboard.instantiateViewController(withIdentifier: "CustomerVisitVC") as? CustomerVisitVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        case "Stocks":
            if let vc = storyboard.instantiateViewController(withIdentifier: "CustomerStockVC") as? CustomerStockVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        case "Returns":
            if let vc = storyboard.instantiateViewController(withIdentifier: "CustomerReturnVC") as? CustomerReturnVC {
                vc.accountId = self.customerId
                newVC = vc
            }
        default:
            break
        }
        
        guard let childVC = newVC else { return }
        
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        
        currentChildVC = childVC
    }
}

class DetailCustomerCell:UICollectionViewCell{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    let bottomBorder = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomBorder.backgroundColor = UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            bottomBorder.heightAnchor.constraint(equalToConstant: 2),
            bottomBorder.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: cellView.trailingAnchor)
        ])
    }
    
    func configure(text: String, isSelected: Bool) {
        detailLabel.text = text
        detailLabel.textColor = isSelected ? UIColor(red: 62/255, green: 197/255, blue: 154/255, alpha: 255/255) : .black
        bottomBorder.isHidden = !isSelected
    }
}

