//
//  ViewController.swift
//  ECPLocator
//
//  Created by Aman Wadhwa on 5/30/20.
//  Copyright © 2020 Aman Wadhwa. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Foundation
import CSV

var sortedArray = [[Any]]()
var text = ""
var locatePatient:CLLocationCoordinate2D?
var inputLocation: CLLocationCoordinate2D?
var updateData = [[Any]]()
var CSVFile = [[String]]()
var durations = [Int]()
var sort:String = ""
var smallerFile = [[String]]()
var paymentScore = 0



class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var numHospitals: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var txtField: UITextField!
    var locationManager = CLLocationManager()
    var ref:DatabaseReference?
    let dataSource = ["Distance", "Review Sentiment", "Price", "Effectiveness of Care", "Timeliness of Care"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.view.backgroundColor = UIColor(red: 253/255, green: 250/255, blue: 245/255, alpha: 1)
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        ref = Database.database().reference()
        
        
        ref?.child("hospitals").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
            for case let rest as DataSnapshot in snapshot.children {
                var row = [Any]()
                let dict = rest.value as? NSDictionary
                let name = dict?["name"]
                let availability = dict?["occupancy"]
                row.append(rest.key)
                row.append(name)
                row.append(availability)
                
                updateData.append(row)
            }
        })
        
        let stream = InputStream(fileAtPath: "/Users/amanwadhwa/iPhoneApps/HospitalFinder/ECPLocator/newcenters.csv")!
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            CSVFile.append(row)
        }
        print(CSVFile[CSVFile.count-1])
        print("Done")
        
        
    }
    
    
        
    
    func getDoctors(hospitalKey: Int) -> [[Any]] {
        ref = Database.database().reference()
        var doctors = [[Any]]()
        var final = [[Any]]()
        self.ref?.child("hospitals").child(String(hospitalKey)).child("doctors").observeSingleEvent(of: .value, with: { (snap) in
            
            for case let x as DataSnapshot in snap.children {
                var count = snap.childrenCount
                var doctor = [Any]()
                let entry = x.value as? NSDictionary
                let doctorName = entry?["doctor"]
                doctor.append(doctorName)
//                let doctorSpec = entry?["special"]
//                doctor.append(doctorSpec)
                
                self.ref?.child("hospitals").child(String(hospitalKey)).child("doctors").child(x.key).child("insurance").observeSingleEvent(of: .value, with: { (shot) in
                    for case let a as DataSnapshot in shot.children {
                        let val = a.value
                        
                        doctor.append(val)
                        
                        
                    }
                    
                    doctors.append(doctor)
                    count = count-1
                    if count<=1 {
                        final = doctors
                        print(doctors)
                    }
                    
                })
            }
        })
            return doctors
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locatePatient = locValue
        print("HOPE")
        print("locations = \(locValue.latitude) \(locValue.longitude)")

    }
    
    @IBAction func result(_ sender: Any) {
        txtField.delegate = self
        var text = txtField.text!
        print(text)
        var quantity = numHospitals.text!
        let geocoder = CLGeocoder()
        var loc:CLLocationCoordinate2D
        
        
        if text.isEmpty || text == "Your Location" {
            print("F")
            loc = locatePatient!
        }
        else{
        geocoder.geocodeAddressString(text, completionHandler: {(placemarks, error) -> Void in
           if((error) != nil){
              print("Error", error)
           }
           if let placemark = placemarks?.first {
              let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
              print("ABOUT TO PRINT LOCATION")
              inputLocation = coordinates
              print(String(describing: inputLocation!.latitude) + ", " + String(describing: inputLocation!.longitude))
              
              }
            })
            loc = inputLocation!
        }
        getDirections(offLocation: loc)
        
        for i in 0...Int(quantity)! {
            smallerFile.append(CSVFile[i])
            paymentScore = 0
            for x in 12...15 {
                if(smallerFile[i][x] == "Less Than the National Average Payment"){
                    paymentScore = paymentScore+1
                }
                else if smallerFile[i][x] == "Greater Than the National Average Payment" {
                    paymentScore = paymentScore-1
                }
            }
            smallerFile[i].append(String(paymentScore+4))
        }
        for i in 0...Int(quantity)! {
            let temp = Double(smallerFile[i][16])! + 1.0
            smallerFile[i][16] = String(temp)
        }
        for i in 0...Int(quantity)! {
            if smallerFile[i][11] == "Below the national average" {
                smallerFile[i].append(String(1))
            }
            else if smallerFile[i][11] == "Above the national average" {
                smallerFile[i].append(String(3))
            }
            else{
                smallerFile[i].append(String(2))
            }
        }
        for i in 0...Int(quantity)! {
            if smallerFile[i][10] == "Below the national average" {
                smallerFile[i].append(String(1))
            }
            else if smallerFile[i][10] == "Above the national average" {
                smallerFile[i].append(String(3))
            }
            else{
                smallerFile[i].append(String(2))
            }
        }
        if sort == "Review Sentiment" {
            smallerFile.sort(by: {$0[16] > $1[16]} )
        }
        else if sort == "Price" {
            smallerFile.sort(by: {$0[18] > $1[18]} )
        }
        else if sort == "Effectiveness of Care" {
            
            smallerFile.sort(by: {$0[19] > $1[19]} )
        }
        else if sort == "Timeliness of Care" {
            
            smallerFile.sort(by: {$0[20] > $1[20]} )
        }
        print(smallerFile)
        performSegue(withIdentifier: "mapSegue", sender: self)
    }
    
    
    
    func getDirections(offLocation: CLLocationCoordinate2D){
        var count = 0
        for i in CSVFile{
            if String(i[0]) != "" {
                let lat = Double(i[3])! * (Double.pi/180)
                let lng = Double(i[4])! * (Double.pi/180)
                let dlat = lat-(offLocation.latitude * (Double.pi/180))
                let dlon = lng - (offLocation.longitude * (Double.pi/180))
                var a = pow((sin(dlat/2)),2)
                a =  a + cos(lat)*cos(offLocation.latitude * (Double.pi/180))*pow((sin(dlon/2)),2)
                let c = 2*atan2(a.squareRoot(), (1-a).squareRoot())
                let d = 3958.8*c
                CSVFile[count].append(String(d))
                }
                count = count+1
            }

        CSVFile.sort(by: {$0[17] < $1[17]} )
        
        }

        
    
}

extension ViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sort = dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}
