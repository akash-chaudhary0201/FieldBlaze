//
//  TaskDetailVC.swift
//  FieldBlaze
//
//  Created by Akash Chaudhary  on 03/06/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    var obj = TaskServices()
    
    var taskId:String?
    
    var singleTask:TaskModel?
    
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            var config = SwiftLoader.Config()
            config.size = 100
            config.spinnerColor = .blue
            config.foregroundColor = .black
            config.foregroundAlpha = 0
            SwiftLoader.setConfig(config: config)
            SwiftLoader.show(title: "Loading...", animated: true)
            
            self.singleTask = await obj.getSingleTask(taskId!){status in
                if status{
                    SwiftLoader.hide()
                }
            }
            print("Single Task------------------------\(self.singleTask!)")
            
            taskDescription.text = singleTask?.description
            taskTitle.text = singleTask?.subject
            taskPriority.text = singleTask?.priority
            taskDate.text = singleTask?.date
        }

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
