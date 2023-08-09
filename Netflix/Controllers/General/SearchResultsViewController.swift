//
//  SearchResultsViewController.swift
//  Netflix
//
//  Created by Fernando Brito on 07/08/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var titles: [Title] = []
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // Dynamic width
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (screenWidth / 3) - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let currentMovie = titles[indexPath.row]
        let posterPath = currentMovie.poster_path ?? ""
        cell.configure(with: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        ApiCaller.shared.getMovieTrailer(with: titleName) { [weak self] results in
            switch results {
            case .success(let movie):
                guard let safeSelf = self else {
                    return
                }
                
                let viewModel = TitlePreviewViewModel(
                    title: titleName,
                    youtubeVideoId: movie.id.videoId ?? "",
                    titleOverview: title.overview ?? "")
                
                safeSelf.delegate?.searchResultsViewControllerDidTapItem(viewModel)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       
        
        
        
        
    }
}
