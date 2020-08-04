//
//  ContentView.swift
//  GoofinNutzen
//
//  Created by john jozwiak on 7/4/20.
//  Copyright © 2020 john jozwiak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var greeting : String
    var body: some View {
        VStack{
            Text(greeting)
            HStack{
                Text("blah")
                Text("fart")
            }
            List(1...3,id:\.self, rowContent: {i in Text("item \(i)")})
        }
    }
    init( _ s : String ) {
        self.greeting = s
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView("sup")
    }
}
