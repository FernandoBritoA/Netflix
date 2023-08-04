//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

// TableView cell; this will contain a collection of new cells (movie gallery)
class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = K.Home.cellIdentifier
    
    private let collectionView: UICollectionView = {
        // A layout object that organizes items into a grid with optional header and footer views for each section.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 120, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}
