import UIKit

var greeting = "Hello, playground"

var dd = 5
func test(degist: inout Int){
    degist += 1
     
}

test(degist: &dd)
print(dd)
