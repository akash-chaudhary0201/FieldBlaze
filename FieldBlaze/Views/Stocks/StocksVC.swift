//
//  StocksVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class StocksVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var allStockTables: UITableView?
    @IBOutlet weak var stockSearchBar: UISearchBar!

    var filteredStocks:[StockDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allStockTables?.delegate = self
        allStockTables?.dataSource = self
        
        allStockTables?.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await StockTrackingService.getAllStocks(Defaults.userId!)
            self.filteredStocks = GlobalData.allStocks
            
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
    
    //Search Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStocks = GlobalData.allStocks
        } else {
            filteredStocks = GlobalData.allStocks.filter {
                $0.customerName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        DispatchQueue.main.async {
            self.allStockTables?.reloadData()
        }
    }
}

extension StocksVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStocks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockeTabCell", for: indexPath) as! StockeTabCell
        let singleStock = filteredStocks[indexPath.row]
        
        cell.customerName.text = singleStock.customerName
        cell.stockDate.text = singleStock.stockDate
        cell.stockName.text = singleStock.stockName
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStock = filteredStocks[indexPath.row]
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
