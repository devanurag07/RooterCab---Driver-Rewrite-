# Profile Feature - Clean Architecture Implementation

This document outlines the complete Profile feature implementation following Clean Architecture principles, converted from your original ProfileCubit to a full BLoC architecture.

## 🏗️ Architecture Overview

The Profile feature is organized into three main layers:

### 📁 Domain Layer (`domain/`)
**Pure business logic - no dependencies on external frameworks**

- **Entities** (`entities/`)
  - `user_profile.dart` - Core user profile entity
  - `profile_update_request.dart` - Profile update request entity

- **Repository Interface** (`repository/`)
  - `profile_repository.dart` - Abstract repository contract

- **Use Cases** (`usecases/`)
  - `get_user_profile.dart` - Fetch user profile use case
  - `update_user_profile.dart` - Update user profile use case

### 📁 Data Layer (`data/`)
**Data sources and repository implementation**

- **Models** (`models/`)
  - `user_profile_model.dart` - Data model with JSON serialization

- **Data Sources** (`datasources/`)
  - `profile_remote_datasource.dart` - API and SharedPreferences data source

- **Repository Implementation** (`repository/`)
  - `profile_repository_impl.dart` - Repository implementation

### 📁 Presentation Layer (`presentation/`)
**UI and state management**

- **BLoC** (`bloc/`)
  - `profile_bloc.dart` - Main BLoC with business logic
  - `profile_events.dart` - All profile events
  - `profile_state.dart` - All profile states

- **Screens** (`screens/`)
  - `profile_example_usage.dart` - Example implementation

## 🔄 Migration from Cubit to BLoC

### Original Cubit Structure
```dart
class ProfileCubit extends Cubit<ProfileState> {
  // Controllers and methods directly in cubit
  final TextEditingController fullNameController = TextEditingController();
  
  Future<void> fetchUserData() async { /* ... */ }
  Future<void> updateUser({...}) async { /* ... */ }
}
```

### New BLoC Structure
```dart
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // Dependency injection of use cases
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  
  // Events trigger use cases
  on<FetchUserProfile>(_onFetchUserProfile);
  on<UpdateUserProfileEvent>(_onUpdateUserProfile);
}
```

## 📋 Available Events

```dart
// Fetch user profile
context.read<ProfileBloc>().add(const FetchUserProfile());

// Update user profile
context.read<ProfileBloc>().add(UpdateUserProfileEvent(request));

// Update form field
context.read<ProfileBloc>().add(UpdateFormField('fullName', 'New Name'));
```

## 📊 Available States

```dart
ProfileInitial()           // Initial state
ProfileLoading()           // Loading profile data
ProfileLoaded(profile)     // Profile loaded successfully
ProfileUpdating()          // Updating profile
ProfileUpdated(profile)    // Profile updated successfully
ProfileError(message)      // Error occurred
```

## 🛠️ Setup and Usage

### 1. Dependency Injection Setup

```dart
// Using the provided ProfileInjection helper
final profileInjection = ProfileInjection(apiClient: sl<ApiClient>());

// Register in your service locator
sl.registerLazySingleton<ProfileRepository>(
  () => profileInjection.repository,
);
sl.registerLazySingleton<GetUserProfile>(
  () => profileInjection.getUserProfile,
);
```

### 2. Widget Integration

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        getUserProfile: sl<GetUserProfile>(),
        updateUserProfile: sl<UpdateUserProfile>(),
      )..add(const FetchUserProfile()), // Auto-fetch on creation
      child: ProfileView(),
    );
  }
}
```

### 3. State Management

```dart
BlocConsumer<ProfileBloc, ProfileState>(
  listener: (context, state) {
    if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is ProfileUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  },
  builder: (context, state) {
    if (state is ProfileLoading) {
      return CircularProgressIndicator();
    } else if (state is ProfileLoaded) {
      return ProfileForm(profile: state.userProfile);
    }
    return SizedBox.shrink();
  },
)
```

## 🔧 Configuration

### Update Base URL
In `profile_remote_datasource.dart`, replace:
```dart
const baseUrl = 'YOUR_BASE_URL'; // Replace with your actual base URL
```

### Token Management
The data source uses your existing token management:
```dart
Future<String> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token') ?? '';
}
```

## ✨ Key Benefits

1. **Separation of Concerns**: Clear boundaries between layers
2. **Testability**: Each layer can be tested independently
3. **Maintainability**: Easy to modify without affecting other layers
4. **Scalability**: Easy to add new features following the same pattern
5. **Dependency Inversion**: High-level modules don't depend on low-level modules

## 🔄 Form Controllers

The BLoC maintains form controllers just like your original cubit:

```dart
final bloc = context.read<ProfileBloc>();

// Access controllers
bloc.fullNameController.text = 'New Name';
bloc.phoneController.text = 'New Phone';
bloc.emailController.text = 'new@email.com';

// Get current profile
final currentProfile = bloc.currentUserProfile;
```

## 📱 Image Handling

Profile image updates are handled through the `ProfileUpdateRequest`:

```dart
final request = ProfileUpdateRequest(
  userId: currentProfile.userId,
  fullName: fullNameController.text,
  phone: phoneController.text,
  email: emailController.text,
  gender: selectedGender,
  profileImage: selectedImageFile, // File? - optional
);

bloc.add(UpdateUserProfileEvent(request));
```

## 🚀 Next Steps

1. Replace your existing ProfileCubit usage with ProfileBloc
2. Update your dependency injection container
3. Migrate existing screens to use the new BLoC
4. Add any additional use cases as needed
5. Implement proper error handling for your specific use cases

The architecture is now ready for production use and follows Flutter/Dart best practices! 🎉
