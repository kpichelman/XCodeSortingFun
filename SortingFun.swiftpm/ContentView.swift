import SwiftUI

struct ContentView: View {
    @State private var inputText: String = "one\ntwo\nthree\nfour"
    @State private var outputText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Terminal window output
            Text("Output:")
                .font(.headline)
            TextEditor(text: $outputText)
                .font(.system(.body, design: .monospaced))
                .frame(height: 100)
                .border(Color.gray, width: 1)
                .padding()
            
            // Input field
            Text("Input:")
                .font(.headline)
            TextEditor(text: $inputText)
                .font(.system(.body, design: .monospaced))
                .frame(height: 100)
                .border(Color.gray, width: 1)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
            
            // Buttons
            HStack {
                Button("Bubble") {
                    performSearch(type: 1)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Insertion") {
                    performSearch(type: 2)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Mergesort") {
                    performSearch(type: 3)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    // Function to simulate different search types
    func performSearch(type: Int) {
        
        let listToSort = inputText.components(separatedBy: "\n")
        outputText.append("Sorting \(listToSort.count) words.")
        outputText.append("Performing Search Type \(type) with input:\n\(inputText)\n")
        let startTime = CFAbsoluteTimeGetCurrent()
        switch type {
        case 1:
            let retList = BubbleSort(listToSort: listToSort)
            outputText.append("Sorted List: \n\(retList)\n")
            
        case 2:
            let retList = InsertionSort(listToSort: listToSort)
            outputText.append("Sorted List: \n\(retList)\n")
            
        case 3:
            outputText.append("Performing Search Type 3 with input: \(inputText)\n")
        default:
            break
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        outputText.append("Sorting took \(timeElapsed).")
        
    }
}

// Primary button style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func BubbleSort(listToSort: [String]) -> [String] {
    var sortingList = listToSort
    var index =  sortingList.count - 1 // counts backwards, zero index based.
    var currentWordIndex = 0

    while (index > 0) {
        while (currentWordIndex < index) {
            if (isBigger(first: sortingList[currentWordIndex], second: sortingList[currentWordIndex + 1]))
            {
                let tempBiggerWord = sortingList[currentWordIndex]
                sortingList[currentWordIndex] = sortingList[currentWordIndex + 1]
                sortingList[currentWordIndex + 1] = tempBiggerWord
            }
            currentWordIndex += 1
        }

        index -= 1 // finshed a round of sorting
        currentWordIndex = 0
    }
    return sortingList
}

func InsertionSort(listToSort: [String]) -> [String] {
    if (listToSort.count == 0) {
        return listToSort
    }
    
    var sortingList = listToSort
    let currentWord = sortingList.remove(at: 0)
    var sortedList = [String]()
    sortedList.append(currentWord)

    while(sortingList.count > 0) {
        let currentWord = sortingList.remove(at: 0)
        let varMiddleIndex = Int(floor(Double(sortedList.count) / 2.0))
        var index = varMiddleIndex
        let checkingBigger = isBigger(first: currentWord, second: sortedList[index])
        
        while (index >= 0 && index <= sortedList.count) { // should not hit false, but just in case.
            if (checkingBigger) {
                index += 1
                if (index >= sortedList.count || !isBigger(first: currentWord, second: sortedList[index])) {
                    sortedList.insert(currentWord, at: (index))
                    break
                }
            } else {
                index -= 1
                if (index < 0 || isBigger(first: currentWord, second: sortedList[index])) {
                    sortedList.insert(currentWord, at: (index + 1))
                    break
                }
            }
        }
    }
    return sortedList
}


func isBigger(first: String, second: String) -> Bool {
        return (first > second)
}
