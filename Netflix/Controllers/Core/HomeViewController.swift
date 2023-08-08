//
//  HomeViewController.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    var trendingMovies: [Title] = []
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)

        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavbar()

        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        getInitalTableData()
    }

    func getInitalTableData() {
        ApiCaller.shared.getTrendingMovies { results in
            switch results {
            case .success(var titles):
                let mainMovie = titles.remove(at: 0)
                self.trendingMovies = titles

                DispatchQueue.main.async {
                    self.view.addSubview(self.homeFeedTable)

                    // The table header will be the hero
                    // view.bounds.width = width = 100%
                    let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
                    headerView.configure(with: mainMovie.poster_path ?? "")
                    self.homeFeedTable.tableHeaderView = headerView
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func configureNavbar() {
        // UIBarButtonItem(image: <#T##UIImage?#>, style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        // We need this for the asset image to load properly. otherwhise it will use all available space
        // https://gist.github.com/sonnguyen0310/6720cbf39ce877c20fea1a987543fb99
        let imageBtn = UIButton(type: .custom)
        imageBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 24)
        imageBtn.setImage(UIImage(named: "netflixLogo"), for: .normal)
        // menuBtn.addTarget(self, action: nil, for: UIControlEvents.touchUpInside)

        let leftitem = UIBarButtonItem(customView: imageBtn)
        let leftItemConstraints = [
            leftitem.customView!.widthAnchor.constraint(equalToConstant: 20),
            leftitem.customView!.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(leftItemConstraints)

        navigationItem.leftBarButtonItem = leftitem
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]

        navigationController?.navigationBar.tintColor = .label
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Cover the whole bounds of our screen
        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            cell.configure(with: trendingMovies)

        case Sections.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTVSeries { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            ApiCaller.shared.getMoviesCollection(type: .popular) { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.UpcomingMovies.rawValue:
            ApiCaller.shared.getMoviesCollection(type: .upcoming) { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            ApiCaller.shared.getMoviesCollection(type: .topRated) { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            cell.configure(with: [])
        }

        return cell
    }

    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // Section header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // Section header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitlizeFirstLetter()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
