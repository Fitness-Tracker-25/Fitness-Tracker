//
//  ViewModels.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var workoutLogs: [WorkoutLog] = []
    
    init(user: User = User(name: "Warrior")) {
        self.currentUser = user
        
        // For demo purposes, set initial power level higher to show some anime character comparisons
        #if DEBUG
        self.currentUser.powerLevel = 500
        self.currentUser.workoutsCompleted = 5
        self.currentUser.streakDays = 3
        #endif
    }
    
    func completeWorkout(workout: Workout, duration: Int, exerciseLogs: [ExerciseLog]) {
        // Create workout log
        let log = WorkoutLog(
            id: UUID(),
            workoutId: workout.id,
            workoutName: workout.name,
            date: Date(),
            duration: duration,
            powerLevelGained: workout.powerLevelReward,
            exercisesCompleted: exerciseLogs
        )
        
        // Update user stats
        currentUser.powerLevel += workout.powerLevelReward
        currentUser.workoutsCompleted += 1
        
        // Check if workout was done on consecutive day
        if let lastWorkout = workoutLogs.max(by: { $0.date < $1.date }) {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastWorkout.date) || calendar.isDateInYesterday(lastWorkout.date) {
                currentUser.streakDays += 1
                
                // Bonus power for maintaining streak
                let streakBonus = min(currentUser.streakDays * 10, 200)
                currentUser.powerLevel += streakBonus
            } else {
                // Reset streak if more than a day has passed
                currentUser.streakDays = 1
            }
        } else {
            // First workout
            currentUser.streakDays = 1
        }
        
        // Add to logs
        workoutLogs.append(log)
    }
    
    func getRecommendedWorkouts() -> [Workout] {
        // In a real app, this would filter workouts based on user's goals and level
        return sampleWorkouts.filter { workout in
            switch currentUser.fitnessGoal {
            case .strengthGain:
                return workout.type == .strength
            case .weightLoss:
                return workout.type == .cardio
            case .endurance:
                return workout.type == .cardio
            case .flexibility:
                return workout.type == .flexibility
            }
        }
    }
    
    func getRecommendedDiet() -> MealPlan {
        // In a real app, this would calculate based on user's stats and goals
        return sampleMealPlans.first(where: { $0.targetGoal == currentUser.fitnessGoal }) ?? sampleMealPlans[0]
    }
}

// MARK: - Sample Data
// Sample exercises that would be available in the app

let sampleExercises: [Exercise] = [
    Exercise(
        id: UUID(),
        name: "Gravity Chamber Push-ups",
        sets: 3,
        reps: 12,
        weight: nil,
        restTime: 60,
        instructions: "Place hands shoulder-width apart, lower body to ground, push back up.",
        targetMuscleGroups: [.chest, .shoulders, .arms]
    ),
    Exercise(
        id: UUID(),
        name: "Kamehameha Pulls",
        sets: 4,
        reps: 10,
        weight: 80,
        restTime: 90,
        instructions: "Grasp bar with overhand grip, pull to upper chest, return to starting position.",
        targetMuscleGroups: [.back, .arms]
    ),
    Exercise(
        id: UUID(),
        name: "Spirit Bomb Squats",
        sets: 4,
        reps: 15,
        weight: 100,
        restTime: 120,
        instructions: "Stand with feet shoulder-width apart, lower body until thighs are parallel to ground, return to standing.",
        targetMuscleGroups: [.legs]
    ),
    Exercise(
        id: UUID(),
        name: "Instant Transmission Lunges",
        sets: 3,
        reps: 12,
        weight: nil,
        restTime: 60,
        instructions: "Step forward with one leg, lowering hips until both knees are bent at 90 degrees.",
        targetMuscleGroups: [.legs]
    ),
    Exercise(
        id: UUID(),
        name: "Final Flash Shoulder Press",
        sets: 3,
        reps: 10,
        weight: 45,
        restTime: 60,
        instructions: "Press weights overhead from shoulder position until arms are fully extended.",
        targetMuscleGroups: [.shoulders, .arms]
    ),
    Exercise(
        id: UUID(),
        name: "Kaioken Sprint",
        sets: 5,
        reps: 1,
        weight: nil,
        restTime: 120,
        instructions: "Sprint at maximum effort for 30 seconds, then rest.",
        targetMuscleGroups: [.fullBody]
    )
]

let sampleWorkouts: [Workout] = [
    Workout(
        id: UUID(),
        name: "Super Saiyan Strength",
        type: .strength,
        exercises: [sampleExercises[0], sampleExercises[1], sampleExercises[4]],
        duration: 45,
        difficulty: .intermediate
    ),
    Workout(
        id: UUID(),
        name: "Hyperbolic Time Chamber HIIT",
        type: .cardio,
        exercises: [sampleExercises[5], sampleExercises[2], sampleExercises[3]],
        duration: 30,
        difficulty: .advanced
    ),
    Workout(
        id: UUID(),
        name: "Namekian Flexibility",
        type: .flexibility,
        exercises: [sampleExercises[3]],
        duration: 20,
        difficulty: .beginner
    ),
    Workout(
        id: UUID(),
        name: "Vegeta's Pride Workout",
        type: .mixed,
        exercises: Array(sampleExercises.prefix(5)),
        duration: 60,
        difficulty: .extreme
    )
]

// Sample foods and meals
let sampleFoods: [Food] = [
    Food(id: UUID(), name: "Chicken Breast", servingSize: "150g", calories: 230, protein: 43, carbs: 0, fat: 5),
    Food(id: UUID(), name: "Brown Rice", servingSize: "1 cup cooked", calories: 216, protein: 5, carbs: 45, fat: 2),
    Food(id: UUID(), name: "Broccoli", servingSize: "1 cup", calories: 55, protein: 4, carbs: 11, fat: 0),
    Food(id: UUID(), name: "Salmon", servingSize: "150g", calories: 280, protein: 39, carbs: 0, fat: 13),
    Food(id: UUID(), name: "Sweet Potato", servingSize: "1 medium", calories: 180, protein: 4, carbs: 41, fat: 0),
    Food(id: UUID(), name: "Protein Shake", servingSize: "1 scoop", calories: 120, protein: 25, carbs: 3, fat: 1),
    Food(id: UUID(), name: "Banana", servingSize: "1 medium", calories: 105, protein: 1, carbs: 27, fat: 0),
    Food(id: UUID(), name: "Almonds", servingSize: "1/4 cup", calories: 207, protein: 8, carbs: 7, fat: 18)
]

let sampleMeals: [Meal] = [
    Meal(
        id: UUID(),
        name: "Super Saiyan Breakfast",
        time: "Breakfast",
        foods: [sampleFoods[5], sampleFoods[6], sampleFoods[7]]
    ),
    Meal(
        id: UUID(),
        name: "Warrior's Lunch",
        time: "Lunch",
        foods: [sampleFoods[0], sampleFoods[1], sampleFoods[2]]
    ),
    Meal(
        id: UUID(),
        name: "Power-Up Dinner",
        time: "Dinner",
        foods: [sampleFoods[3], sampleFoods[4], sampleFoods[2]]
    ),
    Meal(
        id: UUID(),
        name: "After Battle Snack",
        time: "Post-Workout",
        foods: [sampleFoods[5], sampleFoods[6]]
    )
]

let sampleMealPlans: [MealPlan] = [
    MealPlan(
        id: UUID(),
        name: "Strength Building Plan",
        targetGoal: .strengthGain,
        calorieTarget: 2800,
        proteinTarget: 180,
        carbTarget: 300,
        fatTarget: 80,
        meals: [sampleMeals[0], sampleMeals[1], sampleMeals[2], sampleMeals[3]]
    ),
    MealPlan(
        id: UUID(),
        name: "Fat Loss Plan",
        targetGoal: .weightLoss,
        calorieTarget: 2000,
        proteinTarget: 160,
        carbTarget: 180,
        fatTarget: 65,
        meals: [sampleMeals[0], sampleMeals[1], sampleMeals[3]]
    )
]
