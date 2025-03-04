## 0.0.1

* Has basic implementation and documentation.

## 0.0.2

* Has screenshots added to documentation.

## 1.0.0

### Major Update 🚀

This release introduces significant improvements, new features, and better customization options. 

### ✨ New Features:
- **Enhanced Customization**  
  - Added support for **customizable line colors** between steps.  
  - Introduced **step labels** with static and dynamic color options.  
  - Added **icon and text color customization** for active, completed, and incomplete steps.  

- **Improved Step Indicator**  
  - Steps now support **text and icons** inside step indicators.  
  - Custom step indicator styling with dynamic colors based on step state.  

- **Scrollable Stepper**  
  - The stepper now supports **horizontal scrolling** when the number of steps exceeds visible limits.  
  - Introduced `visibleSteps` property to control how many steps are shown at once.  

- **Navigation Improvements**  
  - Improved **linear navigation restriction**, ensuring steps can only be completed in order when enabled.  
  - Clicking a step now **notifies the parent widget** properly via `onStepTapped`.  

### 🛠️ Refactoring & Enhancements:
- **Renamed `CustomStepper` to `SadjaProgressStepper`** for better clarity and consistency.  
- Improved **state management** for better responsiveness.  
- Optimized layout calculations for **better UI performance** and rendering.  
- Enhanced **documentation** for better developer experience.  

### ⚠️ Breaking Changes:
- **Renamed Class**  
  - `CustomStepper` → `SadjaProgressStepper`.  
- **Constructor Changes**  
  - Added required parameters for **text, labels, and line colors**.  
- **Modified `_buildStepIndicator` & `_goToStep`**  
  - Now supports both icons and text inside step indicators.  

This update significantly improves the usability and flexibility of the stepper. 🚀  
