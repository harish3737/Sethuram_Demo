# Holdings Assignment iOS App

![Swift Version](https://img.shields.io/badge/Swift-5.9-orange)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey)
![Xcode Version](https://img.shields.io/badge/Xcode-26-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview
An iOS application to manage and view portfolio holdings built using UIKit programmatically with modern Swift concurrency and clean MVVM architecture.

## Features

- Display portfolio holdings with real-time updates
- Custom reusable alert overlays for robust error handling
- Network reachability detection for offline support
- Clean MVVM architecture with async/await and dependency injection
- "No Content Available" state with retry functionality
- Sequential alert management queue to avoid alert overlap

## Architecture

- **Model:** Portfolio data models and summary calculations
- **ViewModel:** Holds UI-related logic and async data fetching
- **View (UIKit):** Programmatic views and custom reusable components

## Setup & Installation

1. Clone the repository:
2. Open `Holdings_Assignment.xcodeproj` in Xcode 15 or later.
3. Build and run on your simulator or device.

## Usage

- Auto-detects network reachability.
- Shows alert overlays on network/data errors.
- Provides retry button on empty or error states.

## Contributing

Contributions welcome! Please fork the repo and submit PRs.

---

## Contact

For questions or feedback, contact: Sethuram Vijayakumar
