//
//  VisitsVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 10/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class TodaysVisitsVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var completedTasks: UILabel?
    @IBOutlet weak var progBar: UIProgressView?
    @IBOutlet weak var startButton: UIButton?
    @IBOutlet weak var totalTasks: UILabel?
    @IBOutlet weak var dailyRecordTable: UITableView?
    @IBOutlet weak var totalView: UIView?
    @IBOutlet weak var completedView: UIView?
    @IBOutlet weak var pendingView: UIView?
    
    var currentDate:String?
    
    @IBOutlet weak var todaysTotalVisitLabel: UILabel!
    
    var isDailyRecordOpen = false
    
    var obj = VisitsService()
    
//    var dbObj = DBConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor(red: 62.0/255.0,
                                                green: 197.0/255.0,
                                                blue: 154.0/255.0,
                                                alpha: 1)
        view.addSubview(statusBarView)
        updateUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateProgressBar()
    }
    
    //Example function
    func updateUi(){
        self.currentDate = GetTimeAndDate.getDate(dateFormat: "yyyy-MM-dd")
        Task{
            await self.obj.getTodaysVisit(currentDate!) { status in
                if status{
                    DispatchQueue.main.async {
                        self.todaysTotalVisitLabel.text = "\(GlobalData.todaysVisits.count)"
                        self.dailyRecordTable?.reloadData()
                    }
                }
            }
        }
    }
    
    func setUpInitialUI() {
        mainView?.layer.cornerRadius = 10
        startButton?.layer.cornerRadius = 18
        progBar?.layer.cornerRadius = 20
        progBar?.trackTintColor = UIColor(red: 224/255, green: 243/255, blue: 236/255, alpha: 255)
        progBar?.progressTintColor = UIColor(red: 90/255, green: 197/255, blue: 154/255, alpha: 255)
        progBar?.progress = 0.0
        dailyRecordTable?.isHidden = true
        totalView?.layer.cornerRadius = 10
        completedView?.layer.cornerRadius = 10
        pendingView?.layer.cornerRadius = 10
    }
    
    func updateProgressBar() {
        guard let completedText = completedTasks?.text,
              let totalText = totalTasks?.text,
              let completed = Float(completedText),
              let total = Float(totalText),
              total > 0 else {
            return
        }
        let progress = completed / total
        progBar?.setProgress(progress, animated: true)
    }
    
    @IBAction func openDailyVisitRecords(_ sender: Any) {
    
        if isDailyRecordOpen{
            dailyRecordTable?.isHidden = true
            isDailyRecordOpen = false
            startButton?.setTitle("Start Day", for: .normal)
        }else if isDailyRecordOpen == false{
            dailyRecordTable?.isHidden = false
            isDailyRecordOpen = true
            startButton?.setTitle("End Day", for: .normal)
        }
    }
}

extension TodaysVisitsVC: UITableViewDelegate, UITableViewDataSource, CustomCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.todaysVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dailyRecordTable?.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitsCell
        let singleVisit = GlobalData.todaysVisits[indexPath.row]
        
        cell.nameLabel.text = singleVisit.accountName
        cell.phoneLabel.text = singleVisit.visitName
        
        cell.visitId = singleVisit.visitId
        cell.accountName = singleVisit.accountName
        cell.accounId = singleVisit.accountId
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func didTapButton(_ visitId:String, _ accountName:String, _ accountId:String) {
          let storyboard = UIStoryboard(name: "Visits", bundle: nil)
          if let nextController = storyboard.instantiateViewController(withIdentifier: "StartCheckInVC") as? StartCheckInVC {
              
              nextController.visitId = visitId
              nextController.accountId = accountId
              nextController.accountName = accountName
              
              let navController = UINavigationController(rootViewController: nextController)
              navController.modalPresentationStyle = .overFullScreen
              nextController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3966007864)
              self.present(navController, animated: false, completion: nil)
          }
      }
    
}

protocol CustomCellDelegate: AnyObject {
    func didTapButton(_ visitId:String, _ accountName:String, _ accountId:String)
}

class VisitsCell: UITableViewCell {
    @IBOutlet weak var completedIcon: UIButton!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var visitId:String?
    var accountName:String?
    var accounId:String?
    
    weak var delegate: CustomCellDelegate?
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        delegate?.didTapButton(self.visitId!, self.accountName!, self.accounId!)
    }
}
