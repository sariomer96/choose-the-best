import UIKit
 
extension String {
    subscript(_ n: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: n)]
    }
}
var mainWords = "fagfcgadbctafgcfa"


let ch = "acaf"

  
var chars = Array(ch)
 
var gecici = chars
var count = gecici.count   // bu da artacak
var cursor = ch.count




func test(mainWords:String,chars:[Character]) ->String{
    var cursorIndex = 0
    var chars = chars
    let tmpChar = chars
    for a in stride(from: tmpChar.count, to: mainWords.count, by: 1) {
        for i in stride(from: 0, to: mainWords.count, by: 1) {
            var word = ""
           
            for j in stride(from: cursorIndex, to: cursorIndex + a, by: 1) {
              
                if cursorIndex + a > mainWords.count  {
                   
                    break
                }
                var aa = mainWords[j]
                  word.append(aa)
               
            }
            if word.isEmpty == true {
                continue
            }
           
            
             cursorIndex += 1
      
            let tmpWord = word
           
            
            for i in word {
               var index = chars.firstIndex(of: i)
                if index != nil {
                    chars.remove(at: index ?? 0)
                }
                
            }
            if chars.count == 0 {
                print("bitti  \(word)")
                return word
            }
                 chars = tmpChar
        }
        cursorIndex = 0
    }
    return ""
}


 print(test(mainWords: mainWords,chars: chars))
 
//for i in mainWords {
//    
//    for (index,j) in chars.enumerated() {
//           if i == j   {
//           
//               chars.remove(at: index)
//               break
//             
//        }
//    }
//    
//}
 
 
