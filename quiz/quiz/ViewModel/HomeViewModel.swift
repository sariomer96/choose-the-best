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
    var quizType:QuizType = .topQuiz
    var categoryList:  [Category]?
    var recentlyList = [QuizResponse]()
    var topQuizList = [QuizResponse]()
    var currentQuizList = [QuizResponse]()
    

    var currentSizeCount = 10

    var currentRecentlyQuestPageCount = 1
    var isStillExistRecentlyQuest = true
  
    var currentTopRateQuestPageCount = 1
    var isStillExistTopRatedQuest = true
   

    let webService = WebService.shared
     
    func getCategories(completion: @escaping (String?) -> Void) {
     
        webService.getCategories { result in
            switch result {
                
            case .success(let category):
                self.categoryList = category.results
                completion("trigger")
            case .failure(let error):
                print("error \(error)")
            }
        }
 
    }
    func setQuizList(quizList:[QuizResponse]) {
        currentQuizList = quizList
        print(currentQuizList.count)
        callbackReloadTopRatedTableView?()
        
    }
 
    func getRecentlyQuiz(completion: @escaping (String?) -> Void) {
        guard isStillExistRecentlyQuest else { return }
        webService.getRecentlyQuiz(page: currentRecentlyQuestPageCount, count: currentSizeCount){ result in
            switch result {
            case .success(let apiResponse):
               
                if let questionList = apiResponse.results {
                    self.recentlyList += questionList
           
                }
                self.isStillExistRecentlyQuest = (apiResponse.next != nil) ? true : false
                self.checkPaginateEnableRecentlyQuest(self.recentlyList.count, allItemsCount: apiResponse.count ?? 0)
             
                self.callbackReloadTopRatedTableView?()
              
                   completion("trigger")
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    func getTopRateQuiz(completion: @escaping (String?) -> Void){
        
        webService.getTopRate(page: currentTopRateQuestPageCount, count: currentSizeCount) { result in
            switch result {
              
            case .success(let quiz):
                guard let quizy = quiz.results else{return}
                
                
                self.topQuizList += quizy
                self.isStillExistTopRatedQuest = (quiz.next != nil) ? true : false
                self.checkPaginateEnableTopQuest(self.topQuizList.count, allItemsCount: quiz.count ?? 0)
                
                self.currentQuizList = self.topQuizList
         
                completion("trigger")
         
            case .failure(let error):
                print("error \(error)")
            }
        }
   }
    func startPaginateToTopRateQuestions() {
 
        
           guard isStillExistTopRatedQuest else { return }
         currentTopRateQuestPageCount += 1
         self.getTopRateQuiz { _ in
             self.callbackReloadTopRatedTableView?()
         }
       //     getCollections()
       }
    
    // TODO: ONURUN YAPTI[I APIRESPONSE GELEN NEXT DEGERI SON URUNLER ICIN NIL GELIYORSA CALISIR
    func startPaginateToRecentlyQuestions() {
          guard isStillExistRecentlyQuest else { return }
        currentRecentlyQuestPageCount += 1
        print("currentRecentlyQuestPageCount")
        self.getRecentlyQuiz{ _ in
            print("yebile")
            self.currentQuizList = self.recentlyList
            self.callbackReloadTopRatedTableView?()
        }
           
      }
 
    
    //MARK: CHECK PAGINATE
    private func checkPaginateEnableRecentlyQuest(_ recentlyQuestItemCount: Int?,allItemsCount:Int) {
        guard let recentlyQuestItemCount = recentlyQuestItemCount else {print("false"); isStillExistRecentlyQuest = false; return }
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
