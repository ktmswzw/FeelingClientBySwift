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

class CenterMain: UIViewController, MessageViewModelDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
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
        
        self.mapView.showsUserLocation = true
        
        viewModel = MessageViewModel(delegate: self)
        
        // Do any additional setup after loading the view.
    }
    
    func sendMessage(){}
    
    @IBAction func searchMsg(sender: AnyObject) {
        
        searchMessage()
    }
    
    func searchMessage(){
        viewModel.longitude = self.longitude
        viewModel.latitude = self.latitude
        viewModel.searchMessage()
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
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    
}