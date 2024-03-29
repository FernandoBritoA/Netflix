//
//  SearchViewController.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

class SearchViewController: UIViewController {
    private var titles: [Title] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: K.Upcoming.sectionCellID)
        
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = K.Search.searchPlaceholder
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = K.Search.navigationBarTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        
        // Search
        searchController.searchResultsUpdater = self
        
        fetchDiscover()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Cover the whole bounds of our screen
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscover() {
        ApiCaller.shared.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Upcoming.sectionCellID, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let currentMovie = titles[indexPath.row]
        let titleName = currentMovie.original_name ?? currentMovie.original_title ?? "Unknown"
        let posterPath = currentMovie.poster_path ?? ""
        
        cell.configure(with: TitleViewModel(
            titleName: titleName,
            posterPath: posterPath
        ))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: viewModel)
                    safeSelf.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        // With this conditions we minimize api calls
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
        resultsController.delegate = self
                
        ApiCaller.shared.search(with: query) { results in
            switch results {
            case .success(let titles):
                
                DispatchQueue.main.async {
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
