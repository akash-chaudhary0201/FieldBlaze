//
//  VisitStockDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 09/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import DropDown

class VisitStockDetailsVC: UIViewController {
    
    @IBOutlet weak var selectProductLabel: UILabel!
    @IBOutlet weak var productDropDownView: UIView!
    
    var obj = StockTrackingService()
    
    var allProductDropDown = DropDown()
    var allProductNames:[String] = []
    
    @IBOutlet weak var addeddProductsTable: UITableView!
    
    var productNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            
//            await ProductsService.getAllProducts()
            
            addeddProductsTable.separatorStyle = .none
            
            self.allProductNames = GlobalData.allProducts.map{$0.name ?? "ak"}
            
            DropDownFunction.setupDropDown(dropDown: allProductDropDown, anchor: productDropDownView, dataSource: allProductNames, labelToUpdate: selectProductLabel)
        }
    }
    
    @IBAction func openProductsDropDown(_ sender: Any) {
        allProductDropDown.show()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Add product to the table action:
    @IBAction func addProductAction(_ sender: Any) {
        productNames.append(selectProductLabel.text!)
        DispatchQueue.main.async {
            self.addeddProductsTable.reloadData()
        }
    }
    
    
    @IBAction func proceedButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "RiskStockVC") as? RiskStockVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    @IBAction func skipButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "RiskStockVC") as? RiskStockVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

extension VisitStockDetailsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addeddProductsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddeddProductsTabCell
        
        cell.productName.text = productNames[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class AddeddProductsTabCell:UITableViewCell{
    @IBOutlet weak var productName: UILabel!
}
