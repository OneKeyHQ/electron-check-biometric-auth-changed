const auth = require('bindings')('auth.node')

module.exports = {
  checkBiometricAuthChanged: auth.checkBiometricAuthChanged,
}
