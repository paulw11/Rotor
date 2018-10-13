//
//  DiamondView.swift
//  Rotor
//
//  Created by Paul Wilkinson on 12/10/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import UIKit

@IBDesignable class DiamondView: UIView {

	@IBInspectable var diamondColor: UIColor = .white
	
	private let diamondLayer: CAShapeLayer
	
	private let textLabel = UILabel()
	
	var text: String? {
		didSet {
			self.textLabel.text = text
		}
	}
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override init(frame: CGRect) {
		self.diamondLayer = CAShapeLayer()
		super.init(frame: frame)
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.diamondLayer = CAShapeLayer()
		super.init(coder:aDecoder)
		setupLayers()
	}

	
	private func setupLayers() {
		self.diamondLayer.path = diamondPath()
		self.layer.addSublayer(self.diamondLayer)
		self.textLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.textLabel)
		self.centerYAnchor.constraint(equalTo: self.textLabel.centerYAnchor).isActive = true
		self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
		self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
		self.textLabel.numberOfLines = 0
		self.textLabel.textAlignment = .center
		self.textLabel.lineBreakMode = .byWordWrapping
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.diamondLayer.frame = self.bounds
		self.diamondLayer.fillColor = self.diamondColor.cgColor
		self.diamondLayer.path = self.diamondPath()
	}
	
	private func diamondPath() -> CGPath {
		let path = UIBezierPath()
		let width = self.frame.size.width
		let height = self.frame.size.height
		let midX = width/2.0
		let midY = height/2.0
		path.move(to: CGPoint(x:midX, y:0 ))
		path.addLine(to: CGPoint(x:width,y:midY))
		path.addLine(to: CGPoint(x:midX,y:height))
		path.addLine(to: CGPoint(x:0,y:midY))
		path.close()
		
		return path.cgPath
	}
}
