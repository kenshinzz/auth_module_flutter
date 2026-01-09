import 'package:flutter_test/flutter_test.dart';

import 'package:auth_module/auth_module.dart';

void main() {
  group('User Entity', () {
    test('creates user with required fields', () {
      const user = User(
        id: '1',
        email: 'test@example.com',
      );
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, isNull);
      expect(user.token, isNull);
    });

    test('creates user with all fields', () {
      const user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        token: 'abc123',
      );
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.token, 'abc123');
    });

    test('equality works correctly', () {
      const user1 = User(id: '1', email: 'test@example.com');
      const user2 = User(id: '1', email: 'test@example.com');
      const user3 = User(id: '2', email: 'other@example.com');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });

  group('Failures', () {
    test('AuthFailure has correct message', () {
      const failure = AuthFailure('Invalid credentials');
      expect(failure.message, 'Invalid credentials');
    });

    test('ServerFailure has default message', () {
      const failure = ServerFailure();
      expect(failure.message, 'Server error occurred');
    });

    test('NetworkFailure has default message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Network error occurred');
    });
  });

  group('AuthModule', () {
    test('throws when not configured', () {
      expect(
        () => AuthModule.instance,
        throwsA(isA<StateError>()),
      );
    });
  });
}
