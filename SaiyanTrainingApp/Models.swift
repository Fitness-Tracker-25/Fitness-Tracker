//
//  Models.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import Foundation
import SwiftUI

// User Profile Model
struct User {
    var id: UUID = UUID()
    var name: String
    var powerLevel: Int = 100
    var characterStage: Int = 1 // 1: Base, 2: Kaioken, 3: Super Saiyan, etc.
    var workoutsCompleted: Int = 0
    var streakDays: Int = 0
    var height: Double? // in cm
    var weight: Double? // in kg
    var fitnessGoal: FitnessGoal = .strengthGain
    
    // Character transformation thresholds
    static let transformationThresholds = [
        1000,   // Super Saiyan
        5000,   // Super Saiyan 2
        15000,  // Super Saiyan 3
        50000   // Super Saiyan God
    ]
    
    // Calculate current transformation based on power level
    var currentTransformation: String {
        if powerLevel < Self.transformationThresholds[0] {
            return "Base Form"
        } else if powerLevel < Self.transformationThresholds[1] {
            return "Super Saiyan"
        } else if powerLevel < Self.transformationThresholds[2] {
            return "Super Saiyan 2"
        } else if powerLevel < Self.transformationThresholds[3] {
            return "Super Saiyan 3"
        } else {
            return "Super Saiyan God"
        }
    }
    
    // Calculate next transformation threshold
    var nextTransformationThreshold: Int? {
        for threshold in Self.transformationThresholds {
            if powerLevel < threshold {
                return threshold
            }
        }
        return nil // Already at max transformation
    }
}

// Fitness Goal Options
enum FitnessGoal: String, CaseIterable, Identifiable {
    case weightLoss = "Weight Loss"
    case strengthGain = "Strength Gain"
    case endurance = "Endurance"
    case flexibility = "Flexibility"
    
    var id: String { self.rawValue }
}

// Workout Model
struct Workout: Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: WorkoutType
    var exercises: [Exercise]
    var duration: Int // in minutes
    var difficulty: WorkoutDifficulty
    var powerLevelReward: Int {
        // Calculate reward based on difficulty and duration
        let baseReward = difficulty.baseReward
        return baseReward + (duration / 10) * 20
    }
}

// Workout Type
enum WorkoutType: String, CaseIterable, Identifiable {
    case strength = "Strength"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
    case mixed = "Mixed"
    
    var id: String { self.rawValue }
}

// Workout Difficulty
enum WorkoutDifficulty: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case extreme = "Extreme" // Like training at 100x gravity!
    
    var id: String { self.rawValue }
    
    var baseReward: Int {
        switch self {
        case .beginner: return 50
        case .intermediate: return 100
        case .advanced: return 200
        case .extreme: return 500
        }
    }
}

// Exercise Model
struct Exercise: Identifiable {
    var id: UUID = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double? // in kg (nil for bodyweight exercises)
    var restTime: Int // in seconds
    var instructions: String
    var targetMuscleGroups: [MuscleGroup]
    var completed: Bool = false
}

// Muscle Group
enum MuscleGroup: String, CaseIterable, Identifiable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
    case fullBody = "Full Body"
    
    var id: String { self.rawValue }
}

// Completed Workout Log
struct WorkoutLog: Identifiable {
    var id: UUID = UUID()
    var workoutId: UUID
    var workoutName: String
    var date: Date
    var duration: Int // in minutes
    var powerLevelGained: Int
    var exercisesCompleted: [ExerciseLog]
}

// Exercise Log
struct ExerciseLog: Identifiable {
    var id: UUID = UUID()
    var exerciseId: UUID
    var exerciseName: String
    var sets: Int
    var reps: Int
    var weight: Double?
}

// MARK: - Diet Recommendation Model
struct MealPlan: Identifiable {
    var id: UUID = UUID()
    var name: String
    var targetGoal: FitnessGoal
    var calorieTarget: Int
    var proteinTarget: Int // in grams
    var carbTarget: Int // in grams
    var fatTarget: Int // in grams
    var meals: [Meal]
}

// Meal Model
struct Meal: Identifiable {
    var id: UUID = UUID()
    var name: String
    var time: String // e.g., "Breakfast", "Post-Workout"
    var foods: [Food]
    
    var totalCalories: Int {
        foods.reduce(0) { $0 + $1.calories }
    }
    
    var totalProtein: Int {
        foods.reduce(0) { $0 + $1.protein }
    }
    
    var totalCarbs: Int {
        foods.reduce(0) { $0 + $1.carbs }
    }
    
    var totalFat: Int {
        foods.reduce(0) { $0 + $1.fat }
    }
}

// Food Model
struct Food: Identifiable {
    var id: UUID = UUID()
    var name: String
    var servingSize: String
    var calories: Int
    var protein: Int // in grams
    var carbs: Int // in grams
    var fat: Int // in grams
}
