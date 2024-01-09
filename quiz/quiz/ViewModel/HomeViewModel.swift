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
                    print("ekle")
                }
                self.isStillExistRecentlyQuest = (apiResponse.next != nil) ? true : false
                self.checkPaginateEnableRecentlyQuest(self.recentlyList.count, allItemsCount: apiResponse.count ?? 0)
             //   self.currentQuizList = self.recentlyList
                print("recent ac")
                self.callbackReloadTopRatedTableView?()
              //  self.callbackReloadRecentlyTableView?()
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
                print("couunt \( self.topQuizList.count)")
                self.currentQuizList = self.topQuizList
               // self.callbackReloadTopRatedTableView?()
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

    // Localde pagination yonetimi
    // sana donecek response sen size sayisi gondericen page sayisi gondericen
    // response model totalItemCount ve sana suanki elaman listesi
    // bana en son gelen responsedaki eleaman sayisi benim istek attigim size sayisina esit degilse item bitmistir
    // VEEE bu totalItemCount her istek attiginda clientta bir array de tutucaksin buaradai
    
    
    /* Pagination Nasil Yapilir ?
     Endpoint Requestinde Beslenecek:
     - Size -> Kacarli Obje listesi alacagin
     - Page -> Hangi Kaclik obje listesini alacagin
     orn: 120 urun page : 3 Size: 20 40 - 60 arasindaki urunleri doner
     
     Endpoint Response Alinabilicekler:
     totalItemCount: Toplam Urun Sayisi
     items: Urun Listesi
     
     Clientta Sayfa sonuna gelindiginde cagri basinda
     (size == items.count) && (totalItemCount != items.count)
     Sorularin icin
     Size sayini besleyeceksin gelen list
    
     */
    //recentlyList = recentlyquestitemcount
        //allItemsCount = tum gelen veriler
    
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
