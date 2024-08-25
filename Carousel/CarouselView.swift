//
//  CarouselView.swift
//  Carousel
//
//  Created by Rahul K on 25/08/24.
//

import UIKit

class CarouselView: UIView, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private var imageViews = [UIImageView]()

    var images: [UIImage] = [] {
        didSet {
            setupImageViews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupImageViews() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()

        var previousImageView: UIImageView?
        let imageViewWidth = UIScreen.main.bounds.width * 0.7

        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            imageViews.append(imageView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])

            if let previous = previousImageView {
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: -50).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }

            previousImageView = imageView
        }

        if let lastImageView = imageViews.last {
            lastImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }

        // Adjust the content inset to ensure images are aligned properly
        let sideInset = (UIScreen.main.bounds.width - imageViewWidth) / 2
        scrollView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        scrollView.contentOffset = CGPoint(x: -sideInset, y: 0)  // Ensure the initial offset starts from the first image
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        for imageView in imageViews {
            let distance = abs(imageView.center.x - centerX)
            let scale = max(1 - distance / scrollView.bounds.width, 0.75)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // Adjust the zPosition based on distance to center
            imageView.layer.zPosition = 1 - distance / scrollView.bounds.width
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetX = targetContentOffset.pointee.x + scrollView.bounds.width / 2
        let closest = imageViews.min(by: { abs($0.center.x - targetX) < abs($1.center.x - targetX) })

        if let closest = closest {
            let targetOffsetX = closest.center.x - scrollView.bounds.width / 2
            targetContentOffset.pointee = CGPoint(x: targetOffsetX, y: targetContentOffset.pointee.y)
        }
    }

    func centerInitialImage() {
        let centerIndex = 0
        let xOffset = CGFloat(centerIndex) * UIScreen.main.bounds.width * 0.7 - scrollView.contentInset.left
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        scrollViewDidScroll(scrollView)
    }
}
