//
//  AnimeCharacterModel.swift
//  SaiyanTrainingApp
//
//  Created on 4/13/25.
//

import Foundation

// Model for anime characters with power levels
struct AnimeCharacter: Identifiable {
    var id: UUID = UUID()
    var name: String
    var anime: String
    var powerLevel: Int
    var imageSystemName: String  // For SF Symbol representation
    
    // Helper function to determine if user can beat this character
    func canBeat(userPowerLevel: Int) -> Bool {
        return userPowerLevel >= self.powerLevel
    }
}

// Extension for User to find matchups
extension User {
    // Returns the strongest character the user can beat
    func strongestDefeatable(from characters: [AnimeCharacter]) -> AnimeCharacter? {
        let defeatedCharacters = characters.filter { $0.powerLevel <= self.powerLevel }
        return defeatedCharacters.max(by: { $0.powerLevel < $1.powerLevel })
    }
    
    // Returns the weakest character that can beat the user
    func weakestStrongerCharacter(from characters: [AnimeCharacter]) -> AnimeCharacter? {
        let strongerCharacters = characters.filter { $0.powerLevel > self.powerLevel }
        return strongerCharacters.min(by: { $0.powerLevel < $1.powerLevel })
    }
    
    // Returns all characters the user can beat
    func allDefeatableCharacters(from characters: [AnimeCharacter]) -> [AnimeCharacter] {
        return characters.filter { $0.powerLevel <= self.powerLevel }
            .sorted(by: { $0.powerLevel > $1.powerLevel })
    }
}

// Sample data for anime characters and their power levels
let animeCharacters: [AnimeCharacter] = [
    AnimeCharacter(name: "Krillin (DBZ)", anime: "Dragon Ball", powerLevel: 75, imageSystemName: "person.fill"),
    AnimeCharacter(name: "Yamcha", anime: "Dragon Ball", powerLevel: 180, imageSystemName: "figure.softball"),
    AnimeCharacter(name: "Videl", anime: "Dragon Ball", powerLevel: 300, imageSystemName: "figure.kickboxing"),
    AnimeCharacter(name: "Chi-Chi", anime: "Dragon Ball", powerLevel: 130, imageSystemName: "figure.arms.open"),
    AnimeCharacter(name: "Naruto (Academy)", anime: "Naruto", powerLevel: 400, imageSystemName: "figure.run"),
    AnimeCharacter(name: "Sakura (Genin)", anime: "Naruto", powerLevel: 600, imageSystemName: "figure.wave"),
    AnimeCharacter(name: "Rock Lee (Weights)", anime: "Naruto", powerLevel: 800, imageSystemName: "figure.martial.arts"),
    AnimeCharacter(name: "Konohamaru", anime: "Naruto", powerLevel: 500, imageSystemName: "figure.roll"),
    AnimeCharacter(name: "Tanjiro (Beginning)", anime: "Demon Slayer", powerLevel: 1200, imageSystemName: "figure.hiking"),
    AnimeCharacter(name: "Zenitsu (Asleep)", anime: "Demon Slayer", powerLevel: 2000, imageSystemName: "bolt.fill"),
    AnimeCharacter(name: "Inosuke", anime: "Demon Slayer", powerLevel: 1800, imageSystemName: "figure.wrestling"),
    AnimeCharacter(name: "Deku (5%)", anime: "My Hero Academia", powerLevel: 2500, imageSystemName: "figure.socialdance"),
    AnimeCharacter(name: "Bakugo (Beginning)", anime: "My Hero Academia", powerLevel: 3000, imageSystemName: "flame.fill"),
    AnimeCharacter(name: "Uraraka", anime: "My Hero Academia", powerLevel: 1500, imageSystemName: "figure.gymnastics"),
    AnimeCharacter(name: "Saitama", anime: "One Punch Man", powerLevel: 999999, imageSystemName: "figure.stand"),
    AnimeCharacter(name: "Nami", anime: "One Piece", powerLevel: 4000, imageSystemName: "cloud.bolt.fill"),
    AnimeCharacter(name: "Usopp", anime: "One Piece", powerLevel: 5000, imageSystemName: "figure.archery"),
    AnimeCharacter(name: "Vegeta (Saiyan Saga)", anime: "Dragon Ball Z", powerLevel: 18000, imageSystemName: "bolt.circle.fill"),
    AnimeCharacter(name: "Frieza (First Form)", anime: "Dragon Ball Z", powerLevel: 530000, imageSystemName: "hurricane"),
    AnimeCharacter(name: "Perfect Cell", anime: "Dragon Ball Z", powerLevel: 900000, imageSystemName: "atom")
]
