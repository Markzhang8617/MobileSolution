//
//  ViewController.swift
//  Lab7
//
//  Created by user246846 on 7/11/24.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var maxSpeed: CLLocationSpeed = 0.0
    var totalSpeed: CLLocationSpeed = 0.0
    var speedCount: Int = 0
    var totalDistance: CLLocationDistance = 0.0
    var lastLocation: CLLocation?
    var maxAcceleration: Double = 0.0
    var lastSpeed: CLLocationSpeed = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
    }
    
    @IBAction func startTrip(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        resetTripData()
        bottomBar.backgroundColor = .green
    }
    
    @IBAction func stopTrip(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        bottomBar.backgroundColor = .gray        
        topBar.backgroundColor = .clear
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateTripData(with: location)
        render(location)
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func updateTripData(with location: CLLocation) {
        if let lastLocation = lastLocation {
            let distance = location.distance(from: lastLocation)
            totalDistance += distance
            
            let speed = location.speed
            if speed > maxSpeed {
                maxSpeed = speed
            }
            
            if speed > 0 {
                totalSpeed += speed
                speedCount += 1
            }
            
            let averageSpeed = totalSpeed / Double(speedCount)
            
            // Calculate acceleration
            let acceleration = abs(speed - lastSpeed) / location.timestamp.timeIntervalSince(lastLocation.timestamp)
            if acceleration > maxAcceleration {
                maxAcceleration = acceleration
            }
            
            currentSpeedLabel.text = String(format: "%.2f km/h", speed * 3.6)
            maxSpeedLabel.text = String(format: "%.2f km/h", maxSpeed * 3.6)
            averageSpeedLabel.text = String(format: "%.2f km/h", averageSpeed * 3.6)
            distanceLabel.text = String(format: "%.2f km", totalDistance / 1000)
            accelerationLabel.text = String(format: "%.2f m/s²", maxAcceleration)
            
            if speed * 3.6 > 115 {
                topBar.backgroundColor = .red
            } else {
                topBar.backgroundColor = .clear
            }
            
            lastSpeed = speed
        }
        lastLocation = location
    }
    
    func resetTripData() {
        maxSpeed = 0.0
        totalSpeed = 0.0
        speedCount = 0
        totalDistance = 0.0
        lastLocation = nil
        maxAcceleration = 0.0
        lastSpeed = 0.0
        
    }
}

