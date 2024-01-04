//
//  GameVideoViewModel.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import Foundation
import YouTubeiOSPlayerHelper

class GameVideoViewModel {
    
    var matchedList = [[Attachment]]()
    var matchedAttachs = [[Attachment]]()
    var winAttachs = [Attachment]()
    var isFinishQuiz = false
    var quiz:QuizResponse?
    var startIndex = 0
    var roundIndex = 1
    var playableCount = 2
    var rate = 0
    var isRateSelected = false
    var vote = false
    @IBOutlet weak var activity:UIActivityIndicatorView?
    @IBOutlet weak var topAttachTitle:UILabel?
    @IBOutlet weak var bottomAttachTitle:UILabel?
    @IBOutlet weak var roundLabel:UILabel?
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]

    func matchQuiz(attachment:[Attachment], playableCount:Int) -> [[Attachment]] {
         
        matchedList.removeAll()
        var tempAttachList = attachment
        
        tempAttachList.shuffle()
        
        for i in stride(from: 0, to: playableCount/2, by: 1) {
            
            var match = [Attachment]()
            for _ in stride(from:i, to: i+2 , by: 1){
                
                
                match.append(tempAttachList[0])
                tempAttachList.remove(at: 0)
            }
            matchedList.append(match)
            
        }
        return matchedList
    }
    func getDropDownActions(completion: @escaping (Int) -> Void) -> [UIAction] {
      
        let optionClosure = { [self] (action : UIAction) in
            
            switch action.title{
            case String(rates[0]):
                completion(self.rates[0])
            case String(rates[1]):
                completion(self.rates[1])
            case String(rates[2]):
                completion(self.rates[2])
            case String(rates[3]):
                completion(self.rates[3])
            case String(rates[4]):
                completion(self.rates[4])
            case String(rates[5]):
                completion(self.rates[5])
        
            default:
                completion(-1)
              
            }
           
        }
        action.append(UIAction(title: "Select..", state : .on , handler: optionClosure))
        for i in rates {
            action.append(UIAction(title: String(i), state : .on , handler: optionClosure))
        }

        
        return action
    }
    func setAttachmentTitle(title:String,titleLabel:UILabel) {
        titleLabel.text = title
    }
    func chooseClick(bottomVideoView:YTPlayerView,topVideoView:YTPlayerView,rowIndex:Int,completion: @escaping  (Attachment) -> Void) {
        winAttachs.append(matchedAttachs[startIndex][rowIndex])

        let id =   getAttachmentID(side: rowIndex)
        setAttachmentScore(attachID: id) {
            result in
          
        }
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setVideo(videoView: bottomVideoView, matchIndex: startIndex, rowIndex: 1)
            setVideo(videoView: topVideoView, matchIndex: startIndex, rowIndex: 0)
            
            setAttachmentTitle(title: matchedAttachs[startIndex][0].title!, titleLabel: topAttachTitle!)
            setAttachmentTitle(title: matchedAttachs[startIndex][1].title!, titleLabel: bottomAttachTitle!)
        }
        if winAttachs.count  == matchedAttachs.count  {
          
            getNextTour(bottomPlayer: bottomVideoView, topPlayer: topVideoView, completion: completion)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count,roundLabel: roundLabel!)
    }
   
    
    func setAttachmentScore(attachID:Int,completion: @escaping (String) -> Void) {
       
        WebService.shared.setAttachmentScores(attachID: attachID) {
            result in
            switch result {
                
            case .success(let success):
                  print(success)
            case .failure(let fail):
                print(fail)
            }
        }
    }
    
    func getAttachmentID(side:Int) -> Int{
        
        let id =  matchedAttachs[startIndex][side].id
         return id!
         
    }
 
    func loadIndicator(activityInd:UIActivityIndicatorView,isPlaying:Bool) {
        activityInd.isHidden = !isPlaying
        if isPlaying == true {
            activityInd.startAnimating()
        }else {
            activityInd.stopAnimating()
            activityInd.isHidden = true
        }
       
    }
    func setRound(roundIndex:Int,tourCount:Int,roundLabel:UILabel) {
        roundLabel.text = "\(roundIndex) / \(tourCount)"
    }
    func setVideo(videoView:YTPlayerView,matchIndex:Int,rowIndex:Int) {
        
        loadIndicator(activityInd: activity!,isPlaying: true)
        let url =   getURL(matchIndex: matchIndex, rowIndex: rowIndex)
        let videoId = getYoutubeVideoID(url: url)
        loadVideo(videoID: videoId, videoView: videoView)
    }
    func rateQuiz(quizID:Int,rateScore:Int,completion: @escaping (String) -> Void) {
        WebService.shared.rateQuiz(quizID: quizID, rateScore: rateScore) { result in
            switch result {
                
            case .success(let success):
               
                 print(success)
            case .failure(let fail):
                print(fail)
            }
        }
       // WebService.shared.rateQuiz(quizID: quizID, rateScore: rateScore, completion: completion)
        
    }
    func getURL(matchIndex:Int,rowIndex:Int) -> String {
        
        return  matchedAttachs[matchIndex][rowIndex].url!
    }
    func getYoutubeVideoID(url:String) -> String {
        
        let baseURL = url.replacingOccurrences(of: " ", with: "")
        let splitUrl = baseURL.split(separator: "v=")
 
      let id = splitUrl[1].split(separator: "&")
      var videoID = ""
        if id == nil {
            videoID = String(splitUrl[1])
        }else {
            videoID = String(id[0])
        }
   
        return videoID
        
    }
    
    func loadVideo(videoID:String,videoView:YTPlayerView) {
        videoView.load(withVideoId: videoID)
        videoView.currentTime { [self]
            time,error in
            loadIndicator(activityInd: activity!, isPlaying: false)
        }
        
    }
    func getNextTour(bottomPlayer:YTPlayerView,topPlayer:YTPlayerView,completion: @escaping  (Attachment) -> Void) {
         
       var finish =   winState()

        if finish == true{
           
            completion(winAttachs[0])
            return
        }
        
        playableCount = playableCount/2
        resetIndexes()
        matchedAttachs = matchQuiz(attachment: winAttachs, playableCount: playableCount)
        
        setAttachmentTitle(title: matchedAttachs[startIndex][0].title!, titleLabel: topAttachTitle!)
        setAttachmentTitle(title: matchedAttachs[startIndex][1].title!, titleLabel: bottomAttachTitle!)
        setVideo(videoView: bottomPlayer, matchIndex: startIndex, rowIndex: 1)
        setVideo(videoView: topPlayer, matchIndex: startIndex, rowIndex: 0)
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count,roundLabel: roundLabel!)
        winAttachs.removeAll()
        
    }
    func showPopUp(popUpView:UIView) {
        popUpView.isHidden = false
    }
   
    func winState( ) -> Bool {
        if winAttachs.count == 1 {
       
            isFinishQuiz = true
 
             return true
        }
        return false
    }
    func resetIndexes() {
        startIndex = 0
        roundIndex = 1
    }
}
