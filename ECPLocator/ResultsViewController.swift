//
//  ResultsViewController.swift
//  ECPLocator
//
//  Created by Aman Wadhwa on 5/30/20.
//  Copyright © 2020 Aman Wadhwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation

var count:Int = 0
var hospitalID: Int = 0
var doctors = [[Any]]()


class ResultsViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var fiirstAddress: UILabel!
    @IBOutlet weak var firstNumber: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var secondAddress: UILabel!
    @IBOutlet weak var secondNumber: UILabel!
    @IBOutlet weak var thirdName: UILabel!
    @IBOutlet weak var thirdAddress: UILabel!
    @IBOutlet weak var thirdNumber: UILabel!
    @IBOutlet weak var fourthName: UILabel!
    @IBOutlet weak var fourthAddress: UILabel!
    @IBOutlet weak var fourthNumber: UILabel!
    @IBOutlet weak var fifthName: UILabel!
    @IBOutlet weak var fifthAddress: UILabel!
    @IBOutlet weak var fifthNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        count = 0
        firstName.text = smallerFile[count][1]
        fiirstAddress.text = smallerFile[count][2]
        firstNumber.text = smallerFile[count][5]
        
        secondName.text = smallerFile[count+1][1]
        secondAddress.text = smallerFile[count+1][2]
        secondNumber.text = smallerFile[count+1][5]
        
        thirdName.text = smallerFile[count+2][1]
        thirdAddress.text = smallerFile[count+2][2]
        thirdNumber.text = smallerFile[count+2][5]
        
        fourthName.text = smallerFile[count+3][1]
        fourthAddress.text = smallerFile[count+3][2]
        fourthNumber.text = smallerFile[count+3][5]
        
        fifthName.text = smallerFile[count+4][1]
        fifthAddress.text = smallerFile[count+4][2]
        fifthNumber.text = smallerFile[count+4][5]
    }
    
    func getDoctors(hospitalKey: Int, segueIden:String) {
            let ref = Database.database().reference()
            var final = [[Any]]()
            doctors = [[Any]]()
            ref.child("hospitals").child(String(hospitalKey)).child("doctors").observeSingleEvent(of: .value, with: { (snap) in
                
                for case let x as DataSnapshot in snap.children {
                    var count = snap.childrenCount
                    var doctor = [Any]()
                    let entry = x.value as? NSDictionary
                    let doctorName = entry?["doctor"]
                    doctor.append(doctorName)
                    let doctorSpec = entry?["special"]
                    doctor.append(doctorSpec)
                    
                    ref.child("hospitals").child(String(hospitalKey)).child("doctors").child(x.key).child("insurance").observeSingleEvent(of: .value, with: { (shot) in
                        for case let a as DataSnapshot in shot.children {
                            let val = a.value
                            
                            doctor.append(val)
                            
                            
                        }
                        
                        doctors.append(doctor)
                        count = count-1
                        if count<=1 {
                            final = doctors
                            //print(doctors)
                        }
                        
                    })
                }
            })
        performSegue(withIdentifier: segueIden, sender: self)
        }
    
    @IBAction func hospital1(_ sender: Any) {
        hospitalID = count
        getDoctors(hospitalKey: Int(smallerFile[hospitalID][0])!, segueIden: "firstHosp")
        
    }
    @IBAction func hospital2(_ sender: Any) {
        hospitalID = count+1
        getDoctors(hospitalKey: Int(smallerFile[hospitalID][0])!, segueIden: "secondHosp")

    }
    @IBAction func hospital3(_ sender: Any) {
        hospitalID = count+2
        getDoctors(hospitalKey: Int(smallerFile[hospitalID][0])!, segueIden: "thirdHosp")

    }
    @IBAction func hospital4(_ sender: Any) {
        hospitalID = count+3
        getDoctors(hospitalKey: Int(smallerFile[hospitalID][0])!, segueIden: "fourthHosp")

    }
    @IBAction func hospital5(_ sender: Any) {
        hospitalID = count+4
        getDoctors(hospitalKey: Int(smallerFile[hospitalID][0])!, segueIden: "fifthHosp")

    }
    
    
    
    @IBAction func nextPage(_ sender: Any) {
        count = count+5
        firstName.text = smallerFile[count][1]
        fiirstAddress.text = smallerFile[count][2]
        firstNumber.text = smallerFile[count][5]
        
        secondName.text = smallerFile[count+1][1]
        secondAddress.text = smallerFile[count+1][2]
        secondNumber.text = smallerFile[count+1][5]
        
        thirdName.text = smallerFile[count+2][1]
        thirdAddress.text = smallerFile[count+2][2]
        thirdNumber.text = smallerFile[count+2][5]
        
        fourthName.text = smallerFile[count+3][1]
        fourthAddress.text = smallerFile[count+3][2]
        fourthNumber.text = smallerFile[count+3][5]
        
        fifthName.text = smallerFile[count+4][1]
        fifthAddress.text = smallerFile[count+4][2]
        fifthNumber.text = smallerFile[count+4][5]
    }
    
    @IBAction func lastPage(_ sender: Any) {
        count = count-5
        firstName.text = smallerFile[count][1]
        fiirstAddress.text = smallerFile[count][2]
        firstNumber.text = smallerFile[count][5]
        
        secondName.text = smallerFile[count+1][1]
        secondAddress.text = smallerFile[count+1][2]
        secondNumber.text = smallerFile[count+1][5]
        
        thirdName.text = smallerFile[count+2][1]
        thirdAddress.text = smallerFile[count+2][2]
        thirdNumber.text = smallerFile[count+2][5]
        
        fourthName.text = smallerFile[count+3][1]
        fourthAddress.text = smallerFile[count+3][2]
        fourthNumber.text = smallerFile[count+3][5]
        
        fifthName.text = smallerFile[count+4][1]
        fifthAddress.text = smallerFile[count+4][2]
        fifthNumber.text = smallerFile[count+4][5]
    }
}
