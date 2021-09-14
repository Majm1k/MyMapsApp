//
//  Alert.swift
//  MyMapsApp
//
//  Created by Дмитрий Рузайкин on 14.09.2021.
//

import UIKit

extension UIViewController {
    func alertAddAdress(title: String, placeholder: String, completionHandler: @escaping (String) -> Void) { //Метод, который вызывает Alert контроллер, где будем вводить адрес
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alertController.addTextField { textF in
            textF.placeholder = placeholder
        }
        
        let alertOk = UIAlertAction(title: "Ок", style: .default) { action in
            let textFText = alertController.textFields?.first
            guard let text = textFText?.text else {return} //Если получаем текст textField, то передаем его, иначе выходим из метода
            completionHandler(text)
        }
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertError(title: String, message: String){ //Метод, который вызывает Alert контроллер, где будем выводить ошибку
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ок", style: .default)
        
        alertController.addAction(alertOk)
        
        present(alertController, animated: true, completion: nil)
    }
}
