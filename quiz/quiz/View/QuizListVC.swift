//
//  QuizListVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher
import Cosmos

 final class QuizListVC: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let viewModel = QuizListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        viewModel.quizListDelegate?.getQuizList(completion: { _ in
            DispatchQueue.main.async {

                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true

                self.tableView.reloadData()

            }

        })
        viewModel.callbackReloadQuizTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        viewModel.callbackFail = { [weak self] error in
            guard let self = self else { return }
            self.alert(title: "Error", message: error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {

        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        categoryNameLabel.text = ""
        categoryNameLabel.text = viewModel.nameCategory

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let quarterwayPoint = scrollView.contentSize.height / 3

        if scrollView.contentOffset.y >= quarterwayPoint {

            viewModel.startPaginateToQuiz()
        }

    }
}

extension QuizListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText) { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
}
extension QuizListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.quizList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath)
        as? QuizListTableViewCell

        cell?.nameLabel.text = viewModel.quizList[indexPath.row].title

        let rate = viewModel.quizList[indexPath.row].averageRate
        if rate != nil {
            cell?.starView.rating = Double(rate!)
        } else {
            cell?.starView.rating = 0.0
        }
        cell?.quizImageView.kf.setImage(with: URL(string: viewModel.quizList[indexPath.row].image!),
                                        placeholder: UIImage(named: "loader"))

        let newTable = QuizListTableViewCell()
        return cell ?? newTable

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz =  viewModel.quizList[indexPath.row]

        self.presentGameStartViewController(quiz: quiz)

    }
}
