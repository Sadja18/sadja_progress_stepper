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

## 1.0.1

### Updated Docs.

## 1.0.2

### Issues with previous publication

## 1.0.3

### Enhancements

#### Improved Scrolling Behavior

* The stepper now automatically scrolls to ensure the `current step remains visible`.

* If the selected step exceeds the number of visible steps, the `first step scrolls out of view` to maintain focus on the latest step.

* `Smooth animation (30ms, ease-in-out)` added for a better user experience.

#### Dynamic Line Width Calculation

* The width of lines between steps is now dynamically computed based on `available space`.

* This prevents layout issues when steps don't fit perfectly within the stepper's width.

#### Fixes & Improvements

* `Fixed Color Priority` for `Steps`, `Icons`, and `Lines`

  * `Completed steps now always take priority over` active steps.

  * If a step is marked as completed, it will retain its `completed color`, even if it is the current step.

  * Applied this behavior to:
    * Step circle color (`_getStepColor`)
    * Icon color (`_getIconColor`)
    * Text color (`_getTextColor`)
    *  Connector line color (`_getLineColor`)

## 1.0.4

## API Docs