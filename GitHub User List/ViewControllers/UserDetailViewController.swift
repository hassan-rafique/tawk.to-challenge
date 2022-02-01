//
//  UserDetailViewController.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import UIKit


final class UserDetailViewController: UIViewController {
    
    static let storyboardID = "UserDetailViewController"

    @IBOutlet weak var userDetailView: UserDetailView!
    
    private var viewModel: UserDetailViewModel!
    
    var user: User!
    
    var noteAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    private func setup() {
        viewModel = UserDetailViewModel(user: user, delegate: self)
        userDetailView.controller = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(noteTapped))
        userDetailView.noteLabel.addGestureRecognizer(tap)
        viewModel.updateUserData()
    }
    
    @objc func noteTapped() {
        writeNote()
    }

    
    private func writeNote() {
      
        noteAlert = UIAlertController(title: "Note", message: nil, preferredStyle: .alert)
        noteAlert.addTextField {[unowned self] field in
            field.placeholder = "Write your note..."
            field.text =  user.note
            field.addTarget(self, action: #selector(self.noteChanged(_:)), for: .editingChanged)
        }
        noteAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self] _ in
            let note = self?.noteAlert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.viewModel.addNote(note)
        }))
        noteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        noteAlert.actions[0].isEnabled = user.note != nil
        self.present(noteAlert, animated: true)
    }
    
    @objc func noteChanged(_ field: UITextField) {
        let note = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        noteAlert.actions[0].isEnabled = note.count > 0
    }
    
}

//MARK: - ViewModel Delegates
extension UserDetailViewController: UserDetailViewModelDelegates {
    func networkConnectivityFailed() {
        self.alert(title: "Connection Error", message: "You're not connected to the internet. Please connect to the internet and try again later.")
    }
    
    func noteSaved(_ user: User) {
        userDetailView.setUserDetails(viewModel.user)
    }

    func didFinishUpdatingUserData(_ user: User) {
        userDetailView.hideContentView(false)
        userDetailView.showSkeletonView(false)
        userDetailView.setUserDetails(viewModel.user)
    }
    
    func didStartUpdatingUserData(_ user: User) {
        
        //Show content only if User data exist
        userDetailView.hideContentView(false)
        userDetailView.showSkeletonView(user.seen == false)
        userDetailView.setUserDetails(viewModel.user)
    }
    
    func userDataUpdateFailed(_ error: Error) {
        
        // show warning only if data doesn't exist in local DB
        if user.name == nil {
            userDetailView.showSkeletonView(false)
            userDetailView.hideContentView(true)

        } else {
            userDetailView.showSkeletonView(false)
        }
    }
    
}
