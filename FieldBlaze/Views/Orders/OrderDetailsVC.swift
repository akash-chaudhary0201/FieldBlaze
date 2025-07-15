//
//  OrderDetailsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 16/05/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var orderLineTabHeight: NSLayoutConstraint!
    @IBOutlet weak var orderLineItemsTable: UITableView!
    @IBOutlet weak var orderLineItemLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var billingTable: UITableView!
    @IBOutlet weak var shippingTable: UITableView!
    @IBOutlet weak var shippingView: UIView!
    @IBOutlet weak var shippingTopSpace: NSLayoutConstraint!
    
    //flags-------------------------
    var isBillingTableVisible = false
    var isShippingTableVisible = false
    
    @IBOutlet weak var firstTable: UITableView!
    var firstTableArray:[String] = ["Sales Order Number:", "Customer Name:", "Order Date:", "Delivery Date:", "Price Book Name:", "Sales Person:"]
    var billingDetArray:[String] = ["Billing Street", "Billing City", "Billing Zip/Postal Code", "Billing State", "Billing Country"]
    var shippingDetArray:[String] = ["Shipping Street", "Shipping City", "Shipping Zip/Postal Code", "Shipping State", "Shipping Country"]
    
    //Final amount labels:
    @IBOutlet weak var amountAfterDiscount: UILabel!
    @IBOutlet weak var amountWithGst: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var singleOrder:[Orders] = []
    var salesOrderLineItemsArray:[SalesOrderLineItemsModel] = []
    
    var orderId:String?
    
    var obj = OrdersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shippingTopSpace.constant = -190
        orderLineItemLabelTop.constant = -190
        
        firstTable.isScrollEnabled = false
        orderLineItemsTable.isScrollEnabled = false
        
        billingView.isHidden = true
        shippingView.isHidden = true
        
        orderLineItemsTable.separatorStyle = .none
        
        Task{
            await obj.getOrderBasedOnOrderId(orderId!){status in
                if status{
                    print("Completed")
                }
            }
            singleOrder = obj.singleOrder
            salesOrderLineItemsArray =  obj.salesOrderLineItemArray
            print("------------------------Sales Order Line Count------------------: \(salesOrderLineItemsArray.count)")
            
            orderLineTabHeight.constant = CGFloat(salesOrderLineItemsArray.count * 210)
            
            DispatchQueue.main.async {
                self.firstTable.reloadData()
                self.billingTable.reloadData()
                self.shippingTable.reloadData()
                self.orderLineItemsTable.reloadData()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Action to open billing view:
    @IBAction func openBillingView(_ sender: Any) {
        if isBillingTableVisible == false{
            billingView.isHidden = false
            isBillingTableVisible = true
            shippingTopSpace.constant = 0
        }else{
            billingView.isHidden = true
            isBillingTableVisible = false
            shippingTopSpace.constant = -190
        }
    }
    
    @IBAction func openShippingView(_ sender: Any) {
        if isShippingTableVisible == false{
            shippingView.isHidden = false
            isShippingTableVisible = true
            orderLineItemLabelTop.constant = 30
        }else{
            shippingView.isHidden = true
            isShippingTableVisible = false
            orderLineItemLabelTop.constant = -190
        }
    }
}

extension OrderDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTable{
            return 6
        }else if tableView == billingTable{
            return 5
        }else if tableView == shippingTable{
            return 5
        }else if tableView == orderLineItemsTable{
            return salesOrderLineItemsArray.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firstTable{
            let cell = firstTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FirstTableCell
            cell.leftLabel.text = firstTableArray[indexPath.row]
            let resultOrder = GlobalData.allOrder.first
            
            if indexPath.row == 0{
                cell.salesOrderLabel.text = resultOrder?.orderName
            }else if indexPath.row == 1{
                cell.salesOrderLabel.text = resultOrder?.customerName
            }else if indexPath.row == 2{
                cell.salesOrderLabel.text = resultOrder?.orderDate
            }else if indexPath.row == 3{
                cell.salesOrderLabel.text = resultOrder?.orderDeliveryDate
            }else if indexPath.row == 4{
                cell.salesOrderLabel.text = resultOrder?.priceBookName
            }else if indexPath.row == 5{
                cell.salesOrderLabel.text = resultOrder?.salesPersonName
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else if tableView == billingTable{
            let cell = billingTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BillingTableCell
            cell.letLabel.text = billingDetArray[indexPath.row]
            
            let resultOrder = GlobalData.allOrder.first
            
            if indexPath.row == 0{
                cell.rightLabel.text = resultOrder?.billingStreet
            }else if indexPath.row == 1{
                cell.rightLabel.text = resultOrder?.billingCity
            }else if indexPath.row == 2{
                cell.rightLabel.text = "\(resultOrder?.billingZip ?? 0)"
            }else if indexPath.row == 3{
                cell.rightLabel.text = resultOrder?.billingState
            }else if indexPath.row == 4{
                cell.rightLabel.text = resultOrder?.billingCountry
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else if tableView == shippingTable{
            let cell = shippingTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShippingTableCell
            cell.leftLabel.text = shippingDetArray[indexPath.row]
            
            let resultOrder = GlobalData.allOrder.first
            
            if indexPath.row == 0{
                cell.riightLabel.text = resultOrder?.shippingStreet
            }else if indexPath.row == 1{
                cell.riightLabel.text = resultOrder?.shippingCity
            }else if indexPath.row == 2{
                cell.riightLabel.text = "\(resultOrder?.shippingZip ?? 0)"
            }else if indexPath.row == 3{
                cell.riightLabel.text = resultOrder?.shippingState
            }else if indexPath.row == 4{
                cell.riightLabel.text = resultOrder?.shippingCountry
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else if tableView == orderLineItemsTable{
            let cell = orderLineItemsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderLineTableCell
            
            let singleSalesItem = salesOrderLineItemsArray[indexPath.row]
            cell.productNameLabel.text = singleSalesItem.productName
            cell.salesPriceLabel.text = "\(singleSalesItem.cuSalesPrice!)"
            cell.quantityLabel.text = "\(singleSalesItem.nuQuantity!)"
            cell.amountWithGSTLabel.text = "\(singleSalesItem.cuAmountWithGST!)"
            cell.amountAfterDiscountLabel.text = "\(singleSalesItem.cuAmountAfterDiscount!)"
            cell.finalAmountLabel.text = "\(singleSalesItem.cuTotalPrice!)"
            
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
}

class FirstTableCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var salesOrderLabel: UILabel!
}

class BillingTableCell:UITableViewCell{
    @IBOutlet weak var letLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
}

class ShippingTableCell:UITableViewCell{
    @IBOutlet weak var riightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
}

class OrderLineTableCell:UITableViewCell{
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var amountAfterDiscountLabel: UILabel!
    @IBOutlet weak var finalAmountLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var salesPriceLabel: UILabel!
    @IBOutlet weak var amountWithGSTLabel: UILabel!
    @IBOutlet weak var schemeLabel: UILabel!
    
}


