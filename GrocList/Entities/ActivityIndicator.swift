//
//  ActivityIndicator.swift
//  GrocList
//
//  Created by Syed Asad on 03/03/2021.
//

import UIKit

class ActivityIndicator: UIView {
	var activityView: UIActivityIndicatorView?
	func showActivityIndicator(view: UIView, tableView: UITableView) {
		activityView = UIActivityIndicatorView(style: .medium)
		activityView?.center = view.center
		tableView.addSubview(activityView!)
		activityView?.startAnimating()
	}
	func hideActivityIndicator() {
		if activityView != nil {
			activityView?.stopAnimating()
		}
	}
}
