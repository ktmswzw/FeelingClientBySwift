//
//  CenterViewController.swift
//  FeelingClient
//
//  Created by vincent on 14/2/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import IBAnimatable
import MediaPlayer
import MobileCoreServices

import ImagePickerSheetController

class CenterViewController: DesignableViewController , MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var address: AnimatableTextField!
    @IBOutlet var textView: UITextView!
    var lockDate:String = ""
    @IBOutlet var openUser: UITextField!
    @IBOutlet var question: UITextField!
    @IBOutlet var answer: UITextField!
    @IBOutlet var readFire: UISwitch!
    
    @IBOutlet var limitDate: UIDatePicker!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var switchHidden: UISwitch!
    @IBOutlet var hidden0: UIView!
    @IBOutlet var hidden1: UIView!
    @IBOutlet var hidden2: UIView!
    @IBOutlet var hidden3: UIView!
    @IBOutlet var hidden4: UIView!
    @IBOutlet var hidden5: UIView!
    @IBOutlet var hidden6: UIView!
    
    @IBAction func chagenSwitch(sender: AnyObject) {
        if switchHidden.on {
            hiddenView(false)
        }
        else
        {
            hiddenView(true)
        }
    }
    var picker = UIImagePickerController()
    var imageData = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO
        //地址框放入地图, 图标颜色太黑，大小太大，缺少文本域
        //        
        //        let image = UIImage(named: "lonely-children")//lonely-children
        //        let blurredImage = image!.imageByApplyingBlurWithRadius(3)
        //        self.view.layer.contents = blurredImage.CGImage
        //地图初始化
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 1;
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
    }
    
    //这样将避免约束错误
    override func viewDidAppear(animated: Bool) {
        hiddenView(true)
    }
    
    func hiddenView(flag:Bool){
        hidden0.hidden = flag
        hidden1.hidden = flag
        hidden2.hidden = flag
        hidden3.hidden = flag
        hidden4.hidden = flag
        hidden5.hidden = flag
        hidden6.hidden = flag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        //latitudeLabel.text =  NSString(format: "%f" , location!.coordinate.latitude) as String
        //longitudeLabel.text = NSString(format: "%f" , location!.coordinate.longitude) as String
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    func pickerImage() {
        let alertController = UIAlertController(title: "选择照片", message: "从相机或者照片中选择", preferredStyle:UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .Default) { (action:UIAlertAction!) in
            
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            //to select only camera controls, not video controls
            self.picker.mediaTypes = [kUTTypeImage as String]
            self.picker.showsCameraControls = true
            self.picker.allowsEditing = true
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        
        
        let albumAction = UIAlertAction(title: "相册", style: .Default) { (action:UIAlertAction!) in
            
            self.picker.delegate = self
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion:{ () -> Void in
            print("y11111");
        })
        
    }
    
    
    func presentImagePickerSheet() {
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let controller = ImagePickerSheetController(mediaType: .ImageAndVideo)
        controller.addAction(ImagePickerAction(title: NSLocalizedString("拍摄", comment: "标题"),handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { _, numberOfPhotos in
                for ass in controller.selectedImageAssets
                {
                    let image = getAssetThumbnail(ass)
                    self.imageData.append(image)
                }
                self.photoCollectionView.reloadData()
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("相册", comment: "标题"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("ImagePickerSheet.button1.Send %lu Photo", comment: "Action Title"), $0) as String}, handler: { _ in
            presentImagePickerController(.PhotoLibrary)
            }, secondaryHandler: { _, numberOfPhotos in
                //print("Send \(controller.selectedImageAssets)")
                for ass in controller.selectedImageAssets
                {
                    let image = getAssetThumbnail(ass)
                    self.imageData.append(image)
                }
                self.photoCollectionView.reloadData()
                
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("取消", comment: "Action Title"), style: .Cancel, handler: { _ in
            //print("Cancelled")
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            controller.modalPresentationStyle = .Popover
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize())
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
}



extension CenterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //pickerImage()
        presentImagePickerSheet()
        //self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        switch indexPath.row {
            
        case imageData.count:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCell", forIndexPath: indexPath)
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath)
            let imgV = UIImageView(image: imageData[indexPath.row])
            imgV.frame = cell.frame
            cell.backgroundView = imgV
            cell.layer.cornerRadius = 5
        }
        
        
        return cell
    }
}

extension CenterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageData.append(image)
        photoCollectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
