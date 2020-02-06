//
//  DetailInfomationViewController.swift
//  SubwayDPIM
//
//  Created by PST on 2020/02/04.
//  Copyright © 2020 PST. All rights reserved.
//

import UIKit
import MapKit

class DetailInfomationViewController: UIViewController {

    var station: SubwayInfomation?
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var lineLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var wheelChairLabel: UILabel?
    @IBOutlet weak var elevatorLabel: UILabel?
    
    override func viewDidLoad() {
            
        super.viewDidLoad()

        setMapView()
        imageView?.image = setImageView(image: station?.imageName ?? "1")
        lineLabel?.text = station?.line
        nameLabel?.text = station?.name
        wheelChairLabel?.text = station?.wheelChair
        elevatorLabel?.text = station?.elevator
    }
    
    func setMapView() {
        let stationLocation = CLLocation(latitude: station?.latitude ?? 0.0, longitude: station?.longitude ?? 0.0)
        mapView?.setRegion(MKCoordinateRegion(center: stationLocation.coordinate, latitudinalMeters: 500 * 2, longitudinalMeters: 500 * 2), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = stationLocation.coordinate
        annotation.title = station?.name
        annotation.subtitle = station?.elevator
        mapView?.addAnnotation(annotation)
    }
    
    func setImageView(image:String) -> UIImage? {
        
        switch image {
            case "1":
                return UIImage(named: "1")
            case "2":
                return UIImage(named: "2")
            case "3":
                return UIImage(named: "3")
            case "4":
                return UIImage(named: "4")
            case "5":
                return UIImage(named: "5")
            case "6":
                return UIImage(named: "6")
            case "7":
                return UIImage(named: "7")
            case "8":
                return UIImage(named: "8")
            case "9":
                return UIImage(named: "9")
        
        default:
            return UIImage(named: "1")
        }
    }
    
    @IBAction func cancelButtonTouchUpInside(sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        mapView?.frame.size.height = UIScreen.main.bounds.height / 2
        mapView?.frame.size.width = UIScreen.main.bounds.width
        contentView?.frame.size.height = UIScreen.main.bounds.height / 2
        contentView?.frame.size.width = UIScreen.main.bounds.width
        contentView?.frame.origin.y = (mapView?.frame.maxY ?? 0) + 10
    }
    

    
}
