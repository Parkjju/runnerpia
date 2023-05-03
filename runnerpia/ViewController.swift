//
//  ViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/05/03.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var locationArray:[CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        

//        let initialLocation = CLLocation(latitude: 37.2701, longitude: 127.1367)
//        mapView.centerToLocation(initialLocation)
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D){

        let artwork = Marker(
          title: "King David Kalakaua",
          locationName: "Waikiki Gateway Park",
          discipline: "Sculpture",
          coordinate: coordinate)
        mapView.addAnnotation(artwork)
    }
    
    func drawPolyline(){
        let geodesic = MKPolyline(coordinates: locationArray, count: locationArray.count)
        mapView.addOverlay(geodesic)
    }

}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.9)
            renderer.lineWidth = 7
            return renderer
        }

        return MKOverlayRenderer()
    }
}

extension MKMapView{
    func centerToLocation(
      _ location: CLLocation,
      regionRadius: CLLocationDistance = 1000
    ) {
      let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
      setRegion(coordinateRegion, animated: true)
    }
}


extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
             let latitude = location.coordinate.latitude
             let longitude = location.coordinate.longitude
             // Handle location update
            
            mapView.centerToLocation(CLLocation(latitude:latitude, longitude: longitude))
            
            locationArray.append(CLLocationCoordinate2DMake(latitude, longitude))
            addMarker(coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            drawPolyline()
         }
    }
}


