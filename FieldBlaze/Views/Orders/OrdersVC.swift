//
//  OrdersVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import SwiftLoader

class OrdersVC: UIViewController {

    @IBOutlet weak var ordersTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTable.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            await setUpUI()
        }
    }
    
    func setUpUI() async{
        var config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = .blue
        config.foregroundColor = .black
        config.foregroundAlpha = 0.6
        SwiftLoader.setConfig(config: config)
        SwiftLoader.show(title: "Loading...", animated: true)
        
        await OrdersService.getAllOrders(Defaults.userId!){ status in
            if status{
                SwiftLoader.hide()
            }
        }
        ordersTable.reloadData()
    }
    
    
    @IBAction func goToCreateOrder(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        if let selectedVC = storyboard.instantiateViewController(identifier: "CreateSalesOrderController") as? CreateSalesOrderController{
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension OrdersVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        GlobalData.allOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableCell
        let singleOrder =  GlobalData.allOrder[indexPath.row]
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
        let singleOrder = GlobalData.allOrder[indexPath.row]
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        if let selectedVC = storyboard.instantiateViewController(identifier: "OrderDetailsVC") as? OrderDetailsVC{
            selectedVC.orderId = singleOrder.id
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


class OrderTableCell:UITableViewCell{
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var salesPersonLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
}
