//
//  HospitalViewController.swift
//  HospitalFinder
//
//  Created by Aman Wadhwa on 6/21/20.
//  Copyright © 2020 Aman Wadhwa. All rights reserved.
//

import UIKit

class HospitalViewController: UIViewController {
    
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var providerID: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var sentiment: UILabel!
    @IBOutlet weak var emergency: UILabel!
    @IBOutlet weak var mortality: UILabel!
    @IBOutlet weak var safety: UILabel!
    @IBOutlet weak var effectiveness: UILabel!
    @IBOutlet weak var timeliness: UILabel!
    @IBOutlet weak var payment: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("ABOUT TO PRINT DOCTORS")
        //print(doctors)
        
        hospitalName.text = smallerFile[hospitalID][1]
        providerID.text = providerID.text! +  smallerFile[hospitalID][0]
        number.text = number.text! + smallerFile[hospitalID][5]
        address.text = smallerFile[hospitalID][2]
        type.text = smallerFile[hospitalID][6]
        sentiment.text = sentiment.text! + smallerFile[hospitalID][16]
        var service = ""
        if smallerFile[hospitalID][7] == "TRUE" {
            service = "Yes"
        }
        else{
            service = "No"
        }
        emergency.text = emergency.text! + service
        
        
        var mortal = 0
        if smallerFile[hospitalID][8] == "Below the national average" {
            mortal = 1
        }
        else if smallerFile[hospitalID][8] == "Above the national average" {
            mortal = -1
        }
        
        var safe = 0
        if smallerFile[hospitalID][9] == "Below the national average" {
            safe = -1
        }
        else if smallerFile[hospitalID][9] == "Above the national average" {
            safe = 1
        }
        
        
        mortality.text = mortality.text! + String(mortal+2) + " star(s) out of 3 stars"
        safety.text = safety.text! + String(safe+2) + " star(s) out of 3 stars"
        effectiveness.text = effectiveness.text! + smallerFile[hospitalID][19] + " star(s) out of 3 stars"
        timeliness.text = timeliness.text! + smallerFile[hospitalID][20] + " star(s) out of 3 stars"

        
        payment.text = "Payment Score (0 to 8): " + smallerFile[hospitalID][18]
        
        for i in updateData {
            if i[0] as! String == smallerFile[hospitalID][0] && i[2] != nil {
                capacity.text = capacity.text! + String(i[2] as! Int)
            }
        }
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
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backToList", sender: self)
    }
    @IBAction func toDoctors(_ sender: Any) {
        performSegue(withIdentifier: "goDoctor", sender: self)
    }
}


