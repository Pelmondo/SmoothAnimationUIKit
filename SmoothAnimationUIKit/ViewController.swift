//
//  ViewController.swift
//  SmoothAnimationUIKit
//
//  Created by Сергей Прокопьев on 07.05.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var rectView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var slider: UISlider = {
        let view = UISlider()
        view.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .allEvents)
        view.addTarget(self, action: #selector(sliderEndEditing(_:)), for: .touchUpInside)
        view.minimumValue = 0
        view.maximumValue = 1
        view.tintColor = .cyan
        return view
    }()

    private let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(slider)
        view.addSubview(rectView)

        setupLayout()

        animator.pausesOnCompletion = true
        animator.addAnimations {
            let transform = self.rectView.transform
                .rotated(by: CGFloat.pi / 2).scaledBy(x: 1.5, y: 1.5)
            self.rectView.transform = transform
            self.rectView.center.x = self.view.frame.width - self.rectView.frame.width / 2 - self.view.layoutMargins.right
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        slider.frame = .init(
            x: view.layoutMargins.left,
            y: 250,
            width: view.frame.width - view.layoutMargins.left - view.layoutMargins.right,
            height: 42
        )
    }

    // MARK: - Private

    private func setupLayout() {
        NSLayoutConstraint.activate([
            rectView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 70),
            rectView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            rectView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            rectView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            rectView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }

    @objc private func sliderValueDidChange(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }

    @objc private func sliderEndEditing(_ sender: UISlider) {
        UIView.animate(withDuration: animator.duration - animator.fractionComplete) {
            self.slider.setValue(1, animated: true)
        }
        animator.startAnimation()
    }
}
