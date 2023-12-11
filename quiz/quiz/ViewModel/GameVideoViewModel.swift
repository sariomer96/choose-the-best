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
    var playableCount =  0
    var isFinishQuiz = false
    @IBOutlet weak var activity:UIActivityIndicatorView?
    var startIndex = 0
    var roundIndex = 1
    func matchQuiz(attachment:[Attachment], playableCount:Int) -> [[Attachment]] {
         
        matchedList.removeAll()
        var tempAttachList = attachment
        
        tempAttachList.shuffle()
        
        for i in stride(from: 0, to: playableCount/2, by: 1) {
            
            var match = [Attachment]()
            for j in stride(from:i, to: i+2 , by: 1){
                
                
                match.append(tempAttachList[0])
                tempAttachList.remove(at: 0)
            }
            matchedList.append(match)
            
        }
        return matchedList
    }
    func chooseClick(bottomVideoView:YTPlayerView,topVideoView:YTPlayerView,rowIndex:Int) {
        winAttachs.append(matchedAttachs[startIndex][0])
      
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
             setVideo(videoView: bottomVideoView, matchIndex: startIndex, rowIndex: 0)
            setVideo(videoView: topVideoView, matchIndex: startIndex, rowIndex: 1)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(bottomPlayer: bottomVideoView, topPlayer: topVideoView)
            return
        }
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
    
    func setVideo(videoView:YTPlayerView,matchIndex:Int,rowIndex:Int) {
        
        loadIndicator(activityInd: activity!,isPlaying: true)
        let url =   getURL(matchIndex: matchIndex, rowIndex: rowIndex)
        let videoId = getYoutubeVideoID(url: url)
        loadVideo(videoID: videoId, videoView: videoView)
    }
 
    func getURL(matchIndex:Int,rowIndex:Int) -> String {
        
        return  matchedAttachs[matchIndex][rowIndex].url!
    }
    func getYoutubeVideoID(url:String) -> String {
        
        
      let splitUrl = url.split(separator: "v=")

      let idSplit = splitUrl[1]
      let id = idSplit.split(separator: "&")
  
      let videoID = String(id[0])
        return videoID
        
    }
    
    func loadVideo(videoID:String,videoView:YTPlayerView) {
        videoView.load(withVideoId: videoID)
        videoView.currentTime { [self]
            time,error in
            loadIndicator(activityInd: activity!, isPlaying: false)
        }
        
    }
    func getNextTour(bottomPlayer:YTPlayerView,topPlayer:YTPlayerView) {
         
     //  var finish =   winState(winImageView: winImageView)
         
//        if finish == true{
//            disableLabels()
//            return
//        }
        
        playableCount = playableCount/2
        resetIndexes()
        matchedAttachs = matchQuiz(attachment: winAttachs, playableCount: playableCount)
        setVideo(videoView: bottomPlayer, matchIndex: startIndex, rowIndex: 0)
        setVideo(videoView: topPlayer, matchIndex: startIndex, rowIndex: 1)
        winAttachs.removeAll()
        
    }
    func winState(winImageView:UIImageView ) -> Bool {
        if winAttachs.count == 1 {
            print("WIIINN")
            let upper = winAttachs[0].title?.uppercased()
//            winLabel.textColor = .systemRed
//            winLabel.text = "\(upper!) WIN!!"
       
            isFinishQuiz = true
//            rightImageView.isUserInteractionEnabled = false
//            leftImageView.isUserInteractionEnabled = false
           
           
             return true
        }
        return false
    }
    func resetIndexes() {
        startIndex = 0
        roundIndex = 1
    }
}
