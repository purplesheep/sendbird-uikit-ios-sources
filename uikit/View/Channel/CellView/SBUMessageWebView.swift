//
//  SBUMessageWebView.swift
//  SendBirdUIKit
//
//  Created by Wooyoung Chung on 7/9/20.
//  Copyright © 2020 SendBird, Inc. All rights reserved.
//

import UIKit

class SBUMessageWebView: UIStackView {
    struct Metric {
        static let imageHeight = 136.f
        static let textTopMargin = 8.f
        static let textSideMargin = 12.f
        static let titleBottomMargin = 4.f
        static let descBottomMargin = 8.f
        static let maxWidth = SBUConstant.messageCellMaxWidth
        static let stackSpacing = 8.f
        static let textMaxPrefWidth = Metric.maxWidth - Metric.textSideMargin * 2
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.preferredMaxLayoutWidth = Metric.textMaxPrefWidth
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let urlLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    var imageHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupStyles()
        self.setupAutolayout()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.setupStyles()
        self.setupAutolayout()
    }
    
    func setupViews() {
        self.axis = .vertical
        self.addArrangedSubview(self.imageView)
        self.addArrangedSubview(self.detailStackView)
        self.detailStackView.addArrangedSubview(self.titleLabel)
        self.detailStackView.addArrangedSubview(self.descriptionLabel)
        self.detailStackView.addArrangedSubview(self.urlLabel)
    }
    
    func setupAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let imageHeightConstraint = self.imageView.heightAnchor
            .constraint(equalToConstant: Metric.imageHeight)
        imageHeightConstraint.isActive = true
        self.imageHeightConstraint = imageHeightConstraint
        self.detailStackView.translatesAutoresizingMaskIntoConstraints = false
        self.detailStackView.isLayoutMarginsRelativeArrangement = true
        
        if #available(iOS 11.0, *) {
            self.detailStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: Metric.textTopMargin,
                leading: Metric.textSideMargin,
                bottom: Metric.textSideMargin,
                trailing: Metric.textSideMargin
            )
        } else {
            self.detailStackView.layoutMargins = UIEdgeInsets(
                top: Metric.textTopMargin,
                left: Metric.textSideMargin,
                bottom: Metric.textSideMargin,
                right: Metric.textSideMargin
            )
        }
        
        if #available(iOS 11.0, *) {
            self.detailStackView.setCustomSpacing(
                Metric.titleBottomMargin,
                after: self.titleLabel
            )
            self.detailStackView.setCustomSpacing(
                Metric.descBottomMargin,
                after: self.descriptionLabel
            )
        } else {
            self.detailStackView.spacing = Metric.stackSpacing
        }
    }
    
    func setupStyles() {}

    func configure(model: SBUMessageWebViewModel) {
        if let imageURL = model.imageURL {
            self.imageView.loadImage(
                urlString: imageURL,
                placeholder: model.placeHolderImage,
                errorImage: model.errorImage,
                option: .imageToThumbnail
            ) { success in
                self.imageView.contentMode = !success ? .center : .scaleAspectFill
            }
            self.imageView.isHidden = false
            self.imageHeightConstraint?.isActive = true
        } else {
            self.imageView.isHidden = true
            self.imageHeightConstraint?.isActive = false
        }
        
        if let titleText = model.titleAttributedText {
            self.titleLabel.attributedText = titleText
            self.titleLabel.isHidden = false
        } else {
            self.titleLabel.isHidden = true
        }
        
        if let descText = model.descAttributedText {
            self.descriptionLabel.attributedText = descText
            self.descriptionLabel.isHidden = false
        } else {
            self.descriptionLabel.isHidden = true
        }
        
        if let urlText = model.urlAttributedText {
            self.urlLabel.attributedText = urlText
            self.urlLabel.isHidden = false
        } else {
            self.urlLabel.isHidden = true
        }
    }
}
