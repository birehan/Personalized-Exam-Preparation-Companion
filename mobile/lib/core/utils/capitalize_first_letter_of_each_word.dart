String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) {
    return '';
  }

  final words = input.split(' ');

  final result = StringBuffer();

  for (final word in words) {
    if (word.isEmpty) {
      continue; // Skip empty words
    }

    final firstCharacter = word[0];
    final isSpecialCharacter =
        !firstCharacter.toLowerCase().contains(RegExp(r'[a-z]'));

    if (isSpecialCharacter) {
      result.write(firstCharacter);
      result.write(word.substring(1));
    } else {
      final capitalizedWord = firstCharacter.toUpperCase() + word.substring(1);
      result.write(capitalizedWord);
    }

    result.write(' ');
  }

  return result.toString().trim();
}
