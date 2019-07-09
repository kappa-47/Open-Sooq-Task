//
//  MapVC.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/6/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import UIKit
import GoogleMaps
import Toast_Swift


class MapVC: UIViewController {
    
    //Outlets:-
    @IBOutlet weak var mapView: GMSMapView!
    //Variables:-
    private var locationManger = CLLocationManager()
    weak var infoWindow : CustomWindowsView!
    var locationMarker = [GMSMarker]()
    var viewModel = MainViewModel()
    private var currentLocation = CLLocationCoordinate2D()
    private var isLocationDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moveMapToSelectedMarker()
    }
    
    
    func configuerUI() {
        setUpLocationManger()
        handlingOfflineView()
    }
    
    func configuerData() {
        
        viewModel.longLat = "\(currentLocation.latitude),\(currentLocation.longitude)"
        
        _ = SKPreloadingView.show()
        viewModel.getVenues(success: { [weak self] in
            guard let self = self else {return}
            
            SKPreloadingView.hide()
            self.setupMarker()
            self.setupMap()
            
        }) { [weak self] (error) in
            guard let self = self else {return}
            SKPreloadingView.hide()
            self.view.makeToast(error.localizedDescription)
            
        }
    }
    
    func setUpLocationManger() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined,.restricted,.denied:
            locationManger.requestWhenInUseAuthorization()
            break
         default:
            break
        }
        
        locationManger.startUpdatingLocation()
        locationManger.distanceFilter = 200 // will call didUpdateLocation after 200 meter to improve efficiency API Calls
        locationManger.startMonitoringSignificantLocationChanges()
        
    }
    
    func setupMarker() {

        let venues = viewModel.getVenues()
        for (index,venueOjc) in venues.enumerated() {
            let lat = venueOjc.venue?.location?.lat ?? 0
            let long = venueOjc.venue?.location?.lng ?? 0
            locationMarker.append(GMSMarker())
            
            locationMarker[index].position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            locationMarker[index].title = venueOjc.venue?.name
            locationMarker[index].snippet = "\(venueOjc.venue?.location?.distance ?? 0) \(localized(localizeKey: .metersAway))"
            locationMarker[index].map = mapView
        
        }
        
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 17)
        
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
    }
    
    func moveMapToSelectedMarker() {
        if let selectedMarkerIndex = viewModel.selectedMarkerIndex {
            let marker = locationMarker[selectedMarkerIndex]
            mapView.selectedMarker = marker
            mapView.animate(toLocation: marker.position)
        }
    }
    
    func handlingOfflineView() {
        if viewModel.checkForInternetConnection() { //Online
            mapView.isHidden = false
        } else { //OffLine
            mapView.isHidden = true
        }
        self.view.handelOfflineView(isConnected: viewModel.checkForInternetConnection())
    }
}

extension MapVC:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toZoom: 20)
        return false
    }
    
   
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let nib = UINib(nibName: "CustomWindowsView", bundle: nil) // register nib
        infoWindow = (nib.instantiate(withOwner: "CustomWindowsView", options: nil).first as! CustomWindowsView)
        infoWindow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let selectedMareker = mapView.selectedMarker
        infoWindow.nameLbl.text = selectedMareker?.title
        infoWindow.distanceLbl.text = selectedMareker?.snippet

        
        let point = selectedMareker?.position
        let view = UIView(frame: CGRect(x: point?.latitude ?? 0, y: point?.longitude ?? 0, width: 200, height: 120))
        infoWindow.frame = view.bounds
        view.addSubview(infoWindow)
        return view
        
    }
    
    
}

extension MapVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            currentLocation = location
            if viewModel.checkForInternetConnection() { //Check for internet connection first
                configuerData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        var alert = UIAlertController()
        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown:
                alert = UIAlertController(title: localized(localizeKey: .locationUnknown), message: localized(localizeKey: .pleaseTryAgainLater), preferredStyle: .alert)
            case .denied:
                alert = UIAlertController(title: localized(localizeKey: .locationAccessDenied), message: localized(localizeKey: .requiredAccessMsg), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: localized(localizeKey: .openSettings), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    if let url = URL.init(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }

                }))
                alert.addAction(UIAlertAction(title: localized(localizeKey: .cancel), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))

            case .network :
                alert = UIAlertController(title: localized(localizeKey: .connectionError), message: localized(localizeKey: .connectionErrorMsg), preferredStyle: .alert)

            default:
                print(error.localizedDescription)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
