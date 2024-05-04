//
//  GameStartTourViewModel.swift
//  quiz
//
//  Created by Omer on 2.12.2023.
//

import Foundation
import UIKit

let roundsKey = [
    "Final",
    "Semi Final",
    "Quarter Round",
    "Round Of 16",
    "Round Of 32",
    "Round Of 64",
    "Round Of 128"

]
final class GameStartTourViewModel {
    var rounds = [2, 4, 8, 16, 32, 64, 128]
    var defaulPlayableCount = 2
    var maxPlayableCount = 2
    var quiz: QuizResponse?
    var action = [UIAction]()

    func getActionRoundCount(actionTitle: String) -> Int {
        for (index, obj) in roundsKey.enumerated() {
            if (obj == actionTitle) {
                return rounds[index]
            }
        }
        return rounds[0]
    }

    func getDropDownActions(attachmentCount: Int, completion: @escaping (Int) -> Void) -> [UIAction] {

        let optionClosure = { [self] (action: UIAction) in

           let roundCount = getActionRoundCount(actionTitle: action.title)

            completion(roundCount)

        }

        let round =  getClosestRound(count: (attachmentCount), rounds: rounds, completion: completion)
        let index =  rounds.firstIndex(of: round!)

        for index in stride(from: 0, to: index!+1, by: 1) {
            action.append(UIAction(title: roundsKey[index], state: .on, handler: optionClosure))
        }
        return action
    }

    func getClosestRound(count: Int, rounds: [Int], completion: @escaping (Int) -> Void) -> Int? {
        guard let closest = rounds.filter({ $0 <= count }).max() else {
            return nil
        }
        return closest
    }
}
