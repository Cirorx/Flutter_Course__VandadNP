import 'package:learning_dart/services/auth/auth_exceptions.dart';
import 'package:learning_dart/services/auth/auth_provider.dart';
import 'package:learning_dart/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock authentication", () {
    final provider = MockAuthProvider();
    test("provider shouldn't be initialized", () {
      expect(provider.isInitialize, false);
    });

    test("Can't logged out if not initialize", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializeException>()),
      );
    });

    test("provider should be initialized", () async {
      await provider.initialize();
      expect(
        provider.isInitialize,
        true,
      );
    });

    test("User should be null after initialized", () {
      expect(
        provider.currentUser,
        null,
      );
    });

    test(
      "initialize in less than 2seconds",
      () async {
        await provider.initialize();
        expect(
          provider.isInitialize,
          true,
        );
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Create user shouldn't log in user", () async {
      final badEmail = provider.createUser(
        email: 'foo@mail.com',
        password: "goodpassword",
      );
      expect(
        badEmail,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
    });

    test("Create user shouldn't log in user", () async {
      final badPassword = provider.createUser(
        email: 'goodEmail@mail.com',
        password: "foobar",
      );
      expect(
        badPassword,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );
    });

    test("Create user should log in user", () async {
      final user = await provider.createUser(
        email: 'goodEmail@mail.com',
        password: "goodpassword",
      );
      //we check that the current user is the logged in user
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("User can get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;

      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("User can get logged out", () {
      provider.logOut;
      final user = provider.currentUser;
      expect(user, isNull);
    });

    //Groups run secuentally, this will be the last line runned
  });
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialize = false;
  AuthUser? _user;
  bool get isInitialize => _isInitialize;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialize = true;
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialize) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isInitialize) throw NotInitializeException();
    //not found
    if (email == "foo@mail.com") throw UserNotFoundAuthException();
    //wrong password
    if (password == "foobar") throw WrongPasswordAuthException();

    const user = AuthUser(
      isEmailVerified: false,
      email: 'foo@bar.com',
    );
    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialize) throw NotInitializeException();
    //check if its loggedin
    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialize) throw NotInitializeException();
    //check if its loggedin
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();

    const userVerified = AuthUser(
      isEmailVerified: true,
      email: 'foo@bar.com',
    );
    _user = userVerified;
  }
}
