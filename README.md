# Fitness Tracker
# Ernesto Rodriguez
# Steven Luque
## App Overview

**Description:**  
Fitness Tracker is a minimalist iOS app designed to help users track their daily physical activity. The app features a circular progress ring that updates in real time as users accumulate steps. It also includes a built-in timer, allowing users to start and stop a workout session manually. The app is ideal for users who want to keep track of their fitness goals in a clean and simple interface.

**Evaluation:**  
The app successfully implements core functionality like tracking steps, displaying a visual representation of progress, and managing workout time. It focuses on essential features without requiring account creation or external APIs, making it lightweight and user-friendly.

---

## App Spec

### ✅ Required Features
- [x] Circular ring that shows step progress
- [x] Step counter label that updates
- [x] Start and Reset buttons
- [x] Timer that updates during a session

### 💡 Optional Features
- [ ] Daily step goal setting
- [ ] Workout history log
- [ ] Vibration or sound on session complete
- [ ] Integration with HealthKit
- [ ] Dark Mode support

---

## Screens

1. **Main Screen**
   - Circular progress ring
   - Step counter
   - Timer
   - Start / Reset buttons

---

## Navigation Flows

- Launch → Main Screen
- Tap “Start” → Timer begins, progress ring updates
- Tap “Reset” → Timer resets, step count resets

Note: All navigation occurs on a single view. No tab or multi-screen navigation needed.

---

## Wireframes

_Add sketches or screenshots here if available._

![Main Screen Wireframe](images/main_screen_wireframe.jpg)

---

## ✅ Sprint 1 Progress

### Completed User Stories
- [x] Circular ring that shows step progress
- [x] Step counter label that updates
- [x] Start and Reset buttons
- [x] Timer that updates during a session

---

## 🏗️ Sprint 1 Build Progress

| Feature                | Status    |
|------------------------|-----------|
| Step Counter UI        | ✅ Done   |
| Circular Progress Ring | ✅ Done   |
| Timer Implementation   | ✅ Done   |
| Start/Reset Logic      | ✅ Done   |
| Main Screen Layout     | ✅ Done   |

---

## 🎞️ GIF Demo

_Showcasing the current build:_

![Step Count Demo](images/step_demo.gif)  
![Timer Demo](images/timer_demo.gif)

---

## 📅 Sprint 2 Plan

- [ ] Add daily step goal feature
- [ ] Save and display workout history
- [ ] Animate progress ring on update
- [ ] Add basic settings or dark mode toggle
- [ ] Research and prototype HealthKit integration
