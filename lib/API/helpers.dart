String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  } else {
    return input.split(' ').map((word) {
      if (word.isNotEmpty && !isUpperCase(word)) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word;
      }
    }).join(' ');
  }
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  } else {
    return input[0].toUpperCase() + input.substring(1);
  }
}

bool isUpperCase(String input) {
  if (input == input.toUpperCase()) {
    return true;
  } else {
    return false;
  }
}
