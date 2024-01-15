
import Foundation

class GameStartViewModel {
 
    private var quiz:QuizResponse? // private yap  disari erisime kapat
    var totalAttachScore = 0
    var progress:CGFloat = 0
    var callbackFailAlert:CallBack<Error>?
    func getQuizResponse(completion: @escaping (Bool) -> Void) {
         
        WebService.shared.getQuiz(quizID: quiz?.id ?? 0) {
            result in
            
            switch result {
                
            case .success(let quiz):
                self.quiz = quiz
          
                self.totalAttachScore = 0
                for i in self.quiz!.attachments{
                    self.totalAttachScore += i.score!
                }
                completion(true)
            case .failure(let fail):
                self.callbackFailAlert?(fail)
            }
 
        }
    }

    func getQuizImage() -> String {
        return quiz?.image ?? ""
    }
    func getQuiz() -> QuizResponse? {
        return quiz
    }
    func getAttachments()  -> [Attachment]?{
        return quiz?.attachments
    }
    func setQuiz(quiz: QuizResponse) {
        self.quiz = quiz
    }
}
