//
//  ContentView.swift
//  StatsTinkering
//
//  Created by john jozwiak on 6/30/20.
//  Copyright © 2020 john jozwiak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let msg = homeworkPuzzle()
        return Text("John HW\n"+msg)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
