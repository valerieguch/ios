import UIKit


class SearchVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI(){
        Button.layer.cornerRadius = 20
        self.textField.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        Button.isEnabled = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func properTextFieldWork(_ sender: Any) {
        if let text = textField.text, text.isEmpty {
            Button.isEnabled = false
        } else {
            Button.isEnabled = true
        }
    }

    @IBAction func search(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ResultVC") as! ResultVC
        vc.authorLabelText = textField.text
        self.navigationController?.pushViewController(vc, animated: true)
        textField.resignFirstResponder()
    }
}


