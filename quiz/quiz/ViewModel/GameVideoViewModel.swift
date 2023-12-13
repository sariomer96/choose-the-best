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
    @IBOutlet weak var topAttachTitle:UILabel?
    @IBOutlet weak var bottomAttachTitle:UILabel?
    @IBOutlet weak var roundLabel:UILabel?
    var startIndex = 0
    var roundIndex = 1
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
    func setAttachmentTitle(title:String,titleLabel:UILabel) {
        titleLabel.text = title
    }
    func chooseClick(bottomVideoView:YTPlayerView,topVideoView:YTPlayerView,rowIndex:Int,completion: @escaping  (Attachment) -> Void) {
        winAttachs.append(matchedAttachs[startIndex][rowIndex])

        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setVideo(videoView: bottomVideoView, matchIndex: startIndex, rowIndex: 1)
            setVideo(videoView: topVideoView, matchIndex: startIndex, rowIndex: 0)
            
            setAttachmentTitle(title: matchedAttachs[startIndex][0].title!, titleLabel: topAttachTitle!)
            setAttachmentTitle(title: matchedAttachs[startIndex][1].title!, titleLabel: bottomAttachTitle!)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(bottomPlayer: bottomVideoView, topPlayer: topVideoView, completion: completion)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count,roundLabel: roundLabel!)
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
           // disableLabels()
   
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
            print("WIIINN")
 
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