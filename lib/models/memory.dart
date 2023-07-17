class Memory {
  static const operations = ['%', '/', 'x', '-', '+', '='];
  String _value = '0';
  late String _operation;
  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  String get value => _value;
  bool _wipeValue = false;
  final String _lastCommand = '';

  _isReplacingOperation(String command) {
    return operations.contains(_lastCommand) &&
        operations.contains(command) &&
        _lastCommand != '=' &&
        command != '=';
  }

  void _allClear() {
    _value = '0';
    _buffer.setAll(0, [0.0, 0.0]);
    _operation = '';
    _wipeValue = false;
  }

  _calculate() {
    switch (_operation) {
      case '%':
        return _buffer[0] % _buffer[1];
      case '/':
        return _buffer[0] / _buffer[1];
      case 'x':
        return _buffer[0] * _buffer[1];
      case '-':
        return _buffer[0] - _buffer[1];
      case '+':
        return _buffer[0] + _buffer[1];
      default:
        return _buffer[0];
    }
  }

  String _addDigit(String digit) {
    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot || _wipeValue);
    final emptyValue = isDot ? '0' : '';
    final currentValue = wipeValue ? emptyValue : _value;

    if (isDot && currentValue.contains('.') && !wipeValue) return _value;
    _wipeValue = false;
    _value = currentValue + digit;
    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0;
    return _value;
  }

  void _setOperation(String newOperation) {
    bool isEqualSign = newOperation == '=';
    if (_bufferIndex == 0 && !isEqualSign) {
      _operation = newOperation;
      _bufferIndex = 1;
      _wipeValue = true;
    } else {
      _buffer[0] = _calculate();
      _buffer[1] = 0.0;
      _value = _buffer[0].toString();
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value;
      _operation = isEqualSign ? '' : newOperation;
      _bufferIndex = isEqualSign ? 0 : 1;
      _wipeValue = true;
    }
  }

  void applyCommand(String command) {
    if (_isReplacingOperation(command)) {
      _operation = command;
      return;
    }
    if (command == 'AC') return _allClear();
    if (operations.contains(command)) return _setOperation(command);
    _addDigit(command);
  }
}
