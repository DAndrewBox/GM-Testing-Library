# 🛠️ Troubleshooting

This section contains common issues and solutions that you may encounter while using the library. I'll be updating this section as I find new issues or solutions.

## 🚧 Common Issues

### `mouse_x` and `mouse_y` variables are not working after installing the library.

This issue is caused by the library's `mouse_x` and `mouse_y` variables being used in the project. To fix this, you need to change the variable names in the library's scripts. You can do this by removing the library from the project while testing.

It's known that with GUI scale changes the mouse_x and mouse_y variables are not updated correctly. This is a known issue and it's being worked on.

### How can I test async functions with GMTL?

Since v1.2, async event handlers can be tested using `simulateAsyncEvent()`. It fires any GameMaker async event synchronously during a test with a fake `async_load` map you supply as a struct.

**Required: use `async_load_map` instead of `async_load` in your handlers.**

`async_load` is a read-only engine built-in that cannot be intercepted from script. GMTL provides `async_load_map` as a transparent drop-in replacement - it returns the real `async_load` in normal builds and the simulated map during tests.

```gml
// In your object's Async - HTTP event:
// Change:  async_load[? "status"]
// To:      var _map = async_load_map;
//          _map[? "status"]

var _map = async_load_map;
http_status = _map[? "status"];
http_result = _map[? "result"];
```

```gml
// In your test:
suite(function() {
  describe("HTTP handler", function() {
    it("handles success response", function() {
      var _inst = create(0, 0, o_my_handler);
      simulateAsyncEvent(async_web, {
        status: 0,
        result: "{\"ok\":true}",
      }, _inst);
      expect(_inst.http_status).toBe(0);
      instance_destroy(_inst);
    });
  });
});
```

See the [simulateAsyncEvent](#simulateasyncevent) section in the documentation for the full list of async event constants and examples.

---

### Coverage report shows 0% for all functions

Functions are only marked covered when passed as a **reference** to `expect()`, not when called as plain expressions.

```gml
// NOT tracked - function is called before expect() sees it:
expect(my_function(1, 2)).toBe(3);

// TRACKED - function reference + args passed to expect():
expect(my_function, [1, 2]).toHaveReturnedWith(3);
```

---

### Coverage report shows 0% and no files are listed

The coverage file scanner only runs when `gmtl_show_coverage = true`. Check `GMTL_definitions.gml`:

```gml
#macro gmtl_show_coverage true
```

Also confirm your script files are not inside a folder starting with `GMTL_` - those are excluded by default (internal library scripts). User scripts in any other folder are always scanned.

---

### My functions don't appear in the coverage report

The scanner only indexes top-level named functions (`function name() { ... }`) defined at script scope. It skips:

- Functions whose folder starts with `GMTL_` (unless whitelisted)
- Anonymous / lambda functions
- Constructor methods defined inside a constructor body
- Lines containing `@`, `//`, `__`, or `new `

---

### Cannot run the game after installing the library

This issue can be caused by the library's scripts not being found in the project, or because of the `GMTL_remove_unused` file in some platforms. To fix this, you need to add the library to the project and remove the `GMTL_remove_unused` file from the project if needed.

---

### Library not found

This error is caused by the library not being found in the project. To fix this, you need to add the library to the project. You can do this by following the installation instructions in the [**Getting Started**](./Getting-Started) section.

---

### GMTL_Definitions script file empty after importing in blank project

This issue should be solved since v1.1.0, but if you still encounter it, you can manually copy the contents of the `GMTL_Definitions` script file from the [library's repository](https://github.com/DAndrewBox/GM-Testing-Library/blob/main/GM-Testing-Library/scripts/GMTL_definitions/GMTL_definitions.gml) into your project. This file contains the definitions for the library's functions and is essential for the library to work correctly.

I'm not really sure what causes this issue, but it seems to be related to the import process of the library that GameMaker does. If you encounter this issue, please [create an issue](https://github.com/DAndrewBox/GM-Testing-Library/issues) so I can investigate it further.

---

### Timesources are not working in tests or not working when created before the test suite

This issue is caused by the timesources not being initialized correctly in the test environment. It was fixed in v1.2.1, I heavily recommend updating to the latest version of the library if you encounter any issues before opening a new issue.