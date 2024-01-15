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
    
    var callbackFail:CallBack<Error>?
    var callbackReloadQuizTableView: VoidCallBack?
    var quizListDelegate:QuizListProtocol?
    let webService = WebService.shared
    var nameCategory:String?

    var quizList = [QuizResponse]()
    var imageList = [UIImage]()
    var imagesList = [String]()
     
    var categoryID:Int?
    var isStillExistQuiz = true
    var currentQuizPageCount = 1
    var currentSizeCount = 10
    init() {
        quizListDelegate = self
    }
    
    func startPaginateToQuiz() {
 
           guard isStillExistQuiz else { return }
              currentQuizPageCount += 1
           self.getQuizList() { _ in
             self.callbackReloadQuizTableView?()
          }
      
       }
    
    private func checkPaginateEnableQuiz(_ recentlyQuestItemCount: Int?,allItemsCount:Int) {
       
        guard let recentlyQuestItemCount = recentlyQuestItemCount else { isStillExistQuiz = false; return }
        if  self.currentSizeCount != recentlyQuestItemCount && allItemsCount == recentlyQuestItemCount {
            isStillExistQuiz = false
            
        }
    }
    
    func getQuizList(completion: @escaping (String?) -> Void) {
        
  
        guard let categoryId = categoryID else{ return }
 
        
         
        webService.getQuizList(pageSize: currentSizeCount, page: currentQuizPageCount, categoryID: categoryId) { result in
            switch result {
            case .success(let list):
                
                guard let list1 = list.results else{
                     return
                }
                self.quizList += list1
                self.isStillExistQuiz = (list.next != nil) ? true : false
                self.checkPaginateEnableQuiz(self.quizList.count, allItemsCount: list.count ?? 0)
       
          
                    for i in self.quizList {
                        guard let image = i.image else { return }
        
                        self.imagesList.append(image)
                    }
                self.callbackReloadQuizTableView?()
                    completion("trigger")
            case .failure(let error):
                print(error)
                self.callbackFail?(error)
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
                self.callbackFail?(fail)
            }
        }
 
    }
    
}
