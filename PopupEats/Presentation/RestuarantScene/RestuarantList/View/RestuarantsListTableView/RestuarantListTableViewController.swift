//
//  RestuarantListTableViewController.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit
import MapKit

final class RestuarantListTableViewController: UITableViewController {

    var viewModel: RestuarantListViewModel!

    var imagesRepository: RestuarantImageRepository?

    var currentRegion: MKCoordinateRegion?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func reload() {
        tableView.reloadData()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.estimatedRowHeight = RestuarantListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RestuarantListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestuarantListItemCell.reuseIdentifier,
                                                       for: indexPath) as? RestuarantListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(RestuarantListItemCell.self) with reuseIdentifier: \(RestuarantListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }

        cell.fill(with: viewModel.items.value[indexPath.row],
                  imagesRepository: imagesRepository)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
