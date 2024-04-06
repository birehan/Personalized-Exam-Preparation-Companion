# Style Guide

This style guide outlines the recommended conventions and guidelines for writing clean and readable code in the project. Following these guidelines will help maintain consistency and improve the overall quality of the codebase.

## Table of Contents

- [Naming Conventions](#naming-conventions)
- [Code Formatting](#code-formatting)
- [Documentation](#documentation)
- [Imports](#imports)
- [Line Length](#line-length)
- [Commit Convention](#commit-convention)

## Naming Conventions

- Use descriptive and meaningful names for variables, functions, classes, and modules.
- Variable and function names should be in lowercase, with words separated by underscores.
- Class names should follow the CamelCase convention.
- Constants should be written in uppercase.

## Code Formatting

- Indentation should consist of four spaces. Do not use tabs.
- Use vertical whitespace to separate logical sections and improve readability.
- Use parentheses for line continuation when necessary.
- Keep lines of code concise and avoid excessive line lengths.
- Follow the PEP 8 guidelines for code formatting.

## Documentation

- Provide clear and concise comments to explain the code's purpose, behavior, and any important details.
- Use docstrings to document modules, classes, and functions.
- Follow the [PEP 257](https://www.python.org/dev/peps/pep-0257/) guidelines for docstring formatting.
- Include a summary line in docstrings that concisely describes the module, class, or function.
- Use clear and descriptive language in docstrings to explain the purpose, behavior, and usage of the code.

An example of the expected docstring format is as follows:

### Modules:

```python
"""Summary line.

Extended description of the module.

"""

# Module implementation

```


### Classes:

```python
class ClassName:
    """Summary line.

    Extended description of the class.

    Attributes:
        attribute1 (type): Description of attribute1.
        attribute2 (type): Description of attribute2.

    """

    # Class implementation

```

### Functions:

```python
def function_name(parameter1, parameter2):
    """Summary line.

    Extended description of the function's purpose, behavior, and usage.

    Args:
        parameter1 (type): Description of parameter1.
        parameter2 (type): Description of parameter2.

    Returns:
        type: Description of the return value.

    Raises:
        ExceptionType: Description of the exception raised.

    """

    # Function implementation

```

This format ensures clear and consistent documentation throughout the project, making it easier to understand and maintain the codebase.

## Imports

- Place imports at the top of the file, below any module-level docstrings.
- Group imports in the following order:
  1. Standard library imports
  2. Third-party library imports
  3. Project-specific imports
- Use explicit import statements rather than importing entire modules.
- Avoid using wildcard imports (`from module import *`) as it can lead to namespace conflicts and make code harder to understand.

## Line Length

- Keep lines of code and comments within 79 characters to ensure readability.
- Break long lines using parentheses, backslashes, or other appropriate line continuation techniques.

Remember to use common sense and readability as the guiding principles when writing code. Consistency is key to maintain a clean and manageable codebase.

Following this style guide will contribute to the overall quality, readability, and maintainability of the project.

## Commit Convention

* Follow the [Conventional Commits](https://www.conventionalcommits.org/) convention for writing commit messages.
* Use semantic commit messages that clearly describe the purpose and impact of the commit.
* Prefix commit messages with one of the following types:
  * feat: for a new feature
  * fix: for a bug fix
  * docs: for documentation updates
  * refactor: for code refactoring
  * test: for adding or modifying tests
  * chore: for routine tasks, build changes, etc.

Remember to use common sense and readability as the guiding principles when writing code. Consistency is key to maintain a clean and manageable codebase.

Following this style guide will contribute to the overall quality, readability, and maintainability of the project.

**Note:** For additional guidelines and best practices, refer to the official [PEP 8](https://www.python.org/dev/peps/pep-0008/) style guide.
