
import Foundation

class GameStartViewModel {
//    var quizTitle:String?
//    var quizImage:String?
    var quiz:QuizResponse?
    var totalAttachScore = 0
    var progress:CGFloat = 0
    
    func getQuiz(completion: @escaping (Bool) -> Void) {
         
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
                print("FAIL GAMESTART \(fail)")
            }
 
        }
        
 
    }
}
