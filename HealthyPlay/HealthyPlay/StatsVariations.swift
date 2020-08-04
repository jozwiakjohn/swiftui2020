//
//  StatsVariations.swift
//  HealthyPlay
//
//  Created by john jozwiak on 6/30/20.
//  Copyright © 2020 john jozwiak. All rights reserved.
//

import Foundation


struct Datum {
    
}

func loadCSV( fromPath: String ) -> (log: String, columnNames: [String], rows: [Datum]) {
    
    let cols = [String]()
    let rows = [Datum]()
    var log  = ""
    if let csvFileURL = Bundle.main.url(forResource: "SampleDataset", withExtension: "csv" ) {
        log = "HEY LOOK I FOUND \(csvFileURL)"
    }
    
    
    return (log,cols,rows)
}
