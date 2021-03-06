//
//  ViewController.swift
//  TestCoreLocation
//
//  Created by John K on 2021-10-14.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var requestLocationButton: UIButton!
    @IBOutlet weak var latitudeValueLabel: UILabel!
    @IBOutlet weak var longitudeValueLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        trackingSwitch.setOn(false, animated: false)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func onClickRequestLocationButton(_ sender: Any) {
        clear()
        requestLocation()
    }
    
    @IBAction func onTrackingSwitchValueChange(_ sender: Any) {
        guard let trackingSwitch = sender as? UISwitch else {
            return
        }
        if trackingSwitch.isOn {
            startTracking()
        } else {
            stopTracking()
        }
    }

}

extension ViewController {
    func startTracking() {
        locationManager.startUpdatingLocation()
        log("Tracking started.")
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        log("Tracking stopped.")
    }
    
    func requestLocation() {
        locationManager.requestLocation()
        log("Location request sent.")
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if (locationManager.authorizationStatus == .authorizedWhenInUse) || (locationManager.authorizationStatus == .authorizedAlways) {
            //
        } else {
            stopTracking()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            log("didUpdateLocations :: empty location list")
            return
        }
        log("didUpdateLocations :: list size: \(locations.count)")
        latitudeValueLabel.text = "\(location.coordinate.latitude)"
        longitudeValueLabel.text = "\(location.coordinate.longitude)"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("didFailWithError :: \(error.localizedDescription)")
    }
}

extension ViewController {
    func log(_ message: String) {
        var text = logTextView.text ?? ""
        if text.count > 0 {
            text = "\n\n\(text)"
        }
        logTextView.text = "\(Date())--\(message)\(text)"
    }
    
    func clear() {
        latitudeValueLabel.text = ""
        longitudeValueLabel.text = ""
        logTextView.text = ""
    }
}

