//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

extension CGRect{
  init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
    self.init(x:x,y:y,width:width,height:height)
  }
}

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  @IBAction func onCameraPress(_ sender: Any) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("Camera is available 📸")
      vc.sourceType = .camera
    } else {
      print("Camera 🚫 available so we will use photo library instead")
      vc.sourceType = .photoLibrary
    }
    self.present(vc, animated: true, completion: nil)
  }
  
  var selectedImage: UIImage?

  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        mapView.delegate = self
    
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                            MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
      // Get the image captured by the UIImagePickerController
      let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
      // Do something with the images (based on your use case)
      selectedImage = originalImage
    
      // Dismiss UIImagePickerController to go back to your original view controller
      dismiss(animated: true, completion: nil)
    
      //instantiateViewController(withIdentifier: tagSegue)
      self.performSegue(withIdentifier: "tagSegue", sender: nil)
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = String(locationCoordinate.latitude) + ", " + String(locationCoordinate.longitude)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let reuseID = "myAnnotationView"
      
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
      if (annotationView == nil) {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        annotationView!.canShowCallout = true
        annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
      }
      
      let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
      imageView.image = UIImage(named: "camera")
      imageView.image = selectedImage
      
      return annotationView
    }
}
