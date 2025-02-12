const checkBiometricAuthChanged = () => {
  if (typeof process !== 'undefined' && process.platform && process.platform === 'darwin') {
    const auth = require('bindings')('auth.node')
    return auth.checkBiometricAuthChanged()
  }
  return false
}

module.exports = {
  checkBiometricAuthChanged,
}
