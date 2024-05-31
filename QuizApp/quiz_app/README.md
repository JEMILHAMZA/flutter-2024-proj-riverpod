# quiz_app

A new Flutter project.

This project uses Riverpod for state management to provide a scalable and maintainable architecture.

## Getting Started

This project is a starting point for a Flutter application.

## Features

- **User Authentication**:
  - Sign up, login, logout.
  - Change username or password.
  - Delete account.

- **User Authorization**:
  - All users can sign up, login, logout, change username or password, delete account, read, and answer questions.
  - Instructors can create, update, and delete questions.
  - All users can create, view, update, and delete personal notes.

- **Question Interaction**:
  - Read and answer questions.
  - Receive instant feedback on answers.

- **Personal Note Management**:
  - Create, read, update, and delete personal notes.

## State Management with Riverpod

The application utilizes Riverpod for state management, ensuring a reactive and modular approach. Riverpod provides a more robust and scalable state management solution compared to other state management options in Flutter.

### Benefits of Using Riverpod

- **Provider Scope**: Easily manage the scope of providers, allowing for more precise state management.
- **Type Safety**: Ensures type safety with compile-time checks, reducing runtime errors.
- **Modular**: Promotes modular code architecture, making it easier to manage and test individual components.

### Structure

- **Providers**: Define the state and business logic of the application.
- **Consumers**: Widgets that listen to and react to changes in the state.
