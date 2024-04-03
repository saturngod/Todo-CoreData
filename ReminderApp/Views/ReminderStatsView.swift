//
//  ReminderStatsView.swift
//  ReminderApp
//
//

import SwiftUI

struct ReminderStatsView: View {
    
    let icon: String
    let title: String
    var count: Int?
    var iconColor: Color = .blue
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10, content: {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.title)
                    Text(title)
                        .opacity(0.8)
                })
                Spacer()
                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.darkGrey : Color.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: 16.0,style: .continuous))

        }
    }
}

#Preview {
    ReminderStatsView(icon: "calendar", title: "Today",count: 9)
        
}
