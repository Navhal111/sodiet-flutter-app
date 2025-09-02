import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      log('Attempting to sign up user: $email');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
      );

      if (response.user != null) {
        log('Sign up successful for user: ${response.user!.email}');
      } else {
        log('Sign up failed: User is null');
      }

      return response;
    } catch (e) {
      log('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log('Attempting to sign in user: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        log('Sign in successful for user: ${response.user!.email}');
      } else {
        log('Sign in failed: User is null');
      }

      return response;
    } catch (e) {
      log('Sign in error: $e');
      rethrow;
    }
  }

  // Sign in with OTP (One-Time Password)
  static Future<void> signInWithOTP({
    required String email,
  }) async {
    try {
      log('Attempting to send OTP to: $email');

      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
      );

      log('OTP sent successfully to: $email');
    } catch (e) {
      log('OTP sign in error: $e');
      rethrow;
    }
  }

  // Verify OTP
  static Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      log('Attempting to verify OTP for: $email');

      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      if (response.user != null) {
        log('OTP verification successful for user: ${response.user!.email}');
      } else {
        log('OTP verification failed: User is null');
      }

      return response;
    } catch (e) {
      log('OTP verification error: $e');
      rethrow;
    }
  }

  // Reset password
  static Future<void> resetPassword({
    required String email,
  }) async {
    try {
      log('Attempting to send password reset to: $email');

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: "sodiet://reset-password",
      );

      log('Password reset email sent to: $email');
    } catch (e) {
      log('Password reset error: $e');
      rethrow;
    }
  }

  // Update password
  static Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    try {
      log('Attempting to update password for current user');

      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        log('Password updated successfully');
      } else {
        log('Password update failed: User is null');
      }

      return response;
    } catch (e) {
      log('Password update error: $e');
      rethrow;
    }
  }

  // Update user profile
  static Future<UserResponse> updateProfile({
    Map<String, dynamic>? data,
  }) async {
    try {
      log('Attempting to update user profile');

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: data),
      );

      if (response.user != null) {
        log('Profile updated successfully');
      } else {
        log('Profile update failed: User is null');
      }

      return response;
    } catch (e) {
      log('Profile update error: $e');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      log('Attempting to sign out current user');

      await _supabase.auth.signOut();

      log('Sign out successful');
    } catch (e) {
      log('Sign out error: $e');
      rethrow;
    }
  }

  // Get current session
  static Session? get currentSession => _supabase.auth.currentSession;

  // Get access token
  static String? get accessToken => _supabase.auth.currentSession?.accessToken;

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  // Refresh session
  static Future<AuthResponse> refreshSession() async {
    try {
      log('Attempting to refresh session');

      final response = await _supabase.auth.refreshSession();

      if (response.user != null) {
        log('Session refreshed successfully');
      } else {
        log('Session refresh failed: User is null');
      }

      return response;
    } catch (e) {
      log('Session refresh error: $e');
      rethrow;
    }
  }

  // Get user metadata
  static Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  // Get user app metadata
  static Map<String, dynamic>? get appMetadata => currentUser?.appMetadata;

  // Check if email is confirmed
  static bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Get user ID
  static String? get userId => currentUser?.id;

  // Get user email
  static String? get userEmail => currentUser?.email;

  // Get user name from metadata
  static String? get userName {
    final metadata = currentUser?.userMetadata;
    if (metadata != null) {
      // Try different possible keys for name
      return metadata['full_name'] ??
          metadata['name'] ??
          metadata['display_name'] ??
          metadata['first_name'];
    }
    return null;
  }

  // Get user's full name or construct from first/last name
  static String? get userFullName {
    final metadata = currentUser?.userMetadata;
    if (metadata != null) {
      // First try full_name or name
      String? fullName = metadata['full_name'] ?? metadata['name'];
      if (fullName != null) return fullName;

      // Try to construct from first and last name
      String? firstName = metadata['first_name'];
      String? lastName = metadata['last_name'];

      if (firstName != null && lastName != null) {
        return '$firstName $lastName';
      } else if (firstName != null) {
        return firstName;
      }
    }
    return null;
  }

  // Error handling helper
  static String getAuthErrorMessage(Object error) {
    if (error is AuthException) {
      switch (error.message.toLowerCase()) {
        case 'invalid login credentials':
          return 'Invalid email or password. Please try again.';
        case 'email not confirmed':
          return 'Please check your email and confirm your account before signing in.';
        case 'user not found':
          return 'No account found with this email address.';
        case 'weak password':
          return 'Password should be at least 6 characters long.';
        case 'email already registered':
        case 'user already registered':
          return 'An account with this email already exists.';
        case 'signup disabled':
          return 'Account creation is currently disabled.';
        case 'invalid email':
          return 'Please enter a valid email address.';
        case 'password too short':
          return 'Password must be at least 6 characters long.';
        case 'email rate limit exceeded':
          return 'Too many requests. Please try again later.';
        default:
          return error.message;
      }
    }
    return error.toString();
  }
}
