//
//  ViewController.swift
//  MyMapsApp
//
//  Created by Дмитрий Рузайкин on 13.09.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    //MARK: - PROPERTIES
    
    var annotationsArray = [MKPointAnnotation]()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButton.layer.cornerRadius = 10
        self.routeButton.layer.cornerRadius = 10
            routeButton.isHidden = true
        self.resetButton.layer.cornerRadius = 10
            resetButton.isHidden = true
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func addButton(_ sender: UIButton) {
        alertAddAdress(title: "Добавить", placeholder: "Введите адрес") { text in
            self.setupPlacemark(adress: text)
        }
    }
    
    @IBAction func routeButtonAction(_ sender: UIButton) {
        print("Построить")
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        print("Сбросить")
    }
    
    //MARK: - FUNCTION
    private func setupPlacemark(adress: String){ //Метод настройки метки места
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { placemark, error in
            
            if let error = error{ //Обработка ошибки, если приходит error
                print(error)
                self.alertError(title: "Ошибка", message: "Сервер недоступен. Добавьте адрес еще раз")
                return
            }
            
            guard let placemarks = placemark else {return}
            let placemarkArr = placemarks.first //Тк будет приходить массив с адреами (Например улица пушкина может быть не в одном городе), то берем первый элемент массива, как наилуше подходящий
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adress)"
            guard let placemarkLocation = placemarkArr?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            
            self.annotationsArray.append(annotation)
            
            if self.annotationsArray.count > 1{
                UIView.animate(withDuration: 0.5){
                    self.routeButton.isHidden = false
                    self.resetButton.isHidden = false
                }
            }
            
            self.mapView.showAnnotations(self.annotationsArray, animated: true)
        }
    }
}

