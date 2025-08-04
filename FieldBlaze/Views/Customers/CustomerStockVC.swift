//
//  CustomerStockVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerStockVC: UIViewController {
    
    @IBOutlet weak var noDateImage: UIImageView!
    @IBOutlet weak var allStockTables: UITableView?
    
    var accountId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDateImage.isHidden = true
        allStockTables?.isHidden = false
        
        allStockTables?.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await StockTrackingService.getStockForAccount(accountId!)
            print(GlobalData.customerStocks)

            DispatchQueue.main.async {
                if GlobalData.customerStocks.isEmpty{
                    self.noDateImage.isHidden = false
                    self.allStockTables?.isHidden = true
                }else{
                    self.noDateImage.isHidden = true
                    self.allStockTables?.isHidden = false
                    self.self.allStockTables?.reloadData()
                }
                
            }
        }
    }
}

extension CustomerStockVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.customerStocks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockeTabCell", for: indexPath) as! StockeTabCell
        let singleStock = GlobalData.customerStocks[indexPath.row]
        
        cell.customerName.text = singleStock.customerName
        cell.stockDate.text = singleStock.stockDate
        cell.stockName.text = singleStock.stockName
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStock = GlobalData.customerStocks[indexPath.row]
        let storyboard = UIStoryboard(name: "Stocks", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "StockDetailsVC") as? StockDetailsVC {
            nextController.stockId = singleStock.id
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
