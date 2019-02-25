//
//  JourneysListViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class JourneysListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	private var viewModel = JourneysListViewModel()
	private let cellIdentifier = "journeyCell"
	private let segueViewJourneyView = "goToViewJourneyView"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		applyCloseButton()
    }
	
	func applyCloseButton() {
		let barButtonClose = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.barButtonClosePressed(_: )))
		self.navigationItem.leftBarButtonItem = barButtonClose
	}
	
	@objc func barButtonClosePressed(_ sender:UIBarButtonItem!) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == segueViewJourneyView {
			if let viewControllerJourneyView = segue.destination as? ViewJourneyViewController {
				let indexPath = sender as! IndexPath;
				viewControllerJourneyView.journey = viewModel.journeyForRowAtIndexPath(indexPath: indexPath)
				viewControllerJourneyView.index = indexPath.row
			}
		}
	}
}

extension JourneysListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfJourneysInSection(section: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let journey = viewModel.journeyForRowAtIndexPath(indexPath: indexPath)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JourneyTableViewCell
		
		cell.labelName.text = "Journey \(indexPath.row + 1) - \(FormatHelper.stringFromDate(journey.start))"
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: segueViewJourneyView, sender: indexPath)
	}
}
