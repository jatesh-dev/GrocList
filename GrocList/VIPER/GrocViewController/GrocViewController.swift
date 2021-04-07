import UIKit
import Firebase
class GrocViewController: UIViewController {
    @IBOutlet weak var grocTableView: UITableView!
    
    var grocText: String = ""
    var grocData = [Grocs]()
    var doneData = [Grocs]()
    var status: String = ""
    var grocKey: String?
    var assigneeName: String = ""
    var activityView: UIActivityIndicatorView?
    var presenter: GrocViewPresenterProtocol?
    var secondUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader()
        grocTableView.dataSource = self
        grocTableView.delegate = self
        
        guard let grocKey = grocKey else {
            return
        }
        presenter?.getGrocList(grocKey: grocKey)
        
        grocTableView.allowsMultipleSelectionDuringEditing = true
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "GrocList"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09019607843, green: 0.3568627451, blue: 0.6196078431, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "chat"), style: .plain, target: self, action: #selector(chatRoom))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backScreen))
        setUpGrocCells()
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let grocKey = grocKey else {
            return
        }
        presenter?.getGrocList(grocKey: grocKey)
    }
    
    @objc private func backScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func chatRoom() {
        let chatController = ChatRouter.createModule(chatKey: grocKey ?? "", user: secondUser)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    private func setUpGrocCells () {
        let grocLabelCellNib = UINib(nibName: "GrocNameCell", bundle: nil)
        grocTableView?.register(grocLabelCellNib, forCellReuseIdentifier: "GrocNameCell")
        let grocTextFieldCellNib = UINib(nibName: "GrocTextFieldCell", bundle: nil)
        grocTableView?.register(grocTextFieldCellNib, forCellReuseIdentifier: "GrocTextFieldCell")
    }
    
    func buttonActionAddGroc(data: String) {
        guard let userID = Auth.auth().currentUser?.uid, let grocKey = self.grocKey else {
            return
        }
        let grocStruct = Grocs(grocName: data, grocDescription: "", grocAssigneeID: userID, status: "1")
        DispatchQueue.main.async {[weak self] in
            GrocDbManager.shared.setGrocItem(data: grocStruct, roomKey: grocKey)
            self?.presenter?.getGrocList(grocKey: grocKey)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.grocTableView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                self.grocTableView.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
                self.grocTableView.frame.origin.y -= keyboardSize.height
            }
        }
    }
}
