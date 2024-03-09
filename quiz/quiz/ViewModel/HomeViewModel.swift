//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation

enum QuizType {
    case topQuiz
    case recentlyQuiz
}

class HomeViewModel {
    var callbackReloadTopRatedTableView: VoidCallBack?
    var callbackReloadRecentlyTableView: VoidCallBack?
    var callbackStatusCode:CallBack<Int>?
    var quizType:QuizType = .topQuiz
    var categoryList:  [Category]?
    var recentlyList = [QuizResponse]()
    var topQuizList = [QuizResponse]()
    var currentQuizList = [QuizResponse]()
    var callbackFailRequest:CallBack<Error>?

    var currentSizeCount = 10

    var currentRecentlyQuestPageCount = 1
    var isStillExistRecentlyQuest = true
  
    var currentTopRateQuestPageCount = 1
    var isStillExistTopRatedQuest = true
   

    let webService = WebService.shared
     
    func getCategories(completion: @escaping (String?) -> Void) {
     
        webService.getCategories { result,statusCode  in
            switch result {
                
            case .success(let category):
                print(statusCode)
                self.categoryList = category.results
                completion("trigger")
            case .failure(let error):
                print("fail \(statusCode)")
                self.callbackFailRequest?(error)
            }
        }
 
    }
    func setQuizList(quizList:[QuizResponse]) {
        currentQuizList = quizList
        
        callbackReloadTopRatedTableView?()
        
    }
 
    func getRecentlyQuiz() {
        guard isStillExistRecentlyQuest else { return }
        webService.getRecentlyQuiz(page: currentRecentlyQuestPageCount, count: currentSizeCount){ result, statusCode in
            switch result {
            case .success(let apiResponse):
                print(statusCode)
                self.callbackStatusCode?(statusCode ?? 0)
                self.onRecentlyRequestSuccess(response: apiResponse)
                self.callbackReloadRecentlyTableView?()
               
            case .failure(let error):
                print("fail \(statusCode)")
                self.callbackStatusCode?(statusCode ?? 0)
                self.callbackFailRequest?(error)
            }
        }
    }
    func onRecentlyRequestSuccess(response:ApiResponse) {
        if let questionList = response.results {
            self.recentlyList += questionList
   
        }
        self.isStillExistRecentlyQuest = (response.next != nil) ? true : false
        self.checkPaginateEnableRecentlyQuest(self.recentlyList.count, allItemsCount: response.count ?? 0)
     
        self.currentQuizList = self.recentlyList
    }
    
    func getTopRateQuiz(completion: @escaping (String?) -> Void){
        
        webService.getTopRate(page: currentTopRateQuestPageCount, count: currentSizeCount) { result, statusCode in
            switch result {
                 
            case .success(let apiResponse):
                guard let quiz = apiResponse.results else{return}
                print(statusCode)
                self.callbackStatusCode?(statusCode ?? 0)
                self.onTopRateRequestSuccess(apiResponse: apiResponse, quiz: quiz)
           
                completion("trigger")
            case .failure(let error):
                print("fail \(statusCode)")
                self.callbackStatusCode?(statusCode ?? 0)
                self.callbackFailRequest?(error)
            }
        }
   }
    func onTopRateRequestSuccess(apiResponse:ApiResponse,quiz:[QuizResponse]){
        self.topQuizList += quiz
        self.isStillExistTopRatedQuest = (apiResponse.next != nil) ? true : false
        self.checkPaginateEnableTopQuest(self.topQuizList.count, allItemsCount: apiResponse.count ?? 0)
        
        self.currentQuizList = self.topQuizList
    }
    func startPaginateToTopRateQuestions() {
  
           guard isStillExistTopRatedQuest else { return }
         currentTopRateQuestPageCount += 1
         self.getTopRateQuiz { _ in
             self.callbackReloadTopRatedTableView?()
         }
 
       }
     
    func startPaginateToRecentlyQuestions() {
          guard isStillExistRecentlyQuest else { return }
        currentRecentlyQuestPageCount += 1
           self.getRecentlyQuiz()
      }
 
    
    //MARK: CHECK PAGINATE
    private func checkPaginateEnableRecentlyQuest(_ recentlyQuestItemCount: Int?,allItemsCount:Int) {
        guard let recentlyQuestItemCount = recentlyQuestItemCount else {isStillExistRecentlyQuest = false; return }
        if  self.currentSizeCount != recentlyQuestItemCount && allItemsCount == recentlyQuestItemCount {
            isStillExistRecentlyQuest = false
            
        }
    }
    
    private func checkPaginateEnableTopQuest(_ topRatedQuestItemCount: Int?,allItemsCount:Int) {
        guard let topRatedQuestItemCount = topRatedQuestItemCount else { isStillExistTopRatedQuest = false; return }
       
        if  self.currentSizeCount != topRatedQuestItemCount && allItemsCount == topRatedQuestItemCount {
            isStillExistTopRatedQuest = false
            
        }
    }
    //MARK: CHECK PAGINATE
     
    func getQuizList(quizType: QuizType, index: Int) -> QuizResponse? {
        switch quizType {
        case .topQuiz:
            guard topQuizList.count ?? 0 > index else { return nil }
            return topQuizList[index]

        case .recentlyQuiz:
            guard recentlyList.count ?? 0 > index else { return nil }
            return recentlyList[index]
        }
    }

}
