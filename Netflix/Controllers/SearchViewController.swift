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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
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
    
}
