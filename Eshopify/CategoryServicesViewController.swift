//
//  CategoryServicesViewController.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 27/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit

struct CategoryServise: Decodable {
    var productLink: String?
    var id: Int?
    var name: String?
}

struct Servise: Decodable {
    //var embed: Dictionary<String, Any>?
    //var links: Dictionary<String, Any>?
    var embed: [CategoryServise]?
    var links: String?
}


class CategoryServicesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let jsonUrl = "http://evening-tundra-86781.herokuapp.com/api/categories"
        
        guard let url = URL(string: jsonUrl)  else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
            guard let data = data else { return }
//            if let dict = data as? Dictionary<String, Any> {
//                print("Enter")
//            }
            
            do {
                    //let categorys = try JSONDecoder().decode(CategoryServise.self, from: data)
                let servise = try JSONDecoder().decode([Servise].self, from: data)
                print(servise.count)
                print("*********")
                   // print(categorys._embedded)
            } catch let jsonErr {
                print("Error in serilization", jsonErr)
            }
            }.resume()
    }

}
