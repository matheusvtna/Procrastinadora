//
//  ActivityCollectionViewCell.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascmento Andrade on 17/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell
{
    // MARK: - Public API
    var activity: Activity!{
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private
    @IBOutlet weak var featuredImageView:UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    
    private func updateUI()
    {
        activityLabel?.text! = activity.name
        featuredImageView?.image = activity.featuredImage
    }
}
