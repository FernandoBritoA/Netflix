//
//  HomeViewController.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)

        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)

        configureNavbar()

        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        // The table header will be the hero
        // view.bounds.width = width = 100%
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }

    private func configureNavbar() {
        //UIBarButtonItem(image: <#T##UIImage?#>, style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>)
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
        
        navigationController?.navigationBar.tintColor = .white
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
        return 20
    }

    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
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
}
