//
//  ProductTableViewCell.swift
//  Backendless-Swift
//
//  Created by Dmitry Kulakov on 25.01.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productNameLabel.text = ""
        self.productDescriptionLabel.text = ""
        self.productImageView.image = nil
    }
    
    func configureCell(product: Product) {
        self.productNameLabel.text = product.productName
        self.productDescriptionLabel.text = product.description
        guard let imageURLString = product.imageURL else { return }
        if let imageURL = URL(string: imageURLString) {
            self.productImageView.af_setImage(withURL: imageURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .global(qos: .background), imageTransition: .crossDissolve(0.15), runImageTransitionIfCached: false, completion: { image in
                //
            })
        }        
    }
    
}
