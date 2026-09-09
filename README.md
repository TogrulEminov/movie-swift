# Movie App

A SwiftUI movie application powered by the TMDB API.

## Features

- Popular, top-rated, upcoming and now-playing movies
- Movie details, cast, director and similar movies
- Movie search with 400 ms debounce
- Pagination
- Local favorites
- Light and Dark Mode
- Reusable SwiftUI components
- Loading, empty and error states
- FileManager persistence
- Dependency injection
- Mock network service
- Offline previews

## API Configuration

This application uses the TMDB API.

Create the following file:

```text
MovieApp/Config/APIConfig.swift
```

Add the following configuration:

```swift
enum APIConfig {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p"
    static let accessToken = "YOUR_TMDB_ACCESS_TOKEN"
}
```

Replace `YOUR_TMDB_ACCESS_TOKEN` with your TMDB API Read Access Token.

The `APIConfig.swift` file contains sensitive information and must not be committed to the repository.

## Getting a TMDB Access Token

1. Create an account at [The Movie Database](https://www.themoviedb.org).
2. Open **Settings → API**.
3. Request an API key using the **Developer** option.
4. Copy the **API Read Access Token**.
5. Add the token to `Config/APIConfig.swift`.

Do not use the short API Key as the Bearer token.

## Technologies

- Swift
- SwiftUI
- Observation
- async/await
- URLSession
- FileManager
- SDWebImageSwiftUI
- TMDB API

## Architecture

The project uses:

- Endpoint-based networking
- Generic `NetworkService`
- Dependency injection
- Observable ViewModels
- Reusable UI components
- State-based screen rendering
- Centralized navigation routes

## Running the Project

1. Clone the repository.
2. Open the project in Xcode.
3. Create `MovieApp/Config/APIConfig.swift`.
4. Add your TMDB API Read Access Token.
5. Select an iOS Simulator or physical device.
6. Build and run the application.

## Security

The following file is excluded through `.gitignore`:

```text
MovieApp/Config/APIConfig.swift
```

Never commit your TMDB access token to the repository.
