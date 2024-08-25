//
//  ViewController.swift
//  Carousel
//
//  Created by Rahul K on 24/08/24.
//

import UIKit

class CarouselViewController: UIViewController {

    private let carouselView = CarouselView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupCarouselView()

        let sampleImages = [
            UIImage(named: "image0")!,
            UIImage(named: "image1")!,
            UIImage(named: "image2")!,
            UIImage(named: "image3")!
        ]

        carouselView.images = sampleImages
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView.centerInitialImage()
    }

    private func setupCarouselView() {
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carouselView)

        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselView.heightAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
    }
}
