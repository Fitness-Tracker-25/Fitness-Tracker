//
//  MainViews.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import SwiftUI

// Main Tab View
struct MainTabView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    init() {
        // Customize the tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: "121212"))
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray.opacity(0.7))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: userViewModel)
                .tabItem {
                    Label("Power Level", systemImage: "bolt.fill")
                }
                .tag(0)
            
            WorkoutListView(viewModel: userViewModel)
                .tabItem {
                    Label("Training", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(1)
            
            DietView(viewModel: userViewModel)
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(2)
            
            ProfileView(viewModel: userViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(AppTheme.primary)
        .preferredColorScheme(.dark) // Force dark mode
    }
}

// Home View showing power level and character
struct HomeView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Character view with improved styling
                CharacterView(transformation: viewModel.currentUser.currentTransformation)
                
                // Power level with custom styling
                PowerLevelView(
                    powerLevel: viewModel.currentUser.powerLevel,
                    nextThreshold: viewModel.currentUser.nextTransformationThreshold
                )
                
                // Workout stats with improved visuals
                WorkoutStatsView(
                    workoutsCompleted: viewModel.currentUser.workoutsCompleted,
                    streakDays: viewModel.currentUser.streakDays
                )
                
                // Recent workouts with card styling
                RecentWorkoutsView(workouts: viewModel.workoutLogs.prefix(3).map { $0 })
            }
            .padding()
        }
        .background(Color(hex: "0A0A0A").edgesIgnoringSafeArea(.all))
        .navigationTitle("Saiyan Training")
    }
}

// Enhanced character visualization
struct CharacterView: View {
    var transformation: String
    
    var body: some View {
        VStack(spacing: 15) {
            // Character avatar with transformation-based styling
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                transformationColor.opacity(0.7),
                                transformationColor.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 180, height: 180)
                    .blur(radius: 15)
                
                // Background circle
                Circle()
                    .fill(transformationColor.opacity(0.3))
                    .frame(width: 160, height: 160)
                
                // Character icon
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(.white)
                    .shadow(color: transformationColor, radius: 5)
            }
            
            // Transformation label with dynamic color
            Text(transformation)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(transformationColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(transformationColor.opacity(0.2))
                .cornerRadius(20)
        }
        .padding(.vertical)
        .cardStyle()
    }
    
    var transformationColor: Color {
        switch transformation {
        case "Base Form":
            return AppTheme.baseForm
        case "Super Saiyan":
            return AppTheme.superSaiyan
        case "Super Saiyan 2":
            return AppTheme.superSaiyan2
        case "Super Saiyan 3":
            return AppTheme.superSaiyan3
        case "Super Saiyan God":
            return AppTheme.superSaiyanGod
        default:
            return AppTheme.baseForm
        }
    }
}

// Enhanced Power Level View
struct PowerLevelView: View {
    var powerLevel: Int
    var nextThreshold: Int?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("POWER LEVEL")
                .font(.headline)
                .foregroundColor(AppTheme.secondaryText)
            
            Text("\(powerLevel)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppTheme.primary)
                .shadow(color: AppTheme.primary.opacity(0.5), radius: 2)
            
            if let next = nextThreshold {
                // Custom progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        Rectangle()
                            .frame(width: geometry.size.width, height: 10)
                            .opacity(0.2)
                            .foregroundColor(AppTheme.secondaryText)
                            .cornerRadius(5)
                        
                        // Progress
                        Rectangle()
                            .frame(width: min(CGFloat(powerLevel) / CGFloat(next) * geometry.size.width, geometry.size.width), height: 10)
                            .foregroundColor(AppTheme.primary)
                            .cornerRadius(5)
                            .animation(.easeInOut, value: powerLevel)
                    }
                }
                .frame(height: 10)
                
                Text("\(next - powerLevel) more to next transformation")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            } else {
                Text("Maximum transformation achieved!")
                    .font(.caption)
                    .foregroundColor(AppTheme.superSaiyanGod)
                    .padding(.top, 5)
            }
        }
        .padding()
        .cardStyle()
    }
}

// Enhanced workout stats view
struct WorkoutStatsView: View {
    var workoutsCompleted: Int
    var streakDays: Int
    
    var body: some View {
        HStack(spacing: 20) {
            StatItemView(
                value: "\(workoutsCompleted)",
                label: "Workouts",
                icon: "figure.strengthtraining.traditional",
                color: AppTheme.secondary
            )
            
            StatItemView(
                value: "\(streakDays)",
                label: "Day Streak",
                icon: "flame.fill",
                color: AppTheme.primary
            )
        }
    }
}

// Enhanced stat item view
struct StatItemView: View {
    var value: String
    var label: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
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
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Recent Workouts View with improved styling
struct RecentWorkoutsView: View {
    var workouts: [WorkoutLog]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Training")
                .font(.headline)
                .foregroundColor(AppTheme.text)
            
            if workouts.isEmpty {
                Text("No workouts completed yet. Start training to increase your power level!")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(AppTheme.secondaryBackground)
                    .cornerRadius(10)
            } else {
                ForEach(workouts) { workout in
                    WorkoutLogItemView(workout: workout)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Enhanced Workout Log Item View
struct WorkoutLogItemView: View {
    var workout: WorkoutLog
    
    var body: some View {
        HStack {
            // Workout info with icon
            HStack(spacing: 15) {
                Image(systemName: "bolt.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.primary)
                
                VStack(alignment: .leading) {
                    Text(workout.workoutName)
                        .font(.headline)
                        .foregroundColor(AppTheme.text)
                    
                    Text(formattedDate(workout.date))
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            
            Spacer()
            
            // Results
            VStack(alignment: .trailing) {
                Text("+\(workout.powerLevelGained)")
                    .font(.headline)
                    .foregroundColor(AppTheme.powerGain)
                
                Text("\(workout.duration) min")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
        }
        .padding()
        .background(AppTheme.secondaryBackground)
        .cornerRadius(10)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
