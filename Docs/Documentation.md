# 📚 Documentation

This is the official and up-to-date documentation for the **GameMaker's Testing Library**. Here you will find all the information you need to start using the library in your projects.

---

## 📖 Table of Contents

- [Setup](#setup)
  - [suite](#suite)
  - [describe / section](#describe)
  - [test / it](#test)
  - [each](#each)
  - [skip](#skip)
  - [expect](#expect)
- [Teardown](#teardown)
  - [Order of Execution](#order-of-execution)
  - [beforeEach](#beforeeach)
  - [afterEach](#aftereach)
  - [beforeAll](#beforeall)
  - [afterAll](#afterall)
- [Common Matchers](#common-matchers)
  - [toBe](#tobe)
  - [toEqual](#toequal)
  - [toContain](#tocontain)
  - [toHaveLength](#tohavelength)
  - [toHaveProperty](#tohaveproperty)
  - [toHaveReturned](#tohavereturned)
  - [toHaveReturnedWith](#tohavereturnedwith)
- [Truthiness](#truthiness)
  - [toBeTruthy](#tobetruthy)
  - [toBeFalsy](#tobefalsy)
- [Numbers](#numbers)
  - [toBeGreaterThan](#tobegreaterthan)
  - [toBeLessThan](#tobelessthan)
  - [toBeGreaterThanOrEqual](#tobegreaterthanorequal)
  - [toBeLessThanOrEqual](#tobelessthanorequal)
- [never](#never)
- [Simulations](#simulations)
  - [create](#create)
  - [simulateKeyPress](#simulatekeypress)
  - [simulateKeyRelease](#simulatekeyrelease)
  - [simulateKeyHold](#simulatekeyhold)
  - [simulateGamepadButtonPress](#simulategamepadbuttonpress)
  - [simulateGamepadButtonRelease](#simulategamepadbuttonrelease)
  - [simulateGamepadButtonHold](#simulategamepadbuttonhold)
  - [simulateMouseClickPress](#simulatemouseclickpress)
  - [simulateMouseClickRelease](#simulatemouseclickrelease)
  - [simulateMouseClickHold](#simulatemouseclickhold)
  - [simulateMousePosition](#simulatemouseposition)
  - [simulateFrameWait](#simulateframewait)
  - [simulateEvent](#simulateevent)

---

## Setup

Here you will find all the functions you need to start writing tests with the **GameMaker's Testing Library**. These are some of functions to create your tests: `suite`, `section`, and `test`. Here's an example of how to use them:

```gml
suite(function() {
  section("My Section", function() {
    test("My Test", function() {
      // Test code here
    });
  });
});
```

### suite

`suite(callback)`

> [!IMPORTANT]
> You must always start your tests with a `suite` function. This is the root of your test suite and will contain all your tests. If you don't start with a `suite`, your tests will not run and probably throw an error.

Suites are used to group sections of tests together. They can be nested to create a hierarchy of tests. Suites can contain other sections and tests. You can put a suite in any script file, but it is recommended to have a single suite per script file.

### describe

`describe(name, callback)` _or_ `section(name, callback)`

> [!IMPORTANT] > `describe` and `section` are the same function. You can use either of them to group your tests together. They are used to create a new section of tests inside a suite. You cannot nest sections inside other sections. sections should always be inside a suite and outside test.

Sections are used to group tests together. They can contain tests but not other sections nor suites. You can put a section in any suite and it is recommended to have multiple sections per suite to group your tests together.

### test

`test(name, callback)` _or_ `it(name, callback)`

> [!IMPORTANT]
> `test` and `it` are the same function. You can use either of them to create a new test. They are used to create a new test inside a section. You cannot nest tests inside other tests. Tests should always be inside a section.

Tests are used to test a specific piece of code. They should be small and focused on a single aspect of your code. You can put a test in any section and it is recommended to have multiple tests per section to test different parts of your code.

Inside a test, you can use the `expect` function to make assertions about your code. This function will compare the actual value with the expected value and throw an error if they are not the same as the one expected using a matcher. You can look at the [Common Matchers](#common-matchers) section to see various of the available matchers.

### each

`each(name, callback, cases)`

The `each` function is used to run a test multiple times with different arguments. This is useful when you want to test the same code with different inputs. You can pass an array of arguments to the `each` function and it will run the test for each argument.

The name of the test can be customized by using `{0}, {1}, {2}, ...` in the name string. These will be replaced by the arguments passed to the `each` function. And it will add a `[Case {index}]` to the test name.

It's basically works like a loop that runs the test for each argument in the array. You can also add arrays inside the main array to test multiple arguments at once.

Example:

```gml
suite(function() {
  section("My Section", function() {
    each("Should {0} + {1} be {2}.", function(_arg1, _arg2, _arg3) {
			expect(_arg1 + _arg2).toBe(_arg3);
		},
		[
			[1, 1, 2],
			[5, 5, 10],
			[3, 6, 9],
			[-5, 5, 0]
		]);
  });
});
```

### skip

`skip(name, callback, [cases])`

The `skip` function is used to skip a test or a section of tests. This is useful when you want to temporarily disable a test without deleting it. You can pass a test or a section to the `skip` function and it will not run the test when the suite is executed.

Example:

```gml
suite(function() {
  section("My Section", function() {
    test("My Test", function() {
      // Test code here
    });

    skip("My Skipped Test", function() {
      // Test code here
    });
  });
});
```

### expect

`expect(actual)`

The `expect` function is used to make assertions about your code. It will compare the actual value with the expected value and throw an error if they are not the same. You can use various matchers to make different types of assertions. You can look at the [Common Matchers](#common-matchers) section to see various of the available matchers.

You can also use the method `.never()` to negate the assertion. This is useful when you want to check if something never happens. You can look at the [never](#never) section to see how to use it.

Example:

```gml
suite(function() {
  section("My Section", function() {
    test("My Test", function() {
      expect(1 + 1).toBe(2);
      expect(1 + 1).never().toBe(3);
    });
  });
});
```

---

## Teardown

Here you will find all the functions you need to clean up your tests with the **GameMaker's Testing Library**. These are some of functions to clean up your tests: `beforeEach`, `afterEach`, `beforeAll`, and `afterAll`. Here's an example of how to use them:

```gml
beforeAll(function() {
  // Code to run before all tests
});

beforeEach(function() {
  // Code to run before each test
});

afterEach(function() {
  // Code to run after each test
});

afterAll(function() {
  // Code to run after all tests
});

suite(function() {
  section("My Section", function() {
    test("My Test", function() {
      // Test code here
    });
  });
});
```

### Order of Execution

The order of execution of the teardown functions is as follows:

```plaintext
> Suite starts
  > Start describe/section
    > Run beforeAll()
    > Start loop of it/test
      > Run beforeEach()
      > Run it/test
      > Run afterEach()
    > Finish loop of it/test
    > Run afterAll()
  > Finish describe/section
> Suite ends
```

So, the `beforeAll` function will run before all tests in the suite, the `beforeEach` function will run before each test, the `afterEach` function will run after each test, and the `afterAll` function will run after all tests in the suite.

**These functions should be defined inside a `suite` or a `section` but never inside a `test`.**

> [!NOTE]
> The `before*` and `after*` functions are optional and you don't need to use them if you don't need to run code before or after all tests in a suite.

> [!WARNING]
> Variables inside the `before*` and `after*` functions are not accessible inside the tests. If you need to share data between the tests and the `before*` and `after*` functions, you can use global variables or the `self` object. But beware since there are reserved words that you can't use as global variables.

### beforeEach

`beforeEach(callback)`

The `beforeEach` function is used to run a piece of code before each test in a section. This is useful when you want to set up some data before each test. You can put a `beforeEach` function in any section and it will run before each test in that section.

### afterEach

`afterEach(callback)`

The `afterEach` function is used to run a piece of code after each test in a section. This is useful when you want to clean up some data after each test. You can put an `afterEach` function in any section and it will run after each test in that section.

### beforeAll

`beforeAll(callback)`

The `beforeAll` function is used to run a piece of code before all tests in a suite. This is useful when you want to set up some data before all tests. You can put a `beforeAll` function in any suite and it will run before all sections in that suite. You can also put a `beforeAll` function in a section and it will run before all tests in that section.

### afterAll

`afterAll(callback)`

The `afterAll` function is used to run a piece of code after all tests in a suite. This is useful when you want to clean up some data after all tests. You can put an `afterAll` function in any suite and it will run after all sections in that suite. You can also put an `afterAll` function in a section and it will run after all tests in that section.

---

## Common Matchers

Here you will find all the matchers you can use after the `expect` function to make assertions about your code. Some matchers are type-specific and can only be used with certain types of values. You can find an example on how to use every matcher in the `/Demo/GMTL_demo_tests` script inside this library.

### toBe

`toBe(expected)`

The `toBe` matcher is used to compare the actual value with the expected value using the `==` operator. This matcher will check if the actual value is the same as the expected value. It will throw an error if they are not the same. This matcher is used to compare primitive values like numbers, strings, ref index, and booleans, and can accept arrays, but not structs. For structs, you can use the `toEqual` matcher.

### toEqual

`toEqual(expected)`

The `toEqual` matcher is used to compare the actual value with the expected value using the `==` operator. This matcher will check if the actual value is the same as the expected value. It will throw an error if they are not the same. This matcher is used to compare primitive values like numbers, strings, ref index, and booleans, and can accept arrays and structs.

### toContain

`toContain(expected)`

The `toContain` matcher is used to check if the actual value contains the expected value. This matcher will check if the actual value is an array and contains the expected value. It will throw an error if the actual value is not an array or struct, or if it does not contain the expected value.

### toHaveLength

`toHaveLength(expected)`

The `toHaveLength` matcher is used to check if the actual value has the expected length. This matcher will check if the actual value is an array, string or struct and has the expected length. It will throw an error if the actual value is not an array, string or struct, or if it does not have the expected length.

### toHaveProperty

`toHaveProperty(property, [value])`

The `toHaveProperty` matcher is used to check if the actual value has the expected property. This matcher will check if the actual value is a struct and has the expected property. It will throw an error if the actual value is not a struct, or if it does not have the expected property. You can also pass a value to check if the property has the expected value.

### toHaveReturned

`toHaveReturned()`

The `toHaveReturned` matcher is used to check if the actual value has returned a value. This matcher will check if the actual value is a function and has returned a value. It will throw an error if the actual value is not a function, or if it has not returned a value. (not `undefined`)

### toHaveReturnedWith

`toHaveReturnedWith(expected)`

The `toHaveReturnedWith` matcher is used to check if the actual value has returned the expected value. This matcher will check if the actual value is a function and has returned the expected value. It will throw an error if the actual value is not a function, or if it has not returned the expected value.

---

## Truthiness

Here you will find all the matchers you can use to check the truthiness of a value. These matchers are used to check if a value is `true` or `false`.

### toBeTruthy

`toBeTruthy()`

The `toBeTruthy` matcher is used to check if the actual value is `true`. This matcher will check if the actual value is `true`. It will throw an error if the actual value is not `true`.

### toBeFalsy

`toBeFalsy()`

The `toBeFalsy` matcher is used to check if the actual value is `false`. This matcher will check if the actual value is `false`. It will throw an error if the actual value is not `false`.

---

## Numbers

Here you will find all the matchers you can use to compare numbers. These matchers are used to compare numbers and check if they are greater than, less than, or equal to other numbers.

### toBeGreaterThan

`toBeGreaterThan(expected)`

The `toBeGreaterThan` matcher is used to check if the actual value is greater than the expected value. This matcher will check if the actual value is greater than the expected value. It will throw an error if the actual value is not greater than the expected value.

### toBeLessThan

`toBeLessThan(expected)`

The `toBeLessThan` matcher is used to check if the actual value is less than the expected value. This matcher will check if the actual value is less than the expected value. It will throw an error if the actual value is not less than the expected value.

### toBeGreaterThanOrEqual

`toBeGreaterThanOrEqual(expected)`

The `toBeGreaterThanOrEqual` matcher is used to check if the actual value is greater than or equal to the expected value. This matcher will check if the actual value is greater than or equal to the expected value. It will throw an error if the actual value is not greater than or equal to the expected value.

### toBeLessThanOrEqual

`toBeLessThanOrEqual(expected)`

The `toBeLessThanOrEqual` matcher is used to check if the actual value is less than or equal to the expected value. This matcher will check if the actual value is less than or equal to the expected value. It will throw an error if the actual value is not less than or equal to the expected value.

---

## never

`.never()`

> ![IMPORTANT]
> The `never` matcher is used to negate an assertion. This matcher is used to check if something never happens. You can use it after the `expect` function to negate the assertion. It basically works like a `not` operator in other testing libraries, but `not` cannot be used in GameMaker because is a reserved word.

Here you will find all the matchers you can use to negate an assertion. These matchers are used to check if something never happens.

Example:

```gml
suite(function() {
  section("My Section", function() {
    test("My Test", function() {
      expect(1 + 1).toBe(2);
      expect(1 + 1).never().toBe(3);
    });
  });
});
```

---

## Simulations

Here you will find all the functions you can use to simulate events in your tests. These functions are used to simulate key presses, mouse clicks, gamepad button presses, and other events. You can use these functions to test how your code reacts to different events.

### create

`create(x, y, object, [params])`

The `create` function is used to create an instance of an object at a specific position. This function will create an instance of the object at the specified position. You can also pass additional parameters to the object's `Create` event. The instance id of the created object will be returned and should be deleted after the test using `instance_destroy()`.

Example:

```gml
suite("Mfunction() {
  section("My Section", function() {
    test("My Test", function() {
      var _obj = create(0, 0, obj_player);
      expect(_obj).toBeGreaterThan(-1);
      instance_destroy(_obj);
    });
  });
});
```

### simulateKeyPress

`simulateKeyPress(key)`

The `simulateKeyPress` function is used to simulate a key press event. This function will simulate a key press event for the specified key. You can pass a virtual key code to the function to simulate a key press event. The key code should be a virtual key code like `vk_space`, `vk_left`, `vk_right`, etc.

### simulateKeyRelease

`simulateKeyRelease(key)`

The `simulateKeyRelease` function is used to simulate a key release event. This function will simulate a key release event for the specified key. You can pass a virtual key code to the function to simulate a key release event. The key code should be a virtual key code like `vk_space`, `vk_left`, `vk_right`, etc.

### simulateKeyHold

`simulateKeyHold(key)`

The `simulateKeyHold` function is used to simulate a key hold event. This function will simulate a key hold event for the specified key. You can pass a virtual key code to the function to simulate a key hold event. The key code should be a virtual key code like `vk_space`, `vk_left`, `vk_right`, etc. The key will be held until a `simulateKeyRelease` function is called.

### simulateGamepadButtonPress

`simulateGamepadButtonPress(device, button)`

The `simulateGamepadButtonPress` function is used to simulate a gamepad button press event. This function will simulate a gamepad button press event for the specified device and button. You can pass a device id and a button id to the function to simulate a gamepad button press event. The device id should be a device id like `0`, `1`, etc. The button id should be a button id like `gp_face1`, `gp_*`, etc.

### simulateGamepadButtonRelease

`simulateGamepadButtonRelease(device, button)`

The `simulateGamepadButtonRelease` function is used to simulate a gamepad button release event. This function will simulate a gamepad button release event for the specified device and button. You can pass a device id and a button id to the function to simulate a gamepad button release event. The device id should be a device id like `0`, `1`, etc. The button id should be a button id like `gp_face1`, `gp_*`, etc.

### simulateGamepadButtonHold

`simulateGamepadButtonHold(device, button)`

The `simulateGamepadButtonHold` function is used to simulate a gamepad button hold event. This function will simulate a gamepad button hold event for the specified device and button. You can pass a device id and a button id to the function to simulate a gamepad button hold event. The device id should be a device id like `0`, `1`, etc. The button id should be a button id like `gp_face1`, `gp_*`, etc. The button will be held until a `simulateGamepadButtonRelease` function is called.

### simulateMouseClickPress

`simulateMouseClickPress(button, [x], [y])`

The `simulateMouseClickPress` function is used to simulate a mouse click press event. This function will simulate a mouse click press event for the specified button. You can pass a button id to the function to simulate a mouse click press event. The button id should be a button id like `mb_left`, `mb_right`, etc. You can also pass an optional x and y position to simulate a mouse click at a specific position.

### simulateMouseClickRelease

`simulateMouseClickRelease(button, [x], [y])`

The `simulateMouseClickRelease` function is used to simulate a mouse click release event. This function will simulate a mouse click release event for the specified button. You can pass a button id to the function to simulate a mouse click release event. The button id should be a button id like `mb_left`, `mb_right`, etc. You can also pass an optional x and y position to simulate a mouse click at a specific position.

### simulateMouseClickHold

`simulateMouseClickHold(button, [x], [y])`

The `simulateMouseClickHold` function is used to simulate a mouse click hold event. This function will simulate a mouse click hold event for the specified button. You can pass a button id to the function to simulate a mouse click hold event. The button id should be a button id like `mb_left`, `mb_right`, etc. You can also pass an optional x and y position to simulate a mouse click at a specific position. The button will be held until a `simulateMouseClickRelease` function is called.

### simulateMousePosition

`simulateMousePosition(x, y)`

The `simulateMousePosition` function is used to simulate a mouse position event. This function will simulate a mouse position event for the specified position. You can pass an x and y position to the function to simulate a mouse position event. The mouse position will be set to the specified position.

### simulateFrameWait

`simulateFrameWait([frames])`

> [!IMPORTANT]
> This function simulates frames passing by executing the step events of the objects, the frames are not actually rendered by GameMaker.

The `simulateFrameWait` function is used to simulate a frame wait event. This function will wait for the specified number of virtual frames before continuing. You can pass an optional number of frames to the function to wait for a specific number of frames. If no frames are specified, it will wait for one frame.

### simulateEvent

`simulateEvent(event_type, event_number, [instance_id])`

The `simulateEvent` function is used to simulate an event for an object. This function will simulate an event for the specified object. You can pass an object id, an event id, and an optional instance id to the function to simulate an event for the specified object. The event type and number should be theones described in the manual like `ev_create`, `ev_step`, etc. The instance id should be an instance id, if no instance id is specified, it will simulate the event for all instances currently active.
