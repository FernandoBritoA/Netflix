//
//  TitleTableViewCell.swift
//  Netflix
//
//  Created by Fernando Brito on 07/08/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier = K.Upcoming.sectionCellID
    
    private let titlePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .label
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func applyConstraints() {
        let titlePosterUIImageViewConstraints = [
            titlePosterUIImageView.widthAnchor.constraint(equalToConstant: 100),
            titlePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // The contentView of the table has an encapsulted height as a pre-setted value when the tableView loads that has
            // a priority of 1000 which for sure won't be satisfied when there are number of constraints from top to bottom of the cell
            // which are result in a different height value than the pre-setted one which will cause a conflict.
            // Making the priority of the bottom constraint < 1000 will recover from this conflict until the table calculates the correct
            // one from subviews of the cell.
            // Then that 999 constraint will be satisfied without any breaks as the pre-con one no longer exists
            titlePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).withPriority(999),
        ]
       
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUIImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -20),
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.widthAnchor.constraint(equalToConstant: 50),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(titlePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "\(Constants.imageURL)\(model.posterPath)") else { return }
        
        // These sd_setImage method comes from SDWebImage package
        titlePosterUIImageView.sd_setImage(with: url)
        
        titleLabel.text = model.titleName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        
        contentView.addSubview(titlePosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
