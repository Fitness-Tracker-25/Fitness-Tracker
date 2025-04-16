//
//  DietProfileViews.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import SwiftUI

// Diet View
struct DietView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Diet Plan Header
                    let mealPlan = viewModel.getRecommendedDiet()
                    
                    // Header with improved styling
                    VStack(alignment: .leading, spacing: 8) {
                        Text(mealPlan.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.text)
                        
                        Text("Optimized for \(mealPlan.targetGoal.rawValue)")
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cardCornerRadius)
                    
                    // Macro targets with styled cards
                    MacroTargetsView(mealPlan: mealPlan)
                    
                    // Meals section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Daily Meal Plan")
                            .font(.headline)
                            .foregroundColor(AppTheme.text)
                            .padding(.top)
                        
                        // Meal cards with improved styling
                        ForEach(mealPlan.meals) { meal in
                            MealView(meal: meal)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "0A0A0A"))
            }
            .navigationTitle("Saiyan Nutrition")
        }
    }
}

// Macro Targets View
struct MacroTargetsView: View {
    var mealPlan: MealPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Targets")
                .font(.headline)
                .foregroundColor(AppTheme.text)
            
            HStack {
                MacroItemView(
                    value: "\(mealPlan.calorieTarget)",
                    label: "Calories",
                    color: AppTheme.warning
                )
                
                MacroItemView(
                    value: "\(mealPlan.proteinTarget)g",
                    label: "Protein",
                    color: AppTheme.secondary
                )
                
                MacroItemView(
                    value: "\(mealPlan.carbTarget)g",
                    label: "Carbs",
                    color: AppTheme.powerGain
                )
                
                MacroItemView(
                    value: "\(mealPlan.fatTarget)g",
                    label: "Fat",
                    color: AppTheme.accent
                )
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Macro Item View
struct MacroItemView: View {
    var value: String
    var label: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.text)
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.15))
        .cornerRadius(10)
    }
}

// Meal View
struct MealView: View {
    var meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Meal header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(meal.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.text)
                    
                    Text(meal.time)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                }
                
                Spacer()
                
                // Calories badge
                Text("\(meal.totalCalories) kcal")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AppTheme.accent.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Divider()
                .background(AppTheme.secondaryText.opacity(0.5))
            
            // Food items
            VStack(alignment: .leading, spacing: 10) {
                ForEach(meal.foods) { food in
                    FoodItemView(food: food)
                }
            }
            
            Divider()
                .background(AppTheme.secondaryText.opacity(0.5))
            
            // Meal totals
            HStack {
                Text("Total Macros:")
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.text)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Label("\(meal.totalProtein)p", systemImage: "p.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondary)
                    
                    Label("\(meal.totalCarbs)c", systemImage: "c.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.powerGain)
                    
                    Label("\(meal.totalFat)f", systemImage: "f.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.accent)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Food Item View
struct FoodItemView: View {
    var food: Food
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.text)
                
                Text(food.servingSize)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Text("\(food.calories) kcal")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.text)
            }
        }
        .padding(.vertical, 5)
    }
}

// Profile View
struct ProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var isEditingProfile = false
    @State private var tempName = ""
    @State private var tempHeight: String = ""
    @State private var tempWeight: String = ""
    @State private var tempGoal: FitnessGoal = .strengthGain
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background based on transformation
                AppTheme.transformationGradient(for: viewModel.currentUser.currentTransformation)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile header with avatar
                        ProfileHeaderView(user: viewModel.currentUser)
                        
                        // Character comparisons - NEW FEATURE
                        AnimeComparisonView(user: viewModel.currentUser)
                        
                        // Warrior details
                        if isEditingProfile {
                            EditProfileView(
                                tempName: $tempName,
                                tempHeight: $tempHeight,
                                tempWeight: $tempWeight,
                                tempGoal: $tempGoal
                            )
                        } else {
                            ProfileDetailsView(user: viewModel.currentUser)
                        }
                        
                        // Power stats
                        PowerStatsView(user: viewModel.currentUser)
                        
                        // Training history summary
                        TrainingHistoryView(user: viewModel.currentUser)
                    }
                    .padding()
                }
            }
            .navigationTitle("Warrior Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditingProfile ? "Save" : "Edit") {
                        if isEditingProfile {
                            // Save changes
                            viewModel.currentUser.name = tempName
                            viewModel.currentUser.height = Double(tempHeight)
                            viewModel.currentUser.weight = Double(tempWeight)
                            viewModel.currentUser.fitnessGoal = tempGoal
                            isEditingProfile = false
                        } else {
                            // Start editing
                            tempName = viewModel.currentUser.name
                            tempHeight = viewModel.currentUser.height != nil ? "\(viewModel.currentUser.height!)" : ""
                            tempWeight = viewModel.currentUser.weight != nil ? "\(viewModel.currentUser.weight!)" : ""
                            tempGoal = viewModel.currentUser.fitnessGoal
                            isEditingProfile = true
                        }
                    }
                    .foregroundColor(AppTheme.accent)
                }
            }
        }
        .accentColor(AppTheme.accent)
    }
}

// Profile Header View with avatar
struct ProfileHeaderView: View {
    var user: User
    
    var body: some View {
        VStack(spacing: 15) {
            // Transformation avatar
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                getTransformationColor(for: user.currentTransformation),
                                getTransformationColor(for: user.currentTransformation).opacity(0.5)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 70
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: getTransformationColor(for: user.currentTransformation).opacity(0.6), radius: 10)
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
            }
            
            // Name and transformation
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.text)
            
            Text(user.currentTransformation)
                .font(.headline)
                .foregroundColor(getTransformationColor(for: user.currentTransformation))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(getTransformationColor(for: user.currentTransformation).opacity(0.2))
                .cornerRadius(20)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
    
    // Get color based on transformation
    func getTransformationColor(for transformation: String) -> Color {
        switch transformation {
        case "Base Form": return AppTheme.baseForm
        case "Super Saiyan": return AppTheme.superSaiyan
        case "Super Saiyan 2": return AppTheme.superSaiyan2
        case "Super Saiyan 3": return AppTheme.superSaiyan3
        case "Super Saiyan God": return AppTheme.superSaiyanGod
        default: return AppTheme.baseForm
        }
    }
}

// Warrior details in view mode
struct ProfileDetailsView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Warrior Details")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            
            HStack {
                ProfileDetailItem(
                    label: "Height",
                    value: user.height != nil ? "\(Int(user.height!)) cm" : "Not set",
                    icon: "ruler"
                )
                
                ProfileDetailItem(
                    label: "Weight",
                    value: user.weight != nil ? "\(Int(user.weight!)) kg" : "Not set",
                    icon: "scalemass"
                )
            }
            
            ProfileDetailItem(
                label: "Fitness Goal",
                value: user.fitnessGoal.rawValue,
                icon: "target"
            )
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Profile detail item
struct ProfileDetailItem: View {
    var label: String
    var value: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
                
                Text(value)
                    .foregroundColor(AppTheme.text)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

// Edit profile form
struct EditProfileView: View {
    @Binding var tempName: String
    @Binding var tempHeight: String
    @Binding var tempWeight: String
    @Binding var tempGoal: FitnessGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Edit Warrior Details")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 30)
                
                TextField("Name", text: $tempName)
                    .foregroundColor(AppTheme.text)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(AppTheme.secondaryBackground)
            .cornerRadius(10)
            
            HStack {
                Image(systemName: "ruler")
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 30)
                
                TextField("Height (cm)", text: $tempHeight)
                    .foregroundColor(AppTheme.text)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(AppTheme.secondaryBackground)
            .cornerRadius(10)
            
            HStack {
                Image(systemName: "scalemass")
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 30)
                
                TextField("Weight (kg)", text: $tempWeight)
                    .foregroundColor(AppTheme.text)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(AppTheme.secondaryBackground)
            .cornerRadius(10)
            
            HStack {
                Image(systemName: "target")
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 30)
                
                Picker("Fitness Goal", selection: $tempGoal) {
                    ForEach(FitnessGoal.allCases) { goal in
                        Text(goal.rawValue).tag(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(AppTheme.text)
                .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(AppTheme.secondaryBackground)
            .cornerRadius(10)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Power stats view
struct PowerStatsView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Power Stats")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            
            HStack {
                VStack(alignment: .center, spacing: 5) {
                    Text("Power Level")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Text("\(user.powerLevel)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.primary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .background(AppTheme.secondaryText)
                    .frame(height: 40)
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Next Level")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    if let next = user.nextTransformationThreshold {
                        Text("\(next)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.accent)
                    } else {
                        Text("MAX")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.accent)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(AppTheme.secondaryBackground)
            .cornerRadius(10)
            
            // Power level progress bar
            if let nextThreshold = user.nextTransformationThreshold {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress to Next Transformation")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                        
                        Spacer()
                        
                        Text("\(user.powerLevel) / \(nextThreshold)")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width, height: 8)
                                .opacity(0.2)
                                .foregroundColor(AppTheme.secondaryText)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .frame(width: min(CGFloat(user.powerLevel) / CGFloat(nextThreshold) * geometry.size.width, geometry.size.width), height: 8)
                                .foregroundColor(getTransformationColor(for: user.currentTransformation))
                                .cornerRadius(4)
                                .animation(.easeInOut, value: user.powerLevel)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
    
    // Get color based on transformation
    func getTransformationColor(for transformation: String) -> Color {
        switch transformation {
        case "Base Form": return AppTheme.baseForm
        case "Super Saiyan": return AppTheme.superSaiyan
        case "Super Saiyan 2": return AppTheme.superSaiyan2
        case "Super Saiyan 3": return AppTheme.superSaiyan3
        case "Super Saiyan God": return AppTheme.superSaiyanGod
        default: return AppTheme.baseForm
        }
    }
}

// Training history summary
struct TrainingHistoryView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Training History")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            
            HStack(spacing: 20) {
                StatBox(
                    value: "\(user.workoutsCompleted)",
                    label: "Workouts",
                    icon: "figure.strengthtraining.traditional"
                )
                
                StatBox(
                    value: "\(user.streakDays)",
                    label: "Day Streak",
                    icon: "flame.fill"
                )
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Stat box for training history
struct StatBox: View {
    var value: String
    var label: String
    var icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.primary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.text)
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.secondaryBackground)
        .cornerRadius(10)
    }
}
