//
//  BaseGameViewModel.swift
//  quiz
//
//  Created by Omer on 15.01.2024.
//

import Foundation

class BaseGameViewModel : BaseViewModel {
    
    var callbackRoundName: CallBack<String>?
    func setRoundName(index:Int) {
        let name =  roundsKey[index]
      
        callbackRoundName?(name)
    }
}
