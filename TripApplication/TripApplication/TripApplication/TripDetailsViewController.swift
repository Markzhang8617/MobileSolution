//
//  TripDetailsViewController.swift
//  TripApplication
//
//  Created by student on 19/8/2024.
//

import UIKit
import MapKit
import CoreData

class TripDetailsViewController: UIViewController {

    @IBOutlet weak var mymapview: MKMapView!
    @IBOutlet weak var tripdetailsLabel: UILabel!
    var tripname: String?
    var destination: String?

    let apiKey = "625cc13e337c4fb2a0541153242604"
    let baseUrl = "https://api.weatherapi.com/v1/forecast.json"

    var riqi:[String] = []
    var zuigaowendu:[String] = []
    var zuidiwendu:[String] = []
    var tianqizhuangkuang:[String] = []
    var tianqitubiao:[String] = []
    var sidu:[String] = []
    var fengsu:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely unwrap the optional values
        let tripnameText = tripname ?? "No Trip Name"
        let destinationText = destination ?? "No Destination"

        // Set the text of the label with the unwrapped values
        self.tripdetailsLabel.text = "\(tripnameText), \(destinationText)"

        loadData()

        // Get the location coordinates for the destination
        getLocationCoordinates(for: destinationText) { coordinates in
            // Update the map view with the coordinates
            if let coordinates = coordinates {
                let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.mymapview.setRegion(region, animated: true)

                // Add a pin to the map
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = self.destination
                self.mymapview.addAnnotation(annotation)
            }
        }
    }

    @IBOutlet weak var weatherInfp: UILabel!
    @IBOutlet weak var fengsulabel: UILabel!
    @IBOutlet weak var siduLabel: UILabel!
    @IBOutlet weak var wenduLabel: UILabel!

    func loadData(){
        let destinationText = destination ?? ""
        let url = URL(string: "\(baseUrl)?key=\(apiKey)&q=\(destinationText)&days=7")!
        print(url)

        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    if let current = json?["current"] as? [String: Any] {
                        let temperatureC = current["temp_c"] as? Double
                        let iconData = current["condition"] as? [String: Any]
                        let icon = iconData?["icon"] as? String
                        let windSpeed = current["wind_kph"] as? Double
                        let windDirection = current["wind_dir"] as? String
                        let humidity = current["humidity"] as? Int
                        let condition = current["condition"] as? [String: Any]
                        let conditionText = condition?["text"] as? String

                        DispatchQueue.main.async { [self] in
                            self.wenduLabel.text = "\(temperatureC ?? 0)°C"
                            self.fengsulabel.text = "Wind: \(windSpeed ?? 0) kph"
                            //  self.fengxianglabel.text = "\(windDirection ?? "")"
                            self.siduLabel.text = "Humidity: \(humidity ?? 0)%"
                            self.weatherInfp.text = "\(conditionText ?? "")"
                        }

                        print()
                    }

                    if let forecast = json?["forecast"] as? [String: Any],
                       let forecastday = forecast["forecastday"] as? [[String: Any]] {

                        riqi.removeAll()
                        zuigaowendu.removeAll()
                        zuidiwendu.removeAll()
                        tianqizhuangkuang.removeAll()
                        tianqitubiao.removeAll()
                        sidu.removeAll()
                        fengsu.removeAll()

                        for day in forecastday {
                            if let date = day["date"] as? String,
                               let dayData = day["day"] as? [String: Any] {

                                let maxTemp = dayData["maxtemp_c"] as? Double
                                let minTemp = dayData["mintemp_c"] as? Double
                                let condition = dayData["condition"] as? [String: Any]
                                let text = condition?["text"] as? String
                                let icon = condition?["icon"] as? String
                                let humidity = dayData["avghumidity"] as? Int
                                let windSpeed = dayData["maxwind_kph"] as? Double
                                let windDirection = dayData["wind_dir"] as? String

                                riqi.append("\(date)")
                                zuigaowendu.append("\(maxTemp ?? 0)°C")
                                zuidiwendu.append("\(minTemp ?? 0)°C")
                                tianqizhuangkuang.append("\(text ?? "")")
                                tianqitubiao.append("\(icon ?? "")")
                                sidu.append("\(humidity ?? 0)%")
                                fengsu.append("\(windSpeed ?? 0) kph")
                                DispatchQueue.main.async { [self] in
                                    //  theTable.reloadData()
                                }
                                print()
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }

        task.resume()
    }

    // Function to get location coordinates from the destination string
    func getLocationCoordinates(for destination: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destination) { placemarks, error in
            if let error = error {
                print("Error getting coordinates: \(error)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                completion(placemark.location?.coordinate)
            } else {
                print("No location found for: \(destination)")
                completion(nil)
            }
        }
    }
    
    @IBAction func tripExepenseTapped(_ sender: Any) {
        TripExpenseViewController.mytripname = tripname ?? "No Trip Name"
        print("NANA \(tripname)")
        self.performSegue(withIdentifier: "showExepense", sender: true)
    }
    
  
}
