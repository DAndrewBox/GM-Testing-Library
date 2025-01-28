## What is GameMaker's Testing Library?

**GameMaker's Testing Library (GMTL)** is an open-source testing framework created for and with GameMaker native functions, no DLLs or external dependencies are needed. It's designed to be simple and easy to use, with a focus on simplicity.

If you are a web developer, you may be familiar with testing frameworks and libraries like **Jest** or **React Testing Library**. GMTL is similar to those frameworks since it got it's inspiration from there, but it's designed to work with and using only GameMaker's native functions and features.

The idea behind GMTL is to provide a simple and easy way to test for tool and library developers to test your GameMaker libraries, extensions, and prefabs. It's also useful for game developers to test their game logic, functions, and objects if needed to ensure that everything works as expected.

## What can I test with GMTL?

You can test any GameMaker function, script, or object that you want. You can test your own functions, scripts, from other libraries or extensions. You can also test object behaivours and properties simulating user interactions, frame updates, and more.

## Versions & Compatibility

The minimum version of GameMaker required to use this library is **GameMaker 2023.4**. This is because it heavily uses the _string templates_ and mostly _string functions_ introduced in that version and later like `string_split()`.

The library is fully compatible with the latest version of GameMaker 2024 and will be updated as needed for future versions.

<p style="text-align: center">
  <img src="https://i.imgur.com/p4wQ2vo.png">
</p>

## How To Add GMTL To Your Project

GMTL is very simple to add to your project. You don't need any previous setup or configuration, just plug and test!

To add GMTL to your project, follow these steps:

1. Download the latest version of GMTL from the [Github releases page](https://github.com/DAndrewBox/GM-Testing-Library/releases/latest).

2. Inside GameMaker, click on Tools > Import Local Package... and select the `.yymps` file you downloaded.

3. Add the whole library to your project's resources. _(Or skip the "Demo" folder if already know how to use it)_.

4. You are done! You can start writing your tests right away!

<p style="text-align: center">
  <img src="https://i.imgur.com/bErwkC2.png">
</p>

## Your First Test Suite

GameMaker's Testing Library is very simple to use, but it's very important to understand how it works first. GMTL uses a structure of **suites**, **sections/describe**, and **tests/it** to organize and run your tests.

This means that you will need to create a suite, add sections to it, and then add tests to those sections which will not share any data to the outside, ensuring that each test, section and suite is isolated and independent from each other.

Each test should run and check if the expected result is the same as the actual result and each test will be marked as **passed** or **failed** depending on the result.

To create your first test suite, you should have already one function or object you want to test, then follow these steps:

1. Create a new empty script in your project. (recommended)

2. Add the `suite` function to the script, this will be the main structure of your tests.

```gml
suite(function() {
  // Your section will be inserted here!
});
```

3. Find the script you want to test, for a simple example, a script that adds two numbers.

```gml
/// @function add_two_numbers(a, b)
/// @param {real} a
/// @param {real} b
/// @returns {real}
function add_two_numbers(a, b) {
  return a + b;
}
```

4. Add a section to the suite, this will be the place where you will add your tests _(I like to name the sections with the function or object I'm testing)_. The first parameter is the name of the section, and the second parameter is a function that will contain your tests.

```gml
suite(function() {
  section("add_two_numbers", function() {
    // Your tests will be inserted here!
  });
});
```

5. Add some tests to the section, each test should have a name and a function that will contain the test itself. The `expect` function returns an object and this is used to check if the actual result is the same as the expected result. We would add 3 tests to the section:

```gml
suite(function() {
  section("add_two_numbers", function() {
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

6. Run the project and see the results in the console. You should see something like this:

```
------- add_two_numbers -------
  ✔ 1 + 1 = 2 (0.01ms)
  ✔ 2 + 2 = 4 (0.01ms)
  ✔ 2 + 2 != 10 (0.01ms)

================================================================
======================= Tests Finished! ========================
Test Suites: 1 passed, 1 total. (100% success)
Tests: 3 passed, 3 total. (100% success)
All tests finished in 0.03ms.
```

7. Done! You have created your first test suite usign GameMaker Testing Library.

## Testing Something Bigger!

So, that was a very simple example of how to use GMTL, but you can test something bigger and more complex. As You read, you can also test objects, properties, functions, scripts, and more.

So, let's say we have an object called `obj_timer` and it has a variable `timer` that increases every step while this object exists and destroys itself after 200 frames. We can test from it's creation to it's destruction to see if the timer is increasing as expected.

So, we create first a suite and section for the object.

```gml
suite(function() {
    describe("obj_timer", function() {
        // Your tests will be inserted here!
    }
}
```

When we want to add a way to test the object and execute simulations inside them, so we would use the `create` function to create the object. This function will return the instance id of the object created and workds exactly like the old `instance_create` function.

```gml
test("Should create an instance, wait, and check alive timer.", function() {
    var _inst = create(10, 10, o_gmtl_demo_timer);

    // Check if the instance was created
    expect(instance_exists(_inst)).toBeTruthy();
});
```

We now have to compliment this test with a frame wait simulation to let the object run and increase the timer. We can use the `waitFor` function to wait for a number of frames or seconds before running the next steps of the test. This will trigger an event update for all events in this object.

```gml
test("Should create an instance, wait, and check alive timer.", function() {
    var _inst = create(10, 10, o_gmtl_demo_timer);

    // Check if the instance was created
    expect(instance_exists(_inst)).toBeTruthy();

    // Wait for 5 frames
    _inst.waitFor(5, time_source_units_frames);
	expect(_inst).toHaveProperty("timer", 5);

    // Wait for 2 seconds (120 frames)
    _inst.waitFor(2, time_source_units_seconds);

    // Assuming gamespeed to be 60 fps / sec, so 5 + (60 frames * 2 seconds)
	expect(_inst.timer).toBeEqual(125);
});
```

As you see, we can use `expect` using the `toHaveProperty()` function, or directly referencing it, but, it's safest and error free to use the `toHaveProperty()` function to check if the object has the property we are looking for.

Now, we can add some more wait and a test to check if the object is destroyed after it's timer reaches 200 or more. We can use the `destroy` function to destroy the object and check if it was destroyed.

```gml
test("Should create an instance, wait, and check alive timer and destruction.", function() {
    var _inst = create(10, 10, o_gmtl_demo_timer);

    // Check if the instance was created
    expect(instance_exists(_inst)).toBeTruthy();

    // Wait for 5 frames
    _inst.waitFor(5, time_source_units_frames);
	expect(_inst).toHaveProperty("timer", 5);

    // Wait for 2 seconds (120 frames)
    _inst.waitFor(2, time_source_units_seconds);

    // Assuming gamespeed to be 60 fps / sec, so 5 + (60 frames * 2 seconds)
	expect(_inst.timer).toBeEqual(125);

    // Check if the instance is still alive
    expect(instance_exists(_inst)).toBeTruthy();

    // Wait for 75 frames
    _inst.waitFor(75, time_source_units_frames);

    // Check if the instance was destroyed
    expect(instance_exists(_inst)).toBeFalsy();
});
```

Then, you can run the project and see the results in the console. You should see something like this:

```gml
------- obj_timer -------
  ✔ Should create an instance, wait, and check alive timer. (1.69ms)
======================= Tests Finished! ========================
Test Suites: 1 passed, 1 total. (100% success)
Tests: 1 passed, 1 total. (100% success)
All tests finished in 1.69ms.
```

And that's it! You have created a test suite for a more complex object using GameMaker Testing Library.

If we wanted it, we could also have some keyboard checks to modify te time using the `simulateKey*` functions, or simulate mouse clicks using the `simulateMouse*` functions, or even, simulate two timers with more objects on screen and check if they are working as expected by using functions like `simulateFrameWait`. The limit is your imagination! _(Not really, the limit is the GameMaker functions and features you can use)._

## Troubleshooting and Documentation

If you have any issues or questions about the library, you can check the [Troubleshooting](https://github.com/DAndrewBox/GM-Testing-Library/wiki/Troubleshooting) page for common issues and solutions, or visit the issues tracker in Github to add or check if an issue you have exists there!

If you need more information about the library and functions to use, you can check the [Documentation](https://github.com/DAndrewBox/GM-Testing-Library/wiki/Documentation) page for more details.

Thanks for reading and happy testing!