//
//  MainViewController.swift
//  GrocList
//
//  Created by Jatesh Kumar on 02/03/2021.
//
import SideMenu
import Firebase
import UIKit
class MainViewController: UIViewController {
    
    var sideMenu: SideMenuNavigationController?
    var user = [User]()
    var friendList = [User]()
    var grocs = [Grocs]()
    var key: String? = ""
    var currentUserID: String?
    var isGrocRoomCreated: Bool = false
    var activityView: UIActivityIndicatorView?
    var presentor: MainPresenterProtocol?
    var friends: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoGrocsFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        self.labelNoGrocsFound.isHidden = true
        registerProfileCell()
        currentUserID = Auth.auth().currentUser?.uid
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09019607843, green: 0.3568627451, blue: 0.6196078431, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .plain, target: self, action: #selector(logoutUser))
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = view.frame.width-80
        SideMenuManager.default.leftMenuNavigationController = sideMenu
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let currentUserID = self.currentUserID else { return }
        presentor?.showUsers(currentUserID: currentUserID)
    }
    
    @objc private func didTapMenu () {
        present(sideMenu!, animated: true)
    }
    
    @objc private func logoutUser() {
        let alert = UIAlertController(title: "Are You Sure", message: "Do you really want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            let login = LoginRouter.createModule()
            let nav = UINavigationController()
            nav.viewControllers = [login]
            self.navigationController?.pushViewController(login, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func registerProfileCell () {
        let nibProfileCell = UINib(nibName: "MainUserCell", bundle: nil)
        tableView.register(nibProfileCell, forCellReuseIdentifier: "userCell")
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator() {
        if activityView != nil {
            activityView?.stopAnimating()
        }
    }
}
