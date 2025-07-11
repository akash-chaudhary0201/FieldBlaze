//
//  StockDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class StockDetailsVC: UIViewController {
    
    @IBOutlet weak var stockItemTable: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var stockDate: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockLineItemView: UIView!
    
    var stockId:String?
    
    var obj = StockTrackingService()
    
    var singleStock:StockDetailsModel?
    
    var stockLineItemsArray:[StockLineItemsModel] = []
    
    var isStockLineItemViewOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockItemTable.separatorStyle = .none
        
        stockLineItemView.isHidden = true
        
        Task{
            self.singleStock = await obj.getSingleStock(stockId!)
            self.customerName.text =  self.singleStock?.customerName
            self.stockDate.text = self.singleStock?.stockDate
            self.stockName.text = self.singleStock?.stockName
            
            //Calling function to get stock line items:
            await obj.getStockLineItems(stockId!)
            self.stockLineItemsArray = obj.stockLineItems
            
            DispatchQueue.main.async {
                self.stockItemTable.reloadData()
            }
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openStockLineItemView(_ sender: Any) {
        if isStockLineItemViewOpen {
            stockLineItemView.isHidden = true
            viewHeight.constant = 0
            isStockLineItemViewOpen = false
        } else {
            stockLineItemView.isHidden = false
            viewHeight.constant = CGFloat(stockLineItemsArray.count * 100)
            isStockLineItemViewOpen = true
        }
    }
}

extension StockDetailsVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockLineItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockItemTable.dequeueReusableCell(withIdentifier: "StockItemTabCell", for: indexPath) as! StockItemTabCell
        let singleItem = stockLineItemsArray[indexPath.row]
        
        cell.itemId.text = singleItem.itemName
        cell.itemName.text = singleItem.productName 
        cell.itemQuantity.text = "\(singleItem.itemQuantity)"
        
        return cell
    }
    
    
}

class StockItemTabCell: UITableViewCell{
    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
}
