import SwiftUI

struct ContentView: View {
    @State private var inputText: String = "one\ntwo\nthree\nfour\nfive\nsix\nseven\neight\nnine\nten\neleven\ntwelve\nthirteen\nfourteen\nfifteen\nsixteen\nseventeen\neighteen\nnineteen\ntwenty\ntwenty-one\ntwenty-two\ntwenty-three\ntwenty-four\ntwenty-five\ntwenty-six\ntwenty-seven\ntwenty-eight\ntwenty-nine\nthirty\nthirty-one\nthirty-two\nthirty-three\nthirty-four\nthirty-five\nthirty-six\nthirty-seven\nthirty-eight\nthirty-nine\nforty\nforty-one\nforty-two\nforty-three\nforty-four\nforty-five\nforty-six\nforty-seven\nforty-eight\nforty-nine\nfifty\nfifty-one\nfifty-two\nfifty-three\nfifty-four\nfifty-five\nfifty-six\nfifty-seven\nfifty-eight\nfifty-nine\nsixty\nsixty-one\nsixty-two\nsixty-three\nsixty-four\nsixty-five\nsixty-six\nsixty-seven\nsixty-eight\nsixty-nine\nseventy\nseventy-one\nseventy-two\nseventy-three\nseventy-four\nseventy-five\nseventy-six\nseventy-seven\nseventy-eight\nseventy-nine\neighty\neighty-one\neighty-two\neighty-three\neighty-four\neighty-five\neighty-six\neighty-seven\neighty-eight\neighty-nine\nninety\nninety-one\nninety-two\nninety-three\nninety-four\nninety-five\nninety-six\nninety-seven\nninety-eight\nninety-nine\none hundred"
    @State private var outputText: String = ""
    @State private var isToggled: Bool = false
    
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
            VStack {
                HStack {
                    Button("Bubble") {
                        performSearch(type: .Bubble)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Insertion") {
                        performSearch(type: .Insertion)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Mergesort") {
                        performSearch(type: .MergeSort)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Mergesort\nRecursive") {
                        performSearch(type: .MergeSort)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                
                
                VStack {
                    Toggle(isOn: $isToggled) {
                                    Text("Run 1000x:")
                                }
                    Button("Clear Output") {
                        outputText = ""
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    // Function to simulate different search types
    func performSearch(type: SortTypes) {
        let rawListToSort = inputText.components(separatedBy: "\n")
        
        outputText.append("Performing Sorting Type \(type) on \(rawListToSort.count) words.\n")
        
        // limit to 10000 entries
        if (rawListToSort.count > 10000) {
            outputText.append("\nSort limited to 10,000 words. \(rawListToSort.count) detected.  Remove entires \(rawListToSort.count - 10000) from the list.")
            
        }
        // Clean up any words if needed and let the user know.
        let listToSort = choppedStrings(rawStrings: rawListToSort)
        
        if (isToggled) {
            var lowestTime = -1.0
            var fastestTime = -1.0
            var averageTime = -1.0
            
            for index in 0..<1000 {
                
                let startTime = CFAbsoluteTimeGetCurrent()
                switch type {
                case .Bubble:
                    BubbleSort(listToSort: listToSort)
                    
                case .Insertion:
                    InsertionSort(listToSort: listToSort)
                    
                case .MergeSort:
                    MergeSort(listToSort: listToSort)
                    
                case .MergeSortRecursive:
                    MergeSortRecursive(listToSort: listToSort)
                }
                let runtime = CFAbsoluteTimeGetCurrent() - startTime
                if (lowestTime < 0 || runtime < lowestTime) {
                    lowestTime = runtime
                }
                if (fastestTime < 0 || runtime > fastestTime) {
                    fastestTime = runtime
                }
                
                if (averageTime < 0) {
                    averageTime = runtime
                } else {
                    averageTime = ((averageTime * Double(index) + runtime) / (Double(index) + 1.0))
                }
            }
            outputText.append("Slowest Time: \(lowestTime)\n")
            outputText.append("Fastest Time: \(fastestTime)\n")
            outputText.append("Average Time: \(averageTime)\n")
        } else {
            let startTime = CFAbsoluteTimeGetCurrent()
            var retList = [String]()
            
            switch type {
            case .Bubble:
                retList = BubbleSort(listToSort: listToSort)
                
            case .Insertion:
                retList = InsertionSort(listToSort: listToSort)
                
            case .MergeSort:
                retList = MergeSort(listToSort: listToSort)
                
            case .MergeSortRecursive:
                retList = MergeSortRecursive(listToSort: listToSort)
            }
            

            outputText.append("Sorted List: \n\(retList)\n")
            outputText.append("Sorting took \(CFAbsoluteTimeGetCurrent() - startTime).")
        }
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
            .font(.system(size: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum SortTypes {
    case Bubble
    case Insertion
    case MergeSort
    case MergeSortRecursive
}

func choppedStrings(rawStrings: [String]) -> [String] {
    var croppedStrings: [String] = []
    for string in rawStrings {
        if string.count > 50 {
            croppedStrings.append(String(string.prefix(50)) + "...")
        } else {
            croppedStrings.append(string)
        }
    }
    return croppedStrings
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
    guard listToSort.count != 0 else {
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

func MergeSort(listToSort: [String]) -> [String] {
    // break down the string array into arrays of 1 element
    var megaStringArrayArray = listToSort.map { [$0] }
    
    while (megaStringArrayArray.count > 1) {
        var index = 0
        while (index + 1 < megaStringArrayArray.count) {
            megaStringArrayArray[index] = mergeArrayMethodTwo(arrayOne: megaStringArrayArray[index], arrayTwo: megaStringArrayArray[index + 1])
            megaStringArrayArray.remove(at: index + 1)
            index += 1
        }
    }
    
    return megaStringArrayArray[0]
}

func MergeSortRecursive(listToSort: [String]) -> [String] {
    if (listToSort.count <= 1) {
        return listToSort
    }
    
    let middleIndex = listToSort.count / 2
    let arrayOne = Array(listToSort[0..<middleIndex])
    let arrayTwo = Array(listToSort[middleIndex..<listToSort.count])
    
    let sortedArrayOne = MergeSortRecursive(listToSort: arrayOne)
    let sortedArrayTwo = MergeSortRecursive(listToSort: arrayTwo)
    
    return mergeArrayMethodTwo(arrayOne: sortedArrayOne, arrayTwo: sortedArrayTwo)
}

func mergeArrays(arrayOne: [String], arrayTwo: [String]) -> [String] {
    var mergedArray = [String]()
    // avoiding the creating of a duplicate array by crearting index values
    var arrayOneIndex = 0
    var arrayTwoIndex = 0
    
    while (arrayOneIndex < arrayOne.count || arrayTwoIndex < arrayTwo.count) {
        if (arrayOneIndex >= arrayOne.count) {
            mergedArray.append(arrayTwo[arrayTwoIndex])
            arrayTwoIndex += 1
        } else if (arrayTwoIndex >= arrayTwo.count) {
            mergedArray.append(arrayOne[arrayOneIndex])
            arrayOneIndex += 1
        } else {
            if (isBigger(first: arrayOne[arrayOneIndex], second: arrayTwo[arrayTwoIndex])) {
                mergedArray.append(arrayTwo[arrayTwoIndex])
                arrayTwoIndex += 1
            } else {
                mergedArray.append(arrayOne[arrayOneIndex])
                arrayOneIndex += 1
            }
        }
    }
    
    return mergedArray
}

// this is shaving .0001 off of 100 word sort on iphone 15 sim.
func mergeArrayMethodTwo(arrayOne: [String], arrayTwo: [String]) -> [String] {
    var mergedArray = arrayOne
    var arrayOneIndex = 0
    var arrayTwoIndex = 0

    while ((arrayOneIndex < arrayOne.count) && (arrayTwoIndex < arrayTwo.count)) {
        if arrayOne[arrayOneIndex] < arrayTwo[arrayTwoIndex] {
            arrayOneIndex += 1
        } else {
            mergedArray.insert(arrayTwo[arrayTwoIndex], at: arrayOneIndex)
            arrayOneIndex += 1
            arrayTwoIndex += 1
        }
    }
    return mergedArray
}

func isBigger(first: String, second: String) -> Bool {
        return (first > second)
}
