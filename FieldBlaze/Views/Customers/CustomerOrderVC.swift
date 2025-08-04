//
//  CustomerOrderVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 30/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class CustomerOrderVC: UIViewController {
    
    @IBOutlet weak var noDataImge: UIImageView!
    @IBOutlet weak var ordersTable: UITableView!
    
    var accountId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataImge.isHidden = true
        ordersTable.isHidden = true
        
        ordersTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await OrdersService.getOrderForCustomer(accountId!)
            DispatchQueue.main.async {
                if GlobalData.customerOrders.isEmpty{
                    self.noDataImge.isHidden = false
                    self.ordersTable.isHidden = true
                }else{
                    self.noDataImge.isHidden = true
                    self.ordersTable.isHidden = false
                    self.ordersTable.reloadData()
                }
            }
            
        }
    }
    
}

extension CustomerOrderVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  GlobalData.customerOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableCell
        let singleOrder =  GlobalData.customerOrders[indexPath.row]
        cell.customerNameLabel.text = singleOrder.customerName
        cell.orderDateLabel.text = singleOrder.orderDate
        cell.orderNumberLabel.text = singleOrder.orderName
        cell.salesPersonLabel.text = singleOrder.salesPersonName
        
        if singleOrder.totalOrderAmount == 0.0{
            cell.orderAmountLabel.text = "Rs. 0"
        }else{
            cell.orderAmountLabel.text = "Rs. \(singleOrder.totalOrderAmount ?? 0)"
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleOrder = GlobalData.customerOrders[indexPath.row]
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        if let selectedVC = storyboard.instantiateViewController(identifier: "OrderDetailsVC") as? OrderDetailsVC{
            selectedVC.orderId = singleOrder.id
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
}
