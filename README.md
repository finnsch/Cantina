# Cantina

A Star Wars themed iOS app that displays character information from the SWAPI (Star Wars API).

## Features

### Core Functionality

- **People List**: Browse all Star Wars characters with infinite scroll pagination
- **Character Details**: View detailed information including physical attributes, birth year, and affiliations
- **Search**: Filter characters by name with real-time local search
- **Character Images**: Displays character portraits from community image repository
- **Cantina Music**: Plays the iconic cantina band theme when you've scrolled through all characters 🎵

## Requirements

- iOS 18.6+
- Xcode 26.0+
- Swift 6.2+

## Getting Started

1. Clone the repository
2. Open `App/Cantina.xcodeproj` in Xcode
3. Build and run on simulator or device

## API

The app connects to [SWAPI](https://swapi.dev/) (Star Wars API) to fetch character data. Character images are sourced from the [swapi-images](https://github.com/breatheco-de/swapi-images) community repository.
