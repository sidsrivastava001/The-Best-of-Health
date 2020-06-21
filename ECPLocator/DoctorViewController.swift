//
//  DoctorViewController.swift
//  HospitalFinder
//
//  Created by Aman Wadhwa on 6/21/20.
//  Copyright © 2020 Aman Wadhwa. All rights reserved.
//

import UIKit

class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        var str = ""
        var count = 0
        for i in doctors[indexPath.row] {
            if count == 0 {
                str = (i as! String)
            }
            else {
                str = str + ", " + (i as! String)
            }
            count = count+1
        }
        cell.textLabel!.text = str
        cell.textLabel!.numberOfLines = 0
        return cell
    }
}


