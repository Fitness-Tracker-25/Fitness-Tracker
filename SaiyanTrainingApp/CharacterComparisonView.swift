//
//  CharacterComparisonView.swift
//  SaiyanTrainingApp
//
//  Created on 4/13/25.
//

import SwiftUI

// View showing which anime characters the user can beat
struct AnimeComparisonView: View {
    var user: User
    @State private var showAllCharacters = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Character Matchups")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showAllCharacters.toggle()
                    }
                }) {
                    Text(showAllCharacters ? "Show Top" : "Show All")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondary)
                }
            }
            
            if let strongestDefeatable = user.strongestDefeatable(from: animeCharacters) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Strongest Defeat")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    CharacterMatchupView(
                        character: strongestDefeatable,
                        result: "Victory",
                        resultColor: AppTheme.powerGain
                    )
                }
                .padding(.bottom, 5)
            }
            
            if let weakestStronger = user.weakestStrongerCharacter(from: animeCharacters) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Closest Challenge")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    CharacterMatchupView(
                        character: weakestStronger,
                        result: "Keep Training",
                        resultColor: AppTheme.warning
                    )
                }
                .padding(.bottom, 5)
            }
            
            if showAllCharacters {
                Text("All Defeatable Characters")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
                    .padding(.top)
                
                ForEach(user.allDefeatableCharacters(from: animeCharacters).prefix(5)) { character in
                    CharacterMatchupView(
                        character: character,
                        result: "Victory",
                        resultColor: AppTheme.powerGain,
                        showDetail: false
                    )
                    .padding(.vertical, 5)
                }
                
                if user.allDefeatableCharacters(from: animeCharacters).count > 5 {
                    Text("...and \(user.allDefeatableCharacters(from: animeCharacters).count - 5) more")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                        .padding(.top, 5)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// View for individual character matchup
struct CharacterMatchupView: View {
    var character: AnimeCharacter
    var result: String
    var resultColor: Color
    var showDetail: Bool = true
    
    var body: some View {
        HStack {
            // Character icon
            Image(systemName: character.imageSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(AppTheme.accent)
                .padding(8)
                .background(AppTheme.secondaryBackground)
                .clipShape(Circle())
            
            // Character details
            VStack(alignment: .leading) {
                Text(character.name)
                    .fontWeight(.medium)
                
                if showDetail {
                    Text(character.anime)
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            
            Spacer()
            
            // Power level
            VStack(alignment: .trailing) {
                Text("Power Level")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
                
                Text("\(character.powerLevel)")
                    .fontWeight(.semibold)
            }
            
            // Result indicator
            Text(result)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(resultColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(resultColor.opacity(0.2))
                .cornerRadius(5)
        }
        .padding(.vertical, 5)
    }
}
