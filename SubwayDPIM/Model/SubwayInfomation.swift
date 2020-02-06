//
//  SubwayInfomation.swift
//  SubwayDPIM
//
//  Created by PST on 2020/02/04.
//  Copyright © 2020 PST. All rights reserved.
//

import MapKit
import SwiftyJSON

class SubwayInfomation: NSObject, MKAnnotation {
    
    let line: String?
    let name: String?
    let wheelChair: String?
    let elevator: String?
    let latitude: Double?
    let longitude: Double?
    let imageName: String?
    
    init(line: String, name: String, wheelChair: String, elevator: String, latitude: Double, longitude: Double, imageName: String) {
        self.line = line
        self.name = name
        self.wheelChair = wheelChair
        self.elevator = elevator
        self.latitude = latitude
        self.longitude = longitude
        self.imageName = imageName
    }
    
    class func from(json: JSON) -> SubwayInfomation? {
        
        let line = json["line"].stringValue
        let name = json["name"].stringValue
        let wheelChair = json["wheelChair"].stringValue
        let elevator = json["elevator"].stringValue
        let latitude = json["latitude"].doubleValue
        let longitude = json["longitude"].doubleValue
        let imageName = json["imageName"].stringValue

        
        return SubwayInfomation(line: line, name: name, wheelChair: wheelChair, elevator: elevator, latitude: latitude, longitude: longitude, imageName: imageName)
    }
    
    var title: String? {
        return "\(line!) \(name!)"
    }

    var subtitle: String? {
        return "휠체어:\(wheelChair!) 엘레베이터:\(elevator!)"
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
}
