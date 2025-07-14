//
//  RiskStockVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 11/07/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class RiskStockVC: UIViewController {
    
    @IBOutlet weak var riskStockTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func proceedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "VisitsTaskVC") as? VisitsTaskVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension RiskStockVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = riskStockTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
}
