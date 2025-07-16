//
//  AllProductsVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 14/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class AllProductsVC: UIViewController {
    
    @IBOutlet weak var allProductsTable: UITableView!
    
    var priceBookId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allProductsTable.separatorStyle = .none
        
        setUpUI()
    }
    
    //Function to setup ui:
    func setUpUI(){
        Task{
            await ProductsService.getAllProductsPriceBook(priceBookId!)
            print(GlobalData.allProducts)
            DispatchQueue.main.async {
                self.allProductsTable.reloadData()
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AllProductsVC:UITabBarDelegate, UITableViewDataSource, addButtonProtocol{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allProductsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllProductsClass
        
        let singleProduct = GlobalData.allProducts[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.productName.text = singleProduct.name
        cell.productPrice.text = "\(singleProduct.productPrice!)"
        cell.productId = singleProduct.id
        
        cell.delegate = self

        return cell
    }
    
    func addButtonTapped(_ productId: String) {
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "OrderLineItemVC") as? OrderLineItemVC{
            nextController.productId = productId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

protocol addButtonProtocol:AnyObject{
    func addButtonTapped(_ productId:String)
}

class AllProductsClass:UITableViewCell{
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var productId:String?
    
    var delegate:addButtonProtocol?
    
    @IBAction func addButtonAction(_ sender: Any) {
        delegate?.addButtonTapped(productId!)
    }
    
}
