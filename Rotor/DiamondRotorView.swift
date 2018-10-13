//
//  DiamondRotorView.swift
//  Rotor
//
//  Created by Paul Wilkinson on 12/10/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import UIKit

protocol DiamondRotorViewDataSource {
	func numberOfElements(in rotorView: DiamondRotorView) -> Int
	func rotorView(_ rotorView: DiamondRotorView, textForElement index:Int) -> String?
}

@IBDesignable class DiamondRotorView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	var dataSource: DiamondRotorViewDataSource? {
		didSet {
			self.reloadData()
		}
	}
	
	var currentIndex: Int {
		get {
		return self.index
		}
		set {
			self.scroll(to: currentIndex)
		}
	}
	
	private var index:Int = 0
	
	@IBInspectable public var diamondColor: UIColor = .white {
		didSet {
			self.topDiamond.diamondColor = diamondColor
			self.rightDiamond.diamondColor = diamondColor
			self.leftDiamond.diamondColor = diamondColor
			self.insertDiamond.diamondColor = diamondColor
		}
	}
	
	private var spacing: CGFloat {
		return min(frame.size.width,frame.size.height)*0.06
	}
	
	private var topDiamond: DiamondView
	private var leftDiamond: DiamondView
	private var rightDiamond: DiamondView
	private var insertDiamond: DiamondView

	
	private var diamondSize: CGFloat {
		return min(frame.size.width,frame.size.height)*0.9
	}

	override init(frame: CGRect) {
		self.topDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.leftDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.rightDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.insertDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		super.init(frame: frame)
		self.addDiamonds()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.topDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.leftDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.rightDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		self.insertDiamond = DiamondView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		super.init(coder: aDecoder)
		self.addDiamonds()
	}
	
	
	override func awakeFromNib() {
		self.reloadData()
	}
	
	public func reloadData() {
		self.updateDiamonds()
	}
	
	public func scroll(to index:Int) {
		guard self.isValid(index: index) else {
			return
		}
		
		self.index = index
		self.updateDiamonds()
	}
	
	public func rotateClockwise() {
		guard let datasource = self.dataSource, self.isValid(index: index-1) else {
			return
		}
		
		if self.isValid(index: index-2) {
			self.insertDiamond.isHidden = false
			self.insertDiamond.text = datasource.rotorView(self, textForElement: index-2)
		} else {
			self.insertDiamond.isHidden = true
		}
		self.insertDiamond.frame = self.leftOffscreenFrame()
		UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
			self.insertDiamond.frame = self.leftFrame()
			self.leftDiamond.frame = self.topFrame()
			self.topDiamond.frame = self.rightFrame()
			self.rightDiamond.frame = self.rightOffscreenFrame()
		}) { (complete) in
			self.index-=1
			self.updateDiamonds()
			self.insertDiamond.frame = self.leftOffscreenFrame()
			self.leftDiamond.frame = self.leftFrame()
			self.topDiamond.frame = self.topFrame()
			self.rightDiamond.frame = self.rightFrame()
		}
		
		
	}
	
	public func rotateCounterClockwise() {
		guard let datasource = self.dataSource, self.isValid(index: index+1) else {
			return
		}
		
		if self.isValid(index: index+2) {
			self.insertDiamond.isHidden = false
			self.insertDiamond.text = datasource.rotorView(self, textForElement: index+2)
		} else {
			self.insertDiamond.isHidden = true
		}
		
		self.insertDiamond.frame = self.rightOffscreenFrame()
		UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut], animations:  {
			self.insertDiamond.frame = self.rightFrame()
			self.rightDiamond.frame = self.topFrame()
			self.topDiamond.frame = self.leftFrame()
			self.leftDiamond.frame = self.leftOffscreenFrame()
		}) { (complete) in
			self.index+=1
			self.updateDiamonds()
			self.insertDiamond.frame = self.leftOffscreenFrame()
			self.leftDiamond.frame = self.leftFrame()
			self.topDiamond.frame = self.topFrame()
			self.rightDiamond.frame = self.rightFrame()
		}
	}
	
	private func isValid(index: Int) -> Bool{
		guard let datasource = self.dataSource else {
			return false
		}
		
		let count = datasource.numberOfElements(in: self)
		return (index >= 0 && index < count)
	}
	
	private func updateDiamonds() {
		guard let datasource = self.dataSource else {
			return
		}
		
		if isValid(index: index-1) {
			self.leftDiamond.isHidden = false
			self.leftDiamond.text = datasource.rotorView(self, textForElement: index-1)
		} else {
			self.leftDiamond.isHidden = true
		}
		
		if isValid(index: index+1){
			self.rightDiamond.isHidden = false
			self.rightDiamond.text = datasource.rotorView(self, textForElement: index+1)
		} else {
			self.rightDiamond.isHidden = true
		}
		
		self.topDiamond.text = datasource.rotorView(self, textForElement: index)
	}
	
	private func addDiamonds() {
		self.addSubview(self.topDiamond)
		self.addSubview(self.leftDiamond)
		self.addSubview(self.rightDiamond)
		self.addSubview(self.insertDiamond)
		self.topDiamond.diamondColor = self.diamondColor
		self.leftDiamond.diamondColor = self.diamondColor
		self.rightDiamond.diamondColor = self.diamondColor
		self.insertDiamond.diamondColor = self.diamondColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.topDiamond.frame = self.topFrame()
		self.leftDiamond.frame = self.leftFrame()
		self.rightDiamond.frame = self.rightFrame()
		self.insertDiamond.frame = self.leftOffscreenFrame()
	}
	
	private func topFrame() -> CGRect {
		let frame = self.bounds
		let midX = frame.width / 2.0
		
		let size = self.diamondSize
		
		return CGRect(x: midX-size/2.0, y: 0, width: size, height: size)
	}
	
	private func leftFrame() -> CGRect {
		let frame = self.bounds
		let midX = frame.width / 2.0
		
		let size = self.diamondSize
		return CGRect(x: midX-size-self.spacing,y: size/2.0 + self.spacing, width: size, height: size)

	}
	
	private func rightFrame() -> CGRect {
		let frame = self.bounds
		let midX = frame.width / 2.0
		
		let size = self.diamondSize
		return CGRect(x: midX+self.spacing,y: size/2.0 + self.spacing, width:size, height: size)

	}
	
	private func leftOffscreenFrame() -> CGRect {
		let frame = self.bounds
		let midX = frame.width / 2.0
		let size = self.diamondSize
		return CGRect(x: midX-(1.5 * size + 2 * self.spacing),y: size + 2 * self.spacing, width: size, height: size)
	}
	
	private func rightOffscreenFrame() -> CGRect {
		let frame = self.bounds
		let midX = frame.width / 2.0
		let size = self.diamondSize
		return CGRect(x: midX + (size/2.0 + 2 * self.spacing),y: size + 2 * self.spacing, width: size, height: size)
	}
	
}
