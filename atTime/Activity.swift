//
//  Activity.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascmento Andrade on 17/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import UIKit

class Activity
{
    var name = ""
    var featuredImage: UIImage!
    
    init(name: String, featuredImage: UIImage){
        self.name = name
        self.featuredImage = featuredImage
    }
    
    static func createActivities() -> [Activity]{
        return [Activity(name: "Academia", featuredImage: UIImage(named: "Ellipse 7")!), Activity(name: "Almoçar", featuredImage: UIImage(named: "Ellipse 4")!), Activity(name: "Dormir", featuredImage: UIImage(named: "Ellipse 6")!), Activity(name: "Futebol", featuredImage: UIImage(named: "Ellipse 3")!), Activity(name: "Netflix", featuredImage: UIImage(named: "Ellipse 1")!), Activity(name: "Yoga", featuredImage: UIImage(named: "Ellipse 5")!)]
    }
    
}
