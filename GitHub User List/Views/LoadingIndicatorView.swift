//
//  LoadingIndicatorView.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import UIKit

final class LoadingIndicatorView: UIView {
    
    let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(view)
        layoutViews()
        view.color = .gray
    }
    
    private func layoutViews() {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
