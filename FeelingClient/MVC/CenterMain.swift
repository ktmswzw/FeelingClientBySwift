//
//  CenterMain.swift
//  FeelingClient
//
//  Created by vincent on 12/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import IBAnimatable
import MobileCoreServices

import IBAnimatable

class CenterMain: UIViewController,MessageViewModelDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var viewModel: MessageViewModel!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //地图初始化
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 1;
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        viewModel = MessageViewModel(delegate: self)
        
        
        
        
    }
    
    func sendMessage(){}
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MuseumInfo {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("MUSEUM")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MUSEUM")
                annotationView!.image = UIImage(named: "location")
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                
            }
            else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        else if annotation is TheaterInfo {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("THEATER")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "THEATER")
                annotationView!.image = UIImage(named: "new")
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        else {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("DEFAULT")
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DEFAULT")
                annotationView!.image = UIImage(named: "new")
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
    }
    
    
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        print("正在跟踪用户的位置")
    }
    
    func mapViewDidStopLocatingUser(mapView: MKMapView) {
        print("停止跟踪用户的位置")
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("更新用户的位置")
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("跟踪用户的位置失败")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            print("点击注释视图按钮")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("点击大头针注释视图")
    }
    
    @IBAction func searchMsg(sender: AnyObject) {
        
        searchMessage()
    }
    
    func searchMessage(){
        viewModel.longitude = self.longitude
        viewModel.latitude = self.latitude
        viewModel.searchMessage(self.mapView)
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "send"{
            let bottomBar = segue.destinationViewController as! CenterViewController
            bottomBar.hidesBottomBarWhenPushed = true
            //bottomBar.navigationItem.hidesBackButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        latitude =  location!.coordinate.latitude
        longitude = location!.coordinate.longitude
        
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self.mapView.region = region
        })
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    
}