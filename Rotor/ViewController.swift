//
//  ViewController.swift
//  Rotor
//
//  Created by Paul Wilkinson on 12/10/18.
//  Copyright © 2018 Paul Wilkinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var diamondRotor: DiamondRotorView!
	
	let strings = ["One","Two","Three","Four","Five","Six","Seven"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.diamondRotor.dataSource = self
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	@IBAction func leftButtonTapped(_ sender: UIButton) {
		self.diamondRotor.rotateClockwise()
	}
	
	@IBAction func rightButtonTapped(_ sender: UIButton) {
		self.diamondRotor.rotateCounterClockwise()
	}

}

extension ViewController: DiamondRotorViewDataSource {
	func numberOfElements(in rotorView: DiamondRotorView) -> Int {
		return self.strings.count
	}
	
	func rotorView(_ rotorView: DiamondRotorView, textForElement index: Int) -> String? {
		return self.strings[index]
	}
	
	
}

