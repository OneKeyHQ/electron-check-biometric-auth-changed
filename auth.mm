#include <napi.h>

#import <LocalAuthentication/LocalAuthentication.h>

// No-op value to pass into function parameter for ThreadSafeFunction
Napi::Value NoOp(const Napi::CallbackInfo &info) {
  return info.Env().Undefined();
}

Napi::Value CheckBiometricAuthChanged(const Napi::CallbackInfo &info) {
  Napi::Env env = info.Env();

  LAContext *context = [[LAContext alloc] init];
  NSError *error = nil;
  bool changed = NO;

  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           error:&error]) {
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil];
    NSData *domainState = [context evaluatedPolicyDomainState];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *oldDomainState = [defaults objectForKey:@"macBiometricAuthState"];

    if (oldDomainState) {
      changed = ![oldDomainState isEqual:domainState];
    }

    [defaults setObject:domainState forKey:@"macBiometricAuthState"];
    [defaults synchronize];
  }

  return Napi::Boolean::New(env, changed);
}

// Initializes all functions exposed to JS
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "checkBiometricAuthChanged"),
              Napi::Function::New(env, CheckBiometricAuthChanged));

  return exports;
}

NODE_API_MODULE(permissions, Init)