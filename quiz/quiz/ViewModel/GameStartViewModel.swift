
import RxSwift
import Foundation

struct GameStartViewModel {
    
    func getQuiz(quizID:Int,completion: @escaping (QuizResponse) -> Void) {
        WebService.shared.getQuiz(quizID: quizID,completion: completion)
    }
}
