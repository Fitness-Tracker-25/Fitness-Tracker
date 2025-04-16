//
//  WorkoutViews.swift
//  SaiyanTrainingApp
//
//  Created by Steven Luque on 4/13/25.
//

import SwiftUI

// Workout List View
struct WorkoutListView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recommended Workouts").foregroundColor(AppTheme.text)) {
                    ForEach(viewModel.getRecommendedWorkouts()) { workout in
                        NavigationLink(destination: WorkoutDetailView(viewModel: viewModel, workout: workout)) {
                            WorkoutRowView(workout: workout)
                        }
                    }
                }
                
                Section(header: Text("All Workouts").foregroundColor(AppTheme.text)) {
                    ForEach(sampleWorkouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(viewModel: viewModel, workout: workout)) {
                            WorkoutRowView(workout: workout)
                        }
                    }
                }
            }
            .background(Color(hex: "0A0A0A").edgesIgnoringSafeArea(.all))
            .navigationTitle("Training Menu")
        }
    }
}

// Workout Row View
struct WorkoutRowView: View {
    var workout: Workout
    
    var body: some View {
        HStack(spacing: 15) {
            // Workout icon based on type
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: typeIcon)
                    .font(.system(size: 20))
                    .foregroundColor(typeColor)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.text)
                
                Text("\(workout.type.rawValue) • \(workout.difficulty.rawValue)")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text("+\(workout.powerLevelReward)")
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.powerGain)
                
                Text("\(workout.duration) min")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
        }
        .padding(.vertical, 5)
    }
    
    // Get icon based on workout type
    var typeIcon: String {
        switch workout.type {
        case .strength: return "dumbbell.fill"
        case .cardio: return "heart.fill"
        case .flexibility: return "figure.mixed.cardio"
        case .mixed: return "figure.highintensity.intervaltraining"
        }
    }
    
    // Get color based on workout type
    var typeColor: Color {
        switch workout.type {
        case .strength: return AppTheme.primary
        case .cardio: return AppTheme.powerGain
        case .flexibility: return AppTheme.secondary
        case .mixed: return AppTheme.accent
        }
    }
}

// Workout Detail View
struct WorkoutDetailView: View {
    @ObservedObject var viewModel: UserViewModel
    var workout: Workout
    @State private var isShowingWorkoutSession = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with improved styling
                VStack(alignment: .leading, spacing: 10) {
                    // Type badge
                    Text(workout.type.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(typeColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(typeColor.opacity(0.2))
                        .cornerRadius(20)
                    
                    // Title
                    Text(workout.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.text)
                    
                    // Details
                    HStack(spacing: 15) {
                        Label("\(workout.duration) min", systemImage: "clock")
                            .foregroundColor(AppTheme.secondaryText)
                        
                        Label(workout.difficulty.rawValue, systemImage: "chart.bar.fill")
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .font(.subheadline)
                    
                    // Power level reward badge
                    HStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(AppTheme.accent)
                            
                            Text("+\(workout.powerLevelReward)")
                                .foregroundColor(AppTheme.accent)
                                .fontWeight(.bold)
                                
                            Text("Power")
                                .foregroundColor(AppTheme.accent)
                        }
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppTheme.accent.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cardCornerRadius)
                
                // Exercises section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Exercises")
                        .font(.headline)
                        .foregroundColor(AppTheme.text)
                    
                    ForEach(workout.exercises) { exercise in
                        ExerciseRowView(exercise: exercise)
                    }
                }
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cardCornerRadius)
                
                // Gravity level recommendation based on difficulty
                difficultyRecommendation
                
                // Start button with custom styling
                Button(action: {
                    isShowingWorkoutSession = true
                }) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "figure.highintensity.intervaltraining")
                            .font(.headline)
                        
                        Text("START TRAINING")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [typeColor, typeColor.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: typeColor.opacity(0.4), radius: 5, x: 0, y: 2)
                }
                .padding(.top)
            }
            .padding()
        }
        .background(Color(hex: "0A0A0A").edgesIgnoringSafeArea(.all))
        .navigationTitle("Workout Details")
        .sheet(isPresented: $isShowingWorkoutSession) {
            WorkoutSessionView(viewModel: viewModel, workout: workout)
        }
    }
    
    // Recommendation based on difficulty
    var difficultyRecommendation: some View {
        HStack(spacing: 15) {
            Image(systemName: difficultyIcon)
                .font(.largeTitle)
                .foregroundColor(typeColor)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(difficultyTitle)
                    .font(.headline)
                    .foregroundColor(AppTheme.text)
                
                Text(difficultyDescription)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
    
    // Get icon based on workout type
    var typeIcon: String {
        switch workout.type {
        case .strength: return "dumbbell.fill"
        case .cardio: return "heart.fill"
        case .flexibility: return "figure.mixed.cardio"
        case .mixed: return "figure.highintensity.intervaltraining"
        }
    }
    
    // Get color based on workout type
    var typeColor: Color {
        switch workout.type {
        case .strength: return AppTheme.primary
        case .cardio: return AppTheme.powerGain
        case .flexibility: return AppTheme.secondary
        case .mixed: return AppTheme.accent
        }
    }
    
    // Difficulty icon
    var difficultyIcon: String {
        switch workout.difficulty {
        case .beginner: return "figure.walk"
        case .intermediate: return "figure.run"
        case .advanced: return "figure.sprint"
        case .extreme: return "tornado"
        }
    }
    
    // Difficulty title
    var difficultyTitle: String {
        switch workout.difficulty {
        case .beginner: return "Kaioken x1 (Earth gravity)"
        case .intermediate: return "Kaioken x10 (10x gravity)"
        case .advanced: return "Kaioken x20 (20x gravity)"
        case .extreme: return "Hyperbolic Time Chamber (100x gravity)"
        }
    }
    
    // Difficulty description
    var difficultyDescription: String {
        switch workout.difficulty {
        case .beginner: return "Suitable for new warriors. Focus on form and technique."
        case .intermediate: return "For trained fighters. Increase intensity and challenge yourself."
        case .advanced: return "For elite warriors. Push your limits to break through plateaus."
        case .extreme: return "Only for the mightiest Saiyans. Train like Vegeta in the gravity chamber."
        }
    }
}

// Exercise Row View
struct ExerciseRowView: View {
    var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Target muscle group icon
                targetMuscleIcon
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundColor(AppTheme.text)
                    
                    Text(exercise.targetMuscleGroups.map { $0.rawValue }.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
                
                Spacer()
                
                // Sets and reps
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(exercise.sets) sets")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.text)
                    
                    Text("\(exercise.reps) reps")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            
            // Additional exercise details
            HStack(spacing: 20) {
                // Weight if applicable
                if let weight = exercise.weight {
                    HStack(spacing: 5) {
                        Image(systemName: "scalemass.fill")
                            .foregroundColor(AppTheme.secondary)
                        
                        Text("\(Int(weight))kg")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                }
                
                // Rest time
                HStack(spacing: 5) {
                    Image(systemName: "timer")
                        .foregroundColor(AppTheme.accent)
                    
                    Text("Rest: \(exercise.restTime)s")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
        }
        .padding()
        .background(AppTheme.secondaryBackground)
        .cornerRadius(10)
    }
    
    // Icon view based on target muscle group
    var targetMuscleIcon: some View {
        let primaryMuscle = exercise.targetMuscleGroups.first ?? .fullBody
        let iconName: String
        let color: Color
        
        switch primaryMuscle {
        case .chest:
            iconName = "figure.arms.open"
            color = AppTheme.primary
        case .back:
            iconName = "figure.walk"
            color = AppTheme.secondary
        case .legs:
            iconName = "figure.walk"
            color = AppTheme.powerGain
        case .shoulders:
            iconName = "figure.arms.open"
            color = AppTheme.warning
        case .arms:
            iconName = "figure.boxing"
            color = AppTheme.accent
        case .core:
            iconName = "figure.core.training"
            color = AppTheme.primary
        case .fullBody:
            iconName = "figure.highintensity.intervaltraining"
            color = AppTheme.secondary
        }
        
        return Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(color)
            .frame(width: 35, height: 35)
            .background(color.opacity(0.2))
            .clipShape(Circle())
    }
}

// Workout Session View
struct WorkoutSessionView: View {
    @ObservedObject var viewModel: UserViewModel
    var workout: Workout
    @State private var currentExerciseIndex = 0
    @State private var completedExercises: [Exercise] = []
    @State private var isWorkoutComplete = false
    @State private var elapsedTime = 0
    @State private var isResting = false
    @State private var remainingRestTime = 0
    @State private var progress: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if isWorkoutComplete {
                WorkoutCompleteView(
                    viewModel: viewModel,
                    workout: workout,
                    duration: elapsedTime,
                    dismiss: { presentationMode.wrappedValue.dismiss() }
                )
            } else {
                // Current exercise
                if currentExerciseIndex < workout.exercises.count {
                    let exercise = workout.exercises[currentExerciseIndex]
                    
                    // Exercise counter with progress
                    HStack {
                        Text("Exercise \(currentExerciseIndex + 1) of \(workout.exercises.count)")
                            .font(.headline)
                            .foregroundColor(AppTheme.secondaryText)
                        
                        Spacer()
                        
                        Text(formattedTime(elapsedTime * 60)) // Convert to seconds for display
                            .font(.headline)
                            .foregroundColor(AppTheme.primary)
                            .monospacedDigit()
                    }
                    .padding()
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width, height: 6)
                                .opacity(0.2)
                                .foregroundColor(AppTheme.secondaryText)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .frame(width: geometry.size.width * CGFloat(currentExerciseIndex) / CGFloat(workout.exercises.count), height: 6)
                                .foregroundColor(AppTheme.primary)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    if isResting {
                        // Rest timer view
                        VStack(spacing: 20) {
                            Text("REST")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(AppTheme.secondary)
                            
                            // Timer circle
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .opacity(0.2)
                                    .foregroundColor(AppTheme.secondaryText)
                                
                                Circle()
                                    .trim(from: 0.0, to: progress)
                                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                    .foregroundColor(AppTheme.secondary)
                                    .rotationEffect(Angle(degrees: -90))
                                    .animation(.linear, value: progress)
                                
                                Text("\(remainingRestTime)")
                                    .font(.system(size: 70, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.text)
                                    .monospacedDigit()
                            }
                            .frame(width: 200, height: 200)
                            
                            Text("Next: \(currentExerciseIndex < workout.exercises.count - 1 ? workout.exercises[currentExerciseIndex + 1].name : "Finish")")
                                .font(.headline)
                                .foregroundColor(AppTheme.text)
                                .padding(.top, 20)
                            
                            // Skip rest button
                            Button("Skip Rest") {
                                isResting = false
                                if currentExerciseIndex < workout.exercises.count - 1 {
                                    currentExerciseIndex += 1
                                } else {
                                    isWorkoutComplete = true
                                }
                            }
                            .foregroundColor(AppTheme.secondary)
                            .padding(.top, 10)
                        }
                        .padding()
                    } else {
                        // Exercise detail
                        ExerciseSessionView(exercise: exercise)
                            .padding()
                        
                        Spacer()
                        
                        // Complete exercise button
                        Button(action: {
                            // Mark exercise as completed
                            completedExercises.append(exercise)
                            
                            // Start rest timer if not last exercise
                            if currentExerciseIndex < workout.exercises.count - 1 {
                                startRestTimer(exercise.restTime)
                            } else {
                                isWorkoutComplete = true
                            }
                        }) {
                            Text("Complete Exercise")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.powerGain)
                                .cornerRadius(10)
                                .shadow(color: AppTheme.powerGain.opacity(0.4), radius: 5, x: 0, y: 2)
                        }
                        .padding()
                    }
                }
            }
        }
        .background(Color(hex: "0A0A0A").edgesIgnoringSafeArea(.all))
        .navigationTitle(workout.name)
        .onAppear {
            // Start timer
            startTimer()
        }
    }
    
    // Start the workout timer
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    // Start the rest timer
    func startRestTimer(_ seconds: Int) {
        isResting = true
        remainingRestTime = seconds
        progress = 1.0
        
        // Update every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingRestTime > 0 {
                remainingRestTime -= 1
                progress = CGFloat(remainingRestTime) / CGFloat(seconds)
            } else {
                timer.invalidate()
                isResting = false
                if currentExerciseIndex < workout.exercises.count - 1 {
                    currentExerciseIndex += 1
                } else {
                    isWorkoutComplete = true
                }
            }
        }
    }
    
    // Format seconds into MM:SS
    func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Exercise Session View
struct ExerciseSessionView: View {
    var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Exercise name
            Text(exercise.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.text)
            
            Divider()
                .background(AppTheme.secondaryText.opacity(0.5))
            
            // Sets, reps, weight display
            HStack(spacing: 25) {
                VStack(alignment: .center, spacing: 8) {
                    Text("Sets")
                        .font(.headline)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Text("\(exercise.sets)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .center, spacing: 8) {
                    Text("Reps")
                        .font(.headline)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Text("\(exercise.reps)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(AppTheme.text)
                }
                .frame(maxWidth: .infinity)
                
                if let weight = exercise.weight {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(AppTheme.secondaryText)
                        
                        Text("\(Int(weight))kg")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(AppTheme.text)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 10)
            
            Divider()
                .background(AppTheme.secondaryText.opacity(0.5))
            
            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                Text("Instructions")
                    .font(.headline)
                    .foregroundColor(AppTheme.secondaryText)
                
                Text(exercise.instructions)
                    .font(.body)
                    .foregroundColor(AppTheme.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Divider()
                .background(AppTheme.secondaryText.opacity(0.5))
            
            // Target muscle groups
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Muscles")
                    .font(.headline)
                    .foregroundColor(AppTheme.secondaryText)
                
                HStack {
                    ForEach(exercise.targetMuscleGroups, id: \.rawValue) { muscle in
                        Text(muscle.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(AppTheme.secondary)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cardCornerRadius)
    }
}

// Workout Complete View
struct WorkoutCompleteView: View {
    @ObservedObject var viewModel: UserViewModel
    var workout: Workout
    var duration: Int
    var dismiss: () -> Void
    @State private var animatePower = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Power-up animation
            ZStack {
                // Outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                AppTheme.accent.opacity(0.7),
                                AppTheme.accent.opacity(0)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: animatePower ? 220 : 180, height: animatePower ? 220 : 180)
                    .blur(radius: 20)
                
                // Inner circle
                Circle()
                    .fill(AppTheme.accent.opacity(0.4))
                    .frame(width: 150, height: 150)
                    .scaleEffect(animatePower ? 1.1 : 1.0)
                
                // Icon
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(AppTheme.accent)
                    .shadow(color: AppTheme.accent.opacity(0.8), radius: 10)
                    .scaleEffect(animatePower ? 1.2 : 1.0)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animatePower = true
                }
            }
            
            Text("POWER LEVEL INCREASED!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.primary)
                .multilineTextAlignment(.center)
            
            Text("+\(workout.powerLevelReward)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.powerGain)
                .shadow(color: AppTheme.powerGain.opacity(0.5), radius: 2)
            
            // Workout summary card
            VStack(alignment: .leading, spacing: 12) {
                Text("Workout Summary")
                    .font(.headline)
                    .foregroundColor(AppTheme.secondaryText)
                
                HStack {
                    SummaryItemView(
                        title: "Workout",
                        value: workout.name,
                        icon: "figure.highintensity.intervaltraining"
                    )
                }
                
                HStack {
                    SummaryItemView(
                        title: "Duration",
                        value: "\(duration) minutes",
                        icon: "clock.fill"
                    )
                    
                    SummaryItemView(
                        title: "Exercises",
                        value: "\(workout.exercises.count)",
                        icon: "dumbbell.fill"
                    )
                }
                
                HStack {
                    // Calculate streak bonus
                    let streakBonus = min((viewModel.currentUser.streakDays + 1) * 10, 200)
                    
                    SummaryItemView(
                        title: "Workout Power",
                        value: "+\(workout.powerLevelReward)",
                        icon: "bolt.fill"
                    )
                    
                    SummaryItemView(
                        title: "Streak Bonus",
                        value: "+\(streakBonus)",
                        icon: "flame.fill"
                    )
                }
            }
            .padding()
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cardCornerRadius)
            
            Spacer()
            
            // Continue button
            Button(action: {
                // Save workout and update user stats
                let exerciseLogs = workout.exercises.map { exercise in
                    ExerciseLog(
                        id: UUID(),
                        exerciseId: exercise.id,
                        exerciseName: exercise.name,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        weight: exercise.weight
                    )
                }
                
                viewModel.completeWorkout(
                    workout: workout,
                    duration: duration,
                    exerciseLogs: exerciseLogs
                )
                
                dismiss()
            }) {
                Text("Continue Training")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.secondary, AppTheme.secondary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: AppTheme.secondary.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// Summary item view for workout completion
struct SummaryItemView: View {
    var title: String
    var value: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.text)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.secondaryBackground)
        .cornerRadius(10)
    }
}
