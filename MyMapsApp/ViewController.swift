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
        mapView.delegate = self
        
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
        for index in 0...annotationsArray.count - 2{ //Если всего индексов 0, 1, 2 соответственно есть 3 точки и у последней индекс равен 2 и когда будем обращаться к index + 1 к элементу к индексу 3, то получаем ошибку, поэтому указываем -2
            createDirectionRequest(startCoordinate: annotationsArray[index].coordinate, lastCoordinate: annotationsArray[index + 1].coordinate) //Проходимся по массиву и для каждых двух значений будем выстраивать маршрут (index + 1 -- последний индекс плюс 1)
        }
        mapView.showAnnotations(annotationsArray, animated: true) //Отображение маршрута
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        mapView.removeOverlays(mapView.overlays) //Удаляет все маршруты, которые мы рисуем
        mapView.removeAnnotations(mapView.annotations) //Удаляет все аннотации
        annotationsArray = [MKPointAnnotation]() //Указываем, чтобы массив был пустой
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
    
    //MARK: - FUNCTION CREATE REQUEST
     private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, lastCoordinate: CLLocationCoordinate2D){ //функция для построение маршрута (входные данные: первая и конечная точка координаты)
        
        let startLocation = MKPlacemark(coordinate: startCoordinate) //первую точку берем из входных данных "startCoordinate"
        let lastLocation = MKPlacemark(coordinate: lastCoordinate) //конечную точку берем из входных данных "lastCoordinate"
        
        let request = MKDirections.Request()//Запрос
        request.source = MKMapItem(placemark: startLocation)//источник для запроса (первая точка)
        request.destination = MKMapItem(placemark: lastLocation)//источник для запроса (конечная точка)
        request.transportType = .walking //чтобы маршрут был для пешехода
        request.requestsAlternateRoutes = true //показывать ли альтернативные маршруты
        
        let diraction = MKDirections(request: request)
        diraction.calculate { response, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let responce = response else {
                self.alertError(title: "Ошибка", message: "Маршрут недоступен")
                return
            }
            
            var minRoute = response!.routes[0] //Если маршрут один, то минимальный маршрут берем с нулевым индексом, если больше проходим по циклу
            
            for r in response?.routes ?? []{ //Для каждого маршрута в найденых маршрутах (routes); Проходим по массиву
                minRoute = (r.distance <  minRoute.distance) ? r : minRoute //Кратчайший маршрут равен при условии, если этот маршрут меньше минимально найденного, то будет он, если нет, то оставляем тот, который есть
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
    
    //MARK: - FUNCTION SETUP PLACEMARK
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
            
            if self.annotationsArray.count > 1{ //Появление кнопок с анимацией в 0.5 сек
                UIView.animate(withDuration: 0.5){
                    self.routeButton.isHidden = false
                    self.resetButton.isHidden = false
                }
            }
            
            self.mapView.showAnnotations(self.annotationsArray, animated: true)
        }
    }
}


