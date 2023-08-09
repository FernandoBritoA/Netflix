//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

// TableView cell; this will contain a collection of new cells (movie gallery)
class CollectionViewTableViewCell: UITableViewCell {
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    static let identifier = K.Home.sectionCellID
    
    private var titles: [Title] = []

    private let collectionView: UICollectionView = {
        // A layout object that organizes items into a grid with optional header and footer views for each section.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 120, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
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
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadItem(at indexPath: IndexPath) {
        let title = titles[indexPath.row]
        DataPersistenceManager.shared.downloadTitle(with: title) { result in
            switch result {
            case .success():
                print("Downloaded content successfully")
            
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
        
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }

        let posterPath = titles[indexPath.row].poster_path ?? ""
        cell.configure(with: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        ApiCaller.shared.getMovieTrailer(with: titleName) { [weak self] results in
            switch results {
            case .success(let movie):
                guard let safeSelf = self else { return }
                
                safeSelf.delegate?.collectionViewTableViewCellDidTapCell(safeSelf, viewModel: TitlePreviewViewModel(
                    title: titleName,
                    youtubeVideoId: movie.id.videoId ?? "",
                    titleOverview: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadItem(at: indexPath)
            }
            
            return UIMenu(title: "Menu options", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
}
