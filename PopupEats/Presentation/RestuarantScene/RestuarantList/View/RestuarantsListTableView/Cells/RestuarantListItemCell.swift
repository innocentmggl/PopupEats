//
//  RestuarantListItemCell.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import UIKit

final class RestuarantListItemCell: UITableViewCell {

    static let reuseIdentifier = String(describing: RestuarantListItemCell.self)
    static let height = CGFloat(130)
    static let cache = NSCache<AnyObject, AnyObject>()

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet weak var operatingTimeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var restuarantImageView: UIImageView!

    private var viewModel: RestuarantListItemViewModel!
    private var restuarantImagesRepository: RestuarantImageRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    func fill(with viewModel: RestuarantListItemViewModel, imagesRepository: RestuarantImageRepository?) {
        self.viewModel = viewModel
        self.restuarantImagesRepository = imagesRepository

        titleLabel.text = viewModel.name
        ratingLabel.text = viewModel.rating
        operatingTimeLabel.text = viewModel.operatingHours
        operatingTimeLabel.textColor = viewModel.isOpen ? .green : .red
        locationLabel.text = viewModel.location
        updatePosterImage(width: Int(restuarantImageView.imageSizeAfterAspectFit.width))
    }

    private func updatePosterImage(width: Int) {
        restuarantImageView.image = nil
        guard let reference = viewModel.photoReference else { return }

        if (RestuarantListItemCell.cache.object(forKey: reference as AnyObject) != nil),
            let image = RestuarantListItemCell.cache.object(forKey: reference as AnyObject) as? UIImage{
            self.restuarantImageView.image = image
        }
        else{
            imageLoadTask = restuarantImagesRepository?.fetchImage(with: reference, width: width) { [weak self] result in
                guard let self = self else { return }
                guard self.viewModel.photoReference == reference else { return }
                if case let .success(data) = result {
                    let image: UIImage = UIImage(data: data)!
                    self.restuarantImageView.image = image
                    RestuarantListItemCell.cache.setObject(image, forKey: reference as AnyObject)
                }
                self.imageLoadTask = nil
            }
        }
    }
}
