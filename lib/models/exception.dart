class ContractException implements Exception {
  const ContractException();

  @override
  String toString() {
    return "Operation not possible at the moment!";
  }
}
