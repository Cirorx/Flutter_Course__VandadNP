# Flutter Firebase Notes App
This Flutter project is based on the YouTube course by @VandadNP and serves as a simple yet scalable notes app with user authentication and verification using Firebase. The project emphasizes the design and structure of the packages rather than the UI.

## Features
- User Authentication: The app allows users to register, log in, and reset their passwords. Firebase authentication is used to securely manage user credentials.
- Email Verification: Upon registration, users receive a verification email to confirm their email address. This ensures that only valid users can access the app.
- Notes Management: Authenticated users can create, read, update, and delete their notes. The app uses Firebase Cloud Firestore to store and retrieve the notes data.
- Scalable Design: The project follows a structured design to ensure scalability and maintainability. It includes various packages that handle different aspects of the app, such as authentication, cloud storage, CRUD operations, and UI components.

## Project Structure
The project is organized into several packages and files, each serving a specific purpose. 

Here are the key components of the project:

- lib/constants: Contains files that define constants used throughout the app, including database structure and routes.
- lib/enums: Defines an enum for menu actions used in the app.
- lib/extensions: Provides extension methods for lists, including a filter method.
- lib/helpers: Contains helper classes for loading screens, including the loading screen itself and its controller.
- lib/services/auth: Handles user authentication and includes authentication exceptions, authentication providers, authentication service, and the authenticated user model. It also includes a bloc for managing authentication events and states.
- lib/services/cloud: Manages cloud-related operations, such as storing notes, handling cloud storage exceptions, and interacting with Firebase Cloud Storage.
- lib/services/crud: Handles CRUD (Create, Read, Update, Delete) operations for notes. It includes an exception class and a service for managing notes.
- lib/utilities/dialogs: Provides reusable dialogs for various purposes, including error messages, loading indicators, password resets, and more.
- lib/utilities/generics: Contains generic utility classes, including a class for retrieving arguments from navigation routes.
- lib/views: Contains the app's different views, including the login, registration, password reset, verify email, and notes views. It also includes animations and UI components used in the app.
- test: Contains unit tests for the authentication functionality.

![packages diagram](https://github.com/Cirorx/Flutter_Course__VandadNP/blob/3249b6f76785f39ea9eff38f7ecfb9345de7c7c8/learning_dart/diagram/packages_diagram.png?raw=true)


This Flutter Notes App provides a foundation for building scalable and secure note-taking applications. It demonstrates best practices for implementing user authentication and verification using Firebase services. Feel free to explore the codebase😄 
