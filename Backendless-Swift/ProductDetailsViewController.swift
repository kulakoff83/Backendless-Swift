//
//  ProductDetailsViewController.swift
//  Backendless-Swift
//
//  Created by Dmitry Kulakov on 24.01.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureElements() {
        self.productNameLabel.text = product?.productName
        if let productPrice = product?.price {
            self.productPriceLabel.text = String(format: "%.2f", productPrice.floatValue)
        }
        if let image = product?.image {
           self.productImageView.image = image
        }
        self.productDescriptionTextView.text = product?.description
    }
}
