//
//  QuizListViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit
 

protocol QuizListProtocol {
    func getQuizList(completion: @escaping (String?) -> Void)
}
class QuizListViewModel : QuizListProtocol {
    
 
    var quizListDelegate:QuizListProtocol?
    let webService = WebService.shared
    var nameCategory:String?

    var quizList = [QuizResponse]()
    var imageList = [UIImage]()
    var imagesList = [String]()
    var imageViewList = [UIImageView]()
    var categoryID:Int?
    
    init() {
        quizListDelegate = self
    }
    
    
    func getQuizList(completion: @escaping (String?) -> Void) {
        
  
        guard let categoryId = categoryID else{ return }
 
        webService.getQuizList(categoryID: categoryId) { result in
            switch result {
            case .success(let list):
                self.quizList = list.results!
                    for i in self.quizList {
                        guard let image = i.image else { return }
        
                        self.imagesList.append(image)
                    }
        
                    completion("trigger")
            case .failure(let error):
                print(error)
            }
        }
   }
    
    func search(searchText:String,completion: @escaping (Bool)->Void) {
        
        webService.searchQuizs(searchText: searchText, categoryID: categoryID ?? 0) { result in
            switch result {
                
            case .success(let quizList):
       
                guard let list = quizList.results else {return}
                self.quizList = list
            
                completion(true)
               
            case .failure(let fail):
                print(fail)
            }
        }
 
    }
    
}
