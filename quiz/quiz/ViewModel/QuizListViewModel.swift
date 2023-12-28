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
        let url = "\(webService.quizListFromCategoryURL)\(categoryId)"
        WebService.shared.AFGetRequest(requestType: WebService.GetRequestTypes.quizList, url: url, modelResponseType: ApiResponse.self) {
            result in
 
   
            self.quizList = self.webService.quizList
             
            for i in self.quizList {
                guard let image = i.image else { return }
                
                self.imagesList.append(image)
            }
         
            completion("trigger")
            
        }
      
   }
    
    func search(searchText:String,completion: @escaping (Bool)->Void) {
        WebService.shared.searchQuiz(searchText: searchText,categoryID: categoryID ?? 0) { quizlist in
            self.quizList = quizlist
            completion(true)
        }
    }
    
}
