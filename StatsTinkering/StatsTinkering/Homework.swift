//
//  Homework.swift
//  StatsTinkering
//
//  Created by john jozwiak on 7/1/20.  (refactoring)
//  Copyright © 2020 john jozwiak. All rights reserved.
//

import Foundation  //  for freopen, to leverage Swift's readline

// Please write an iOS app that:
//
// Processes the dataset and calculates mean and std deviation for each data column.
// Please optimize for performance and memory usage.
//
// Determines which samples for each column is more than 2 std deviations.
//
// Displays in UIKit or SwiftUI the mean and std deviation for each column.
// Display the column result immediately before processing the next column.
//
// Also displays the number of samples in each column are more than 2 std deviations.
//
// The spirit of this assignment is to spark a conversation with you about how you approached the assignment, and what choices you made.

struct Datum {
    var id : UInt32   // these types seem to fit the known data examples.
    var a  : UInt32?
    var b  : Double?
    var c  : Double?
    init?( unparsedRow : String , expectedNumberOfFields: Int ) {
        let fields = unparsedRow.split(separator:",").map {String($0)}
        if fields.count != expectedNumberOfFields { return nil }
        //  really should do something nicer than panic below.
        id = UInt32.init(fields[0])!
        a  = UInt32.init(fields[1])
        b  = Double.init(fields[2])
        c  = Double.init(fields[3])
    }
}

//  Read in the file, line by line, with the first line parsed to yield column names.
//  two obvious choices exist:
//
//     (a) read the entire file into memory, fewer (kernel?) calls, but requiring memory of
//         possibly prohibitively large size for memory constraints.
//     (b) read line by line, making possibly many (kernel?) calls, but limiting memory needed
//         at once to some multiple of the size of the longest line.
//         I intend to try this by using freopen to redirect stdin from a file, programmatically,
//         and then use Swift's readline(strippingNewlines:true).
//         Alternately, I could read() from an InputStream.init(url.csvFileURL) below.
//     (c) use the CreateML library's CSV reader to do the loading....but this is less flexible than (a) and (b).
//
//  Note: the sample data rows look to be of type (UInt32,UInt32,Double,Float).

//  here is the (a) file -> memory all at once craziness...space-irrresponsible.

func loadCSVUsingStringContentsOfFile() -> (commentary: String, columnNames: [String], rows: [Datum]) {
    
    var cols = [String]()
    var rows = [Datum]()
    var msg  = ""
    
    if let csvFileURL = Bundle.main.url(forResource: "SampleDataset", withExtension: "csv" ) {
        
        msg = "Loaded \(csvFileURL)"
        
        if let bigString = try? String( contentsOf: csvFileURL ) {
            let lines =
                bigString
                    .components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    .filter{ s in s.count > 0 }  //  only keep non-empty lines
            if lines.count > 0 {
                cols = lines[0].split(separator:",").map { String($0)}
                let ncolumns = cols.count
                for row in lines[1...] {
                    if let datum = Datum(unparsedRow: row, expectedNumberOfFields: ncolumns) {
                        rows.append(datum)
                    }
                }
                msg = "file has \(lines.count-1) data rows" + "\n\(cols)\n" + lines[0] + "\n" + lines[1] + "\n" + lines[2]
            }
        }
    }
    
    return (msg,cols,rows)
}

//  here is the (b) read a line in at a time from the file approach, to lessen memory footprint on parsing...perhaps pipeline parallelize ingestion.

func loadCSVUsingReadLineAndFreopen() -> (commentary: String, columnNames: [String], rows: [Datum]) {
    
    var cols = [String]()
    var rows = [Datum]()
    var msg  = ""
    
    if let csvFilePath = Bundle.main.path(forResource: "SampleDataset", ofType:"csv") {
        errno = 0
        // msg = "freopen( \(csvFilePath) )"
        if freopen(csvFilePath,"r",stdin) != nil {
            cols = readLine(strippingNewline: true)!.split(separator:",").map { String($0) }
            let ncolumns = cols.count
            while let row = readLine(strippingNewline: true) {
                if let datum = Datum(unparsedRow: row, expectedNumberOfFields: ncolumns) {
                    rows.append(datum)
                }
            }
            msg += "\(rows.count) raw rows\n"
        }
    }
    
    return (msg,cols,rows)
}

//  a one pass algorithm is detailed at https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Online_algorithm
//  a one pass algorithm could be paired with the one pass file-parser used above (via Freopen).
//  However, the assignment says to finish processing one column before doing the next, so best to load into memory once.

//  Could still, once loaded into memory, do something more efficient, per column, than a 2 pass algorithm.
//  the algorithm below is a simple 2-pass algorithm, for deriving stddev:
//  it presumes all the (parsed to native types) data fits in memory.

struct IndexAndDouble {
    let i : UInt32
    let v : Double
    init( index : UInt32 , value : Double ) {
         i = index
        v = value
    }
}

func simplestatistics( _ indexedrawnumbers : [IndexAndDouble] ) -> String {

    let indexednumbers = indexedrawnumbers.filter { n in !n.v.isNaN }  //  these all have actual numeric Double values, no NaN instances.
    let N = indexednumbers.count
    if N > 0 {
        let mean                  : Double             = indexednumbers.reduce( 0.0 , {$0 + $1.v}) / Double(N)
        let variance              : Double             = indexednumbers.map { let delta = $0.v - mean; return delta*delta}.reduce( 0.0 , {$0+$1} ) / Double(N-1)
        let stddev                : Double             = sqrt(variance)
        let stddevsfrommean       : [ IndexAndDouble ] = indexedrawnumbers.map { IndexAndDouble(index:$0.i,value:abs($0.v - mean)/stddev) }
        let items2stddevsfrommean : [ IndexAndDouble ] = stddevsfrommean.filter { $0.v > 2.0 }
        var result = ""// "numbers:\n\(indexednumbers[0].v)\n\(indexednumbers[1].v)\n\(indexednumbers[2].v)\nmean = \(mean)\nstddev = \(stddev)\n"
        result += "mean = \(mean)\nstddev = \(stddev)\n"
        result += "\(items2stddevsfrommean.count) items >2 stddevs from mean:\n"
        for item in items2stddevsfrommean {
            result += "\(item.i) -> \(item.v)\n"
        }
        return result
    } else {
        return "uhoh\n"
    }
}

func homeworkPuzzle() -> String {

    var msg : String
    var rows : [Datum]
    (msg , _ , rows) = loadCSVUsingReadLineAndFreopen()
    
    msg +=  "\nCol A:\n" + simplestatistics(
        rows
        .filter {$0.a != nil}                                            //  parse errors turned into nils as optionals
        .map{ IndexAndDouble(index: $0.id , value: Double($0.a!)) }
        .filter { !$0.v.isNaN }
    )
    
    msg +=  "\nCol B:\n" + simplestatistics(
        rows
        .filter {$0.b != nil}                                            //  parse errors turned into nils as optionals
        .map{ IndexAndDouble(index: $0.id , value: $0.b!) }
        .filter { !$0.v.isNaN }
    )
    
    msg +=  "\nCol C:\n" + simplestatistics(
        rows
        .filter {$0.c != nil}                                            //  parse errors turned into nils as optionals
        .map{ IndexAndDouble(index: $0.id , value: $0.c!) }
        .filter { !$0.v.isNaN }
    )
    
    return msg
}
