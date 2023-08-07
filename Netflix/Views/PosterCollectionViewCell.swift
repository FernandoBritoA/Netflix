//
//  PosterCollectionViewCell.swift
//  Netflix
//
//  Created by Fernando Brito on 07/08/23.
//

import UIKit
// This library provides an async image downloader with cache support.
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = K.Home.posterCellID
    
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with posterPath: String){
        
        guard let url = URL(string: "\(Constants.imageURL)\(posterPath)") else {return}
        
        // These sd_setImage method comes from SDWebImage package
        posterImageView.sd_setImage(with: url)
    }
}
