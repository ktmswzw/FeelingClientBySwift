//
//  CustomAnnotation.swift
//  FeelingClient
//
//  Created by vincent on 14/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var detailURL: NSURL
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, detailURL: NSURL) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.detailURL = detailURL
    }
    
    func annotationView() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.enabled = true
        view.canShowCallout = true
        view.image = UIImage(named: "new")
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.Custom)
        view.centerOffset = CGPointMake(0, -32)
        return view
    }
}

class MuseumInfo : MKPointAnnotation {
    var exhibitions : [String]?
    var url : String?
}

class TheaterInfo : MKPointAnnotation {
    var phoneNumber : String?
}
