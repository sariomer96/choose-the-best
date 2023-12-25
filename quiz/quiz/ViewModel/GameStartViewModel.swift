
import RxSwift
import Foundation

class GameStartViewModel {
    var quizTitle:String?
    var quizImage:String?
    var quiz:QuizResponse?
    var totalAttachScore = 0
    var progress:CGFloat = 0
    
    func getQuiz(completion: @escaping (Bool) -> Void) {
        WebService.shared.getQuiz(quizID: quiz?.id ?? 0) {
            result in
            self.quiz = result
            
            self.totalAttachScore = 0
            for i in self.quiz!.attachments{
                self.totalAttachScore += i.score!
            }
            completion(true)
        }
    }
}
