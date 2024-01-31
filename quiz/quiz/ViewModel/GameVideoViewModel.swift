//
//  GameVideoViewModel.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import Foundation
import YouTubeiOSPlayerHelper

protocol GameVideoModelProtocol {
    var callbackSetAttachmentTitle:CallBack<(String,GameVideoViewModel.AttachmentTitleType)>? {get set}
    
    var callbackLoadIndicator:CallBack<Bool>? {get set}
    var callbackWin:CallBack<Attachment>? {get set}
}

class GameVideoViewModel:BaseGameViewModel, GameVideoModelProtocol{
    var callbackWin: CallBack<Attachment>?
    
    var callbackLoadIndicator: CallBack<Bool>?
 
    
    var callbackSetAttachmentTitle: CallBack<(String,AttachmentTitleType)>?
       
    var winAttachs = [Attachment]()
    var isFinishQuiz = false
    var quiz:QuizResponse?
    
    var playableCount = 2
    var rate = 0
    var isRateSelected = false
    var vote = false
  
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]
    enum AttachmentTitleType {
        case top
        case bottom
    }
  
 
 
    func setAttachmentTitle(title:String,titleLabelType:AttachmentTitleType) {
        callbackSetAttachmentTitle?((title,titleLabelType))
    
        
    }
    func chooseClick(bottomVideoView:YTPlayerView,topVideoView:YTPlayerView,rowIndex:Int,completion: @escaping  (Attachment) -> Void) {
        winAttachs.append(matchedAttachs[startIndex][rowIndex])

        let id =   getAttachmentID(side: rowIndex)
        setAttachmentScore(attachID: id) 
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setVideo(videoView: bottomVideoView, matchIndex: startIndex, rowIndex: 1)
            setVideo(videoView: topVideoView, matchIndex: startIndex, rowIndex: 0)
            
            setAttachmentTitle(title: matchedAttachs[startIndex][0].title!, titleLabelType: AttachmentTitleType.top)
            setAttachmentTitle(title: matchedAttachs[startIndex][1].title!, titleLabelType: AttachmentTitleType.bottom)
        }
        if winAttachs.count  == matchedAttachs.count  {
          
            getNextTour(bottomPlayer: bottomVideoView, topPlayer: topVideoView, completion: completion)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
   
  
    func loadIndicator(isPlaying:Bool) {
        
        callbackLoadIndicator?(isPlaying)
//        activityInd.isHidden = !isPlaying
  
    }
    
    
    func setVideo(videoView:YTPlayerView,matchIndex:Int,rowIndex:Int) {
        
        loadIndicator(isPlaying: true)
        let url =   getURL(matchIndex: matchIndex, rowIndex: rowIndex)
        let videoId = WebService.shared.getYoutubeID(url: url)
        loadVideo(videoID: videoId, videoView: videoView)
    }
     func getURL(matchIndex:Int,rowIndex:Int) -> String {
        
        return  matchedAttachs[matchIndex][rowIndex].url!
    }
 
    
    func loadVideo(videoID:String,videoView:YTPlayerView) {
        videoView.load(withVideoId: videoID)
        videoView.currentTime { [self]
            time,error in
            loadIndicator(isPlaying: false)
        }
        
    }
    func getNextTour(bottomPlayer:YTPlayerView,topPlayer:YTPlayerView,completion: @escaping  (Attachment) -> Void) {
         
       var finish =   winState()

        if finish == true{
           
        
            completion(winAttachs[0])
            callbackWin?(winAttachs[0])
            return
        }
        
        playableCount = playableCount/2
        resetIndexes()
        matchedAttachs = matchQuiz(attachment: winAttachs, playableCount: playableCount)
        self.setRoundName(index: matchedAttachs.count-1)
        setAttachmentTitle(title: matchedAttachs[startIndex][0].title!, titleLabelType: AttachmentTitleType.top)
        setAttachmentTitle(title: matchedAttachs[startIndex][1].title!, titleLabelType: AttachmentTitleType.bottom)
       
        setVideo(videoView: bottomPlayer, matchIndex: startIndex, rowIndex: 1)
        setVideo(videoView: topPlayer, matchIndex: startIndex, rowIndex: 0)
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
        winAttachs.removeAll()
        
    }
    
   
    func winState( ) -> Bool {
        if winAttachs.count == 1 {
       
            isFinishQuiz = true
              
             return true
        }
        return false
    }
   
}
