//
//  MapKitViewController.swift
//  SubwayDPIM
//
//  Created by PST on 2020/02/04.
//  Copyright © 2020 PST. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

var stations = [SubwayInfomation]()

class MapKitViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView?
    private let userLocation = CLLocation(latitude: 37.490770, longitude: 126.900519)
    private let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchJsonData()
        checkAllowLocationServices()
        checkLocationAuthorization()
        mapView?.delegate = self
        mapView?.addAnnotations(stations)
        //mapView?.setRegion(MKCoordinateRegion.init(center: userLocation.coordinate, latitudinalMeters: 1500.0, longitudinalMeters: 1500.0), animated: true)
        
        let viewController = self.tabBarController?.viewControllers![1] as! TableListViewController
        viewController.stations = stations
    }

    
    func fetchJsonData() {
        guard let fileName = Bundle.main.path(forResource: "SubwayStationInfo", ofType: "json") else { return }
        let filePath = URL(fileURLWithPath: fileName)
        var data: Data?
        
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        } catch let error {
            data = nil
            print(error.localizedDescription)
        }
        
        if let jsonData = data {
            let json = try? JSON(data: jsonData)
            
            if let stationJSONs = json?["DATA"].array {

                for stationJSON in stationJSONs {

                    if let station = SubwayInfomation.from(json: stationJSON) {
                        stations.append(station)
                    }
                }
            }
            
        }
    }
    
    func checkAllowLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            mapView?.showsUserLocation = true
            manager.startUpdatingLocation()
            break
            
        case .denied:
            break
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            break
            
        case .authorizedAlways:
            mapView?.showsUserLocation = true
            manager.startUpdatingLocation()
            break
            
        default:
            break
        }
    }
    
    
    // Show Search Bar
    @IBAction func searchBarSearchButtonTouchUpInside(_ searchBar: UISearchBar) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            if response == nil {
                print("Error")
            }
            else {
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self.mapView?.setRegion(region, animated: true)
            }
        }
        
    }

}


extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? SubwayInfomation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -7, y: 7)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        let viewController = self.storyboard?.instantiateViewController(identifier: "detailView") as! DetailInfomationViewController
        
        for station in stations {

            if station.coordinate.latitude == view.annotation?.coordinate.latitude {
                viewController.station = station
            }
        }
        
        self.tabBarController?.show(viewController, sender: nil)
    }
}

extension MapKitViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1500.0, longitudinalMeters: 1500.0)
        mapView?.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
