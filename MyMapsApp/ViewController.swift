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
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
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
            print(text)
        }
    }
    
    @IBAction func routeButtonAction(_ sender: UIButton) {
        print("Построить")
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        print("Сбросить")
    }
}

