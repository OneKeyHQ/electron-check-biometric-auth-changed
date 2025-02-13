const checkBiometricAuthChanged = () => {
  if (typeof process !== 'undefined' && process.platform && process.platform === 'darwin') {
    const auth =
      process.arch === 'arm64' ? require('./auth-arm64.node') : require('./auth-x64.node')
    return auth.checkBiometricAuthChanged()
  }
  return false
}

module.exports = {
  checkBiometricAuthChanged,
}
