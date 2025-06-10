# 🚀 Getting Started

---

## 📖 Table of Contents

- [🌱 Installation](#-installation)
- [⚡ Quick Start](#-quick-start)

---

## 🌱 Installation

1. Download the latest version of the library from the [releases page](https://github.com/DAndrewBox/GM-Testing-Library/releases).
2. Import the library into your project.
3. Add the library to your project's resources.
4. Done!

<p style="text-align: center">
  <img src="https://i.imgur.com/bErwkC2.png">
</p>

---

## ⚡ Quick Start

1. Create a new empty script anywhere and call it however you want, for example, `test_add_two_numbers`.
2. Add the following code to the script:

```gml
suite("My first test suite", function() {
  // Your section will be inserted here!
});
```

3. Find a script you want to test, for example, a script that adds two numbers.

```gml
/// @function add_two_numbers(a, b)
/// @param {real} a
/// @param {real} b
/// @returns {real}
function add_two_numbers(a, b) {
  return a + b;
}
```

4. Add a section to the suite:

```gml
suite("My first test suite", function() {
  section("Add two numbers", function() {
    // Your tests will be inserted here!
  });
});
```

5. Add some tests to the section:

```gml
suite("My first test suite", function() {
  section("Add two numbers", function() {
    test("1 + 1 = 2", function() {
      expect(add_two_numbers(1, 1)).toBe(2);
    });

    test("2 + 2 = 4", function() {
      var _value = add_two_numbers(2, 2);
      expect(_value).toBe(4);
      expect(_value).toBeLessThan(5);
    });

    test("2 + 2 != 10", function() {
      expect(add_two_numbers(1, 2)).never().toBe(10);
    });
  });
});
```

6. Run project and see the results in the console. You should see something like this:

```
------- Add two numbers -------
  ✔ 1 + 1 = 2 (0.01ms)
  ✔ 2 + 2 = 4 (0.01ms)
  ✔ 2 + 2 != 10 (0.01ms)

================================================================
======================= Tests Finished! ========================
Test Suites: 1 passed, 1 total. (100% success)
Tests: 3 passed, 3 total. (100% success)
All tests finished in 0.03ms.
```

7. Done! You have created your first test suite with the GameMaker Testing Library.