//
//  TasksVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class TasksVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tasksTabl: UITableView!
    @IBOutlet weak var taskSearchBar: UISearchBar!
    
    var obj = TaskServices()
    var allTasksArray:[TaskModel] = []
    var filteredTasks:[TaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTabl.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task{
            SwiftLoaderHelper.setLoader()
            
            await obj.getAllTasks(Defaults.userId!){ status in
                if status{
                    SwiftLoader.hide()
                }
            }
            self.filteredTasks = GlobalData.allTasks
            
            DispatchQueue.main.async {
                self.tasksTabl.reloadData()
            }
        }
    }
    
    //Search Bar functionality:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTasks = []
        if searchText.isEmpty {
            filteredTasks = GlobalData.allTasks
        } else {
            filteredTasks = GlobalData.allTasks.filter { task in
                guard let subject = task.subject else { return false }
                return subject.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tasksTabl.reloadData()
        }
    }
    
    //Back action:
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToAddNewTask(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CreateTaskVC") as? CreateTaskVC{
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

extension TasksVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasksTabl.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
        let singleTask = filteredTasks[indexPath.row]
        
        let formateddDate = singleTask.date?.prefix(10)
        
        cell.taskDate.text = "\(formateddDate ?? "a")"
        cell.taskDescription.text = singleTask.description
        cell.taskTitle.text = singleTask.subject
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleTask = filteredTasks[indexPath.row]
        let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "TaskDetailVC") as? TaskDetailVC{
            nextController.taskId = singleTask.id
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    
}
