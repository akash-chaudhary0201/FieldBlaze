//
//  StocksVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class StocksVC: UIViewController {
    
    @IBOutlet weak var allStockTables: UITableView?
    
    var obj = StockTrackingService()
    
    var allStocksArray:[StockDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allStockTables?.delegate = self
        allStockTables?.dataSource = self
        
        allStockTables?.separatorStyle = .none
        
        Task{
            await obj.getAllStocks()
//            print("Fetched stocks: \(obj.allStocks.count)")
            self.allStocksArray = obj.allStocks
//            print("All Stocks array:-------------------\(self.allStocksArray)")
            
            DispatchQueue.main.async {
                self.allStockTables?.reloadData()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToAddNewStockPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Stocks", bundle: nil)
        if let nextController = storyboard.instantiateViewController(identifier: "AddNewStockVC") as? AddNewStockVC {
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

extension StocksVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStocksArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockeTabCell", for: indexPath) as! StockeTabCell
        let singleStock = allStocksArray[indexPath.row]
        
        cell.customerName.text = singleStock.customerName
        cell.stockDate.text = singleStock.stockDate
        cell.stockName.text = singleStock.stockName
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStock = allStocksArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Stocks", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "StockDetailsVC") as? StockDetailsVC {
            nextController.stockId = singleStock.id
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

class StockeTabCell:UITableViewCell{
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var stockDate: UILabel!
    @IBOutlet weak var stockName: UILabel!
}
