//
//  MapViewController.swift
//  ECPLocator
//
//  Created by Aman Wadhwa on 5/30/20.
//  Copyright © 2020 Aman Wadhwa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var userLocation:Bool = false
    var offLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

        override func viewDidAppear(_ animated: Bool) {

            if inputLocation == nil {
                userLocation = true
                map.showsUserLocation = true

                offLocation = locatePatient

            }
            else {
                print("ENTERING THE ELSE")
                offLocation = inputLocation

            }

        print("About to print offLocation value")
        print("locations = \(String(describing: offLocation?.latitude)) \(String(describing: offLocation?.longitude))")

        centerOnUser(user: offLocation!, distance: 50000)




        print("ENTERING LOOP")
        var final = [[Any]]()
        for i in CSVFile{
            if String(i[0]) != "" {
                let lat = Double(i[3])
                let lng = Double(i[4])
                let destCoor=CLLocationCoordinate2DMake(lat as! Double,lng as! Double)
                let pin = customPin(pinTitle: String(i[1]), pinSubTitle: i[2], location: destCoor)
                self.map.addAnnotation(pin)

            }
        }


    }

    func centerOnUser(user:CLLocationCoordinate2D, distance:Int){
        let region = MKCoordinateRegion.init(center: user, latitudinalMeters: CLLocationDistance(distance), longitudinalMeters: CLLocationDistance(distance))
        map.setRegion(region, animated: true)
    }

    @IBAction func goBackwards(_ sender: Any) {
        performSegue(withIdentifier: "backwardSegue", sender: self)
    }
    

    @IBAction func showResults(_ sender: Any) {
        performSegue(withIdentifier: "resultSegue", sender: self)

    }
    


}
