
suite(function() {
	// Every suite() should have at least 1 describe() or section().
	describe("GameMaker's Testing Library - Demo - Suite 1 - Describe 1", function() {
		if (true) { // Set to false to disable messages
			#region Before/After - Each/All
			/*
				This events are optional but could help to work with multiple workflows.
				The execution order for this functions per suite is:
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
			*/

			beforeAll(function() {
				// This runs before all tests starts
			});
	
			afterAll(function() {
				// This runs after all tests are completed
			});
	
			beforeEach(function() {
				// This runs before EACH test starts
			});
		
			afterEach(function() {
				// This runs after EACH test ends
			});
			#endregion	
		}
		
		// Every describe() should have at least 1 it()
		// A simple test for almost all methods
		it("Should pass", function() {
			var _a = 0;
			_a++;
			expect(_a).toBe(1);
			++_a;
			expect(_a).toBe(2);
			_a *= 2;
			expect(_a).toBeEqual(4);
			expect(_a + 1).toBeEqual(5);
			expect(_a).toBe(4);
			
			var _b = ["apple", "mango", "pineapple"];
			expect(_b[1]).toBe("mango");
			expect(_a == _b[1]).toBeFalsy();
			expect(_b[2] == "pineapple").toBeTruthy();
			expect(_b).toHaveLength(3);
			expect(_b).toContain("apple");
			
			var _c = {testKey: "test"};
			expect(_c).toHaveLength(1);
			expect(_c.testKey).toHaveLength(4);
			expect(_c).toHaveProperty("testKey");
			expect(_c).toHaveProperty("testKey", "test");
			
			var _d = 5;
			expect(_d).toBeGreaterThan(_a);
			expect(_d).toBeGreaterThanOrEqual(5);
			expect(_a).toBeLessThan(_d);
			expect(_a).toBeLessThanOrEqual(4);
			
			expect(_a).never().toBe(5);
			
			var _addNumbers = function (_a, _b) {
				if (!_a || !_b || !(is_real(_a) && is_real(_b))) return;
				
				return _a + _b;
			};
			expect(_addNumbers, [1, 1]).toHaveReturned();
			expect(_addNumbers, [1, 1]).toHaveReturnedWith(2);
			expect(_addNumbers).toHaveReturnedWith(undefined);
			expect(_addNumbers, [1]).toHaveReturnedWith(undefined);
			expect(_addNumbers, ["1", 2]).toHaveReturnedWith(undefined);
			expect(_addNumbers, ["1", "2"]).toHaveReturnedWith(undefined);
		});
		
		// This one test multiple cases provided as a 2D array
		// You can use the arguments in the name as if you were using string_format()
		each("Should {0} + {1} be {2}. (Multiple cases test)", function(_arg1, _arg2, _arg3) {
			expect(_arg1 + _arg2).toBe(_arg3);
		},
		[
			[1, 1, 2],
			[5, 5, 10],
			[3, 6, 9],
			[-5, 5, 0]
		]);
	});
	
	describe("GameMaker's Testing Library - Demo - Suite 1 - Describe 2", function() {
		// This should create and test an instance
		// test() is another way to call to call the it() function
		test("Should create an instance, wait, check alive timer and destruction.", function() {
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
		
		// This should create an instance and check key press time
		it("Should create an instance and check key press times", function () {
			var _inst = create(0, 0, o_gmtl_demo_timer);
			
			expect(_inst).toHaveProperty("timer_key_hold", 0);
			
			// Simulate a press
			simulateKeyPress(ord("A"));
			simulateEvent(ev_step, ev_step_normal);
			expect(_inst).toHaveProperty("timer_key_hold", 1);
			
			// Simulate a release
			simulateKeyRelease(ord("A"));
			simulateEvent(ev_step, ev_step_normal);
			expect(_inst).toHaveProperty("timer_key_hold", 0);
			
			instance_destroy(_inst);
		});
		
		// This should create an instance and check key hold time
		it("Should create an instance and check key hold time", function () {
			var _inst = create(0, 0, o_gmtl_demo_timer);
			
			expect(_inst).toHaveProperty("timer_key_hold", 0);
			
			// Simulate a hold and release
			simulateKeyHold(ord("A"));
			simulateFrameWait(10);	// Perform all common frame events to all instances for 10 frames
			expect(_inst.timer_key_hold).toBe(10);

			simulateKeyRelease(ord("A"));
			simulateFrameWait();	// Perform all events on all instances for 1 frame after release
			expect(_inst.timer_key_hold).toBe(0);
			
			instance_destroy(_inst);
		});
		
		// This will create an instance and check gamepad button hold time
		it("Should create an instance and check gamepad button events", function () {
			var _inst = create(0, 0, o_gmtl_demo_timer);
			
			expect(_inst).toHaveProperty("timer_gamepad_button_hold", 0);
			
			// Simulate a hold and release
			simulateGamepadButtonHold(0, gp_face1);
			simulateFrameWait(10);
			expect(_inst.timer_gamepad_button_hold).toBe(10);

			simulateGamepadButtonRelease(0, gp_face1);
			simulateFrameWait();
			expect(_inst.timer_gamepad_button_hold).toBe(0);
			
			instance_destroy(_inst);
		});
		
		// This will test mouse events, press, hold and release buttons should do different actions
		it("Should create an object and test mouse events", function () {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			
			// Check variables are initialized correctly
			expect(_inst.timer_click_hold).toBe(0);
			expect(_inst.times_clicked_inside).toBe(0);
			expect(_inst.times_clicked_outside).toBe(0);

			// Do a few clicks inside
			repeat (3) {
				simulateMouseClickPress(mb_left, _inst.x + irandom_range(0, 16), _inst.y + irandom_range(0, 16));
				simulateFrameWait(1);
				simulateMouseClickRelease(mb_left);
			}
			expect(_inst.times_clicked_inside).toBeEqual(3);
			
			simulateMouseClickPress(mb_right, _inst.x + 8, _inst.y + 8);
			simulateFrameWait(1);
			simulateMouseClickRelease(mb_right);
			expect(_inst.times_clicked_inside).toBeLessThan(3);
			
			// Do clicks outside
			repeat (10) {
				simulateMouseClickPress(mb_left, 0, 0);
				simulateFrameWait(1);
				simulateMouseClickRelease(mb_left);
			}
			expect(_inst.times_clicked_outside).toBeEqual(10);
			
			// Hold click
			simulateMouseClickHold(mb_middle, _inst.x + 1, _inst.y + 1);
			simulateFrameWait(15);
			expect(_inst.timer_click_hold).toBeEqual(15);
			
			instance_destroy(_inst);
		});
	

	});
});
	
suite(function() {
	section("GameMaker's Testing Library - Demo - Suite 2 - Describe 1", function() {
		// This test should be skipped because of using "skip()" function
		skip("Should be skipped no matter what", function () {
			obj_unexistent = -1;
			create(0, 0, obj_unexistent);	// This should fail if test were not skipped
		});
		
		// This test should fail because object doesn't exists
		it("Should fail", function() {
			var _inst = create(0, 0, obj_unexistent);
			instance_destroy(_inst);
		});
		
		// This test should be skipped since last test in the describe event failed.
		// You can make this test pass if you move it before the failed test.
		it("Should be skipped after suite failure", function() {
			show_message_async("This should never be seen :)");
		});
	});
});

suite(function() {
	describe("GameMaker's Testing Library - Demo - Suite 3 - Describe 1", function () {
		it("Should create a time source, and successfully start and execute it", function () {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			expect(_inst.timer_test_value).toBeEqual(0);
			
			// Creates a new timesource and starts
			var _new_timesource = simulateTimeSource(time_source_game, 5, time_source_units_frames, function(_inst) {
				// Modify the test value
				_inst.timer_test_value = 100;
			}, [_inst]);
			_new_timesource.start();
			
			simulateFrameWait(5);
			expect(_inst.timer_test_value).toBeEqual(100);
			
			instance_destroy(_inst);
		});
	
		it("Should create a time source, and successfully start and stop it before callback execution", function () {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			expect(_inst.timer_test_value).toBeEqual(0);
			
			// Creates a new timesource and starts
			var _new_timesource = simulateTimeSource(time_source_game, 5, time_source_units_frames, function(_inst) {
				// Modify the test value
				_inst.timer_test_value = 100;
			}, [_inst]);
			_new_timesource.start();
			
			simulateFrameWait(3);
			
			// Stops before execution
			_new_timesource.stop();
			
			simulateFrameWait(2);
			
			// Value should keep being the same initial value
			expect(_inst.timer_test_value).toBeEqual(0);
			
			instance_destroy(_inst);
		});
		
		it("Should create a time source, and successfully pause and resume it", function () {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			expect(_inst.timer_test_value).toBeEqual(0);
			
			// Creates a new timesource and starts
			var _new_timesource = simulateTimeSource(time_source_game, 5, time_source_units_frames, function(_inst) {
				// Modify the test value
				_inst.timer_test_value = 100;
			}, [_inst]);
			_new_timesource.start();
			
			simulateFrameWait(3);
			
			// Pause it before execution
			_new_timesource.pause();
			
			// Wait 100 frames before resuming. Value should still remain the same
			simulateFrameWait(100);
			expect(_inst.timer_test_value).toBeEqual(0); 
			
			// Resume it after 100 frames, it should still need 2 frames before execution
			_new_timesource.resume();
			
			simulateFrameWait(2);
			
			// Value should be changed after resume
			expect(_inst.timer_test_value).toBeEqual(100);
			
			instance_destroy(_inst);
		});
		
		it("Should create a time source, and successfully destroy it, and do not execute event", function () {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			expect(_inst.timer_test_value).toBeEqual(0);
			
			// Creates a new timesource and starts
			var _new_timesource = simulateTimeSource(time_source_game, 5, time_source_units_frames, function(_inst) {
				// Modify the test value
				_inst.timer_test_value = 100;
			}, [_inst]);
			_new_timesource.start();
			
			simulateFrameWait(3);
			
			// Destroys the timesource
			_new_timesource.destroy();
			
			// Timesource should not be in inside the timesources array
			var _ts_in_array = false;
			var _all_ts_len = array_length(gmtl_timesources);
			for (var i = 0; i < _all_ts_len; i++) {
				if (gmtl_timesources[i].__internal_id == _new_timesource.__internal_id) {
					_ts_in_array = true;
					break;
				}
			}
			expect(_ts_in_array).toBeFalsy();
			
			// Wait 2 more frames o expect execution (should not execute)
			simulateFrameWait(2);
			
			// Value should keep being the same initial value
			expect(_inst.timer_test_value).toBeEqual(0);
			
			instance_destroy(_inst);
		});
		
		it("Should simulate a call_later() and successfully execute the callback", function () {
			expect(variable_global_get("__gmtl_demo_internal_value")).toBeEqual(undefined);
			
			// Creates a new timesource and starts
			simulateCallLater(10, time_source_units_frames, function() {
				global.__gmtl_demo_internal_value = 33;
			});
			simulateFrameWait(10);
			expect(variable_global_exists("__gmtl_demo_internal_value")).toBeTruthy();
			expect(global.__gmtl_demo_internal_value).toBeEqual(33);
		});
		
		describe("A describe inside another describe.", function () {
			it("This should always pass", function () {
				expect(1).toBeEqual(1);
			});

			it("This should always fail", function () {
				expect(1 + 2).toBeEqual(5);
			});
		});
	});
});

suite(function() {
	describe("Nested beforeEach - given", function() {
		a = [];

		beforeEach(function() {
			array_push(a, 1);
		});

		describe("when", function() {
			beforeEach(function() {
				array_push(a, 2);
			});

			it("then - should execute all ancestor beforeEach hooks in order", function() {
				expect(a).toBeEqual([1, 2]);
			});
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - beforeEach resets state per test", function() {
		counter = 0;

		beforeEach(function() {
			counter = 0;
		});

		it("counter starts at 0", function() {
			expect(counter).toBe(0);
		});

		it("counter incremented once is 1", function() {
			counter++;
			expect(counter).toBe(1);
		});

		it("counter still starts at 0 (beforeEach reset)", function() {
			expect(counter).toBe(0);
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - afterEach runs after each test", function() {
		log = [];

		afterEach(function() {
			array_push(log, "after");
		});

		it("first test - log is empty before afterEach runs", function() {
			expect(log).toBeEqual([]);
		});

		it("second test - log has one 'after' from previous test", function() {
			expect(log).toBeEqual(["after"]);
		});

		it("third test - log has two 'after' entries", function() {
			expect(log).toBeEqual(["after", "after"]);
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - beforeAll and afterAll run once", function() {
		setup_count = 0;
		teardown_count = 0;

		beforeAll(function() {
			setup_count++;
		});

		afterAll(function() {
			teardown_count++;
		});

		it("setup_count is 1 on first test", function() {
			expect(setup_count).toBe(1);
		});

		it("setup_count is still 1 on second test (beforeAll ran once)", function() {
			expect(setup_count).toBe(1);
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - all four combined", function() {
		order = [];

		beforeAll(function() {
			array_push(order, "beforeAll");
		});

		beforeEach(function() {
			array_push(order, "beforeEach");
		});

		afterEach(function() {
			array_push(order, "afterEach");
		});

		it("test1 - order is: beforeAll, beforeEach, test1", function() {
			array_push(order, "test1");
			expect(order).toBeEqual(["beforeAll", "beforeEach", "test1"]);
		});

		it("test2 - order accumulates correctly across tests", function() {
			array_push(order, "test2");
			expect(order).toBeEqual([
				"beforeAll",
				"beforeEach", "test1", "afterEach",
				"beforeEach", "test2",
			]);
		});

		it("test3 - afterEach ran after test2, beforeEach ran before test3", function() {
			array_push(order, "test3");
			expect(order).toBeEqual([
				"beforeAll",
				"beforeEach", "test1", "afterEach",
				"beforeEach", "test2", "afterEach",
				"beforeEach", "test3",
			]);
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - nested beforeEach and afterEach combined", function() {
		log = [];

		beforeEach(function() {
			array_push(log, "outer-before");
		});

		afterEach(function() {
			array_push(log, "outer-after");
		});

		describe("inner describe", function() {
			beforeEach(function() {
				array_push(log, "inner-before");
			});

			afterEach(function() {
				array_push(log, "inner-after");
			});

			it("hooks fire in correct order: outer-before, inner-before, test, inner-after, outer-after", function() {
				array_push(log, "test");
				expect(log).toBeEqual(["outer-before", "inner-before", "test"]);
			});

			it("second test sees previous afterEach entries then its own setup", function() {
				array_push(log, "test2");
				expect(log).toBeEqual([
					"outer-before", "inner-before", "test", "inner-after", "outer-after",
					"outer-before", "inner-before", "test2",
				]);
			});
		});
	});
});

suite(function() {
	describe("Lifecycle hooks - nested beforeAll scoped per describe", function() {
		outer_init = 0;

		beforeAll(function() {
			outer_init = 10;
		});

		it("outer beforeAll sets outer_init to 10", function() {
			expect(outer_init).toBe(10);
		});

		describe("inner describe with its own beforeAll", function() {
			inner_init = 0;

			beforeAll(function() {
				inner_init = 99;
			});

			it("inner beforeAll sets inner_init to 99", function() {
				expect(inner_init).toBe(99);
			});

			it("outer_init still 10 inside inner describe", function() {
				expect(outer_init).toBe(10);
			});
		});
	});
});

suite(function() {
	describe("toThrow - function throws any error", function() {
		throwing_fn = function() {
			throw { message: "something went wrong" };
		};

		safe_fn = function() {
			return 42;
		};

		it("should detect any throw", function() {
			expect(throwing_fn).toThrow();
		});

		it("should detect throw with matching message substring", function() {
			expect(throwing_fn).toThrow("something went wrong");
		});

		it("should fail when message does not match", function() {
			expect(throwing_fn).never().toThrow("different message");
		});

		it("should fail when function does not throw", function() {
			expect(safe_fn).never().toThrow();
		});

		it("should pass with args forwarded to the throwing function", function() {
			var _fn_with_args = function(_x) {
				if (_x < 0) throw { message: "negative value" };
			};
			expect(_fn_with_args, [-1]).toThrow("negative value");
		});
	});
});

suite(function() {
	describe("spy - toHaveBeenCalled / toHaveBeenCalledTimes / toHaveBeenCalledWith", function() {
		spy_add    = function(_a, _b) { return _a + _b; };
		spy_logger = function(_msg) { /* side-effect */ };

		it("spy detects function was called", function() {
			var _s = spy(spy_add);
			_s.call([1, 2]);
			expect(_s).toHaveBeenCalled();
		});

		it("spy tracks call count correctly", function() {
			var _s = spy(spy_add);
			_s.call([1, 2]);
			_s.call([3, 4]);
			_s.call([5, 6]);
			expect(_s).toHaveBeenCalledTimes(3);
		});

		it("spy detects specific arguments", function() {
			var _s = spy(spy_logger);
			_s.call(["hello"]);
			_s.call(["world"]);
			expect(_s).toHaveBeenCalledWith(["hello"]);
			expect(_s).toHaveBeenCalledWith(["world"]);
		});

		it("spy.never() passes when function was not called", function() {
			var _s = spy(spy_add);
			expect(_s).never().toHaveBeenCalled();
		});

		it("spy.reset() clears call history", function() {
			var _s = spy(spy_add);
			_s.call([1, 2]);
			_s.reset();
			expect(_s).never().toHaveBeenCalled();
			expect(_s).toHaveBeenCalledTimes(0);
		});

		it("spy forwards return value from wrapped function", function() {
			var _s = spy(spy_add);
			var _result = _s.call([10, 5]);
			expect(_result).toBe(15);
		});
	});
});

suite(function() {
	describe("simulateAsyncEvent - HTTP async event", function() {
		it("should fire async HTTP event and read async_load data", function() {
			var _inst = create(0, 0, o_gmtl_demo_async);

			// Fake an HTTP response: status 0 = success, result = JSON string
			simulateAsyncEvent(async_web, {
				status: 0,
				result: "{\"message\":\"ok\"}",
			}, _inst);

			// -999 = event fired but key missing, -1 = event never fired
			expect(_inst.http_status).toBe(0);
			expect(_inst.http_result).toBe("{\"message\":\"ok\"}");

			instance_destroy(_inst);
		});

		it("should fire async HTTP event with error status -2", function() {
			var _inst = create(0, 0, o_gmtl_demo_async);

			simulateAsyncEvent(async_web, {
				status: -2,
				result: "",
			}, _inst);

			expect(_inst.http_status).toBe(-2);

			instance_destroy(_inst);
		});
	});
});

suite(function() {
	describe("simulateAsyncEvent - Save/Load async event", function() {
		it("should fire async save event and read filename and status", function() {
			var _inst = create(0, 0, o_gmtl_demo_async);

			simulateAsyncEvent(async_save_load, {
				status:   1,
				filename: "save_slot_1.dat",
			}, _inst);

			expect(_inst.save_status).toBe(1);
			expect(_inst.save_filename).toBe("save_slot_1.dat");

			instance_destroy(_inst);
		});
	});
});


// Coverage demo - enable gmtl_show_coverage in GMTL_definitions to see the report
// coverage_uncalled_function() is intentionally never tested - it shows as uncovered
suite(function() {
	describe("Coverage demo - math functions", function() {
		it("coverage_add returns correct sum", function() {
			expect(coverage_add, [3, 4]).toHaveReturnedWith(7);
		});

		it("coverage_subtract returns correct difference", function() {
			expect(coverage_subtract, [10, 3]).toHaveReturnedWith(7);
		});

		it("coverage_multiply returns correct product", function() {
			expect(coverage_multiply, [4, 5]).toHaveReturnedWith(20);
		});

		it("coverage_divide returns correct quotient", function() {
			expect(coverage_divide, [10, 2]).toHaveReturnedWith(5);
		});

		it("coverage_divide returns undefined when dividing by zero", function() {
			expect(coverage_divide, [5, 0]).toHaveReturnedWith(undefined);
		});

		it("coverage_clamp clamps value within range", function() {
			expect(coverage_clamp, [15, 0, 10]).toHaveReturnedWith(10);
		});

		it("coverage_is_even correctly identifies even numbers", function() {
			expect(coverage_is_even, [4]).toHaveReturnedWith(true);
			expect(coverage_is_even, [7]).toHaveReturnedWith(false);
		});
	});
});

suite(function() {
	describe("Coverage demo - string and array functions", function() {
		it("coverage_string_reverse reverses a string", function() {
			expect(coverage_string_reverse, ["hello"]).toHaveReturnedWith("olleh");
		});

		it("coverage_array_sum sums all elements", function() {
			expect(coverage_array_sum, [[1, 2, 3, 4, 5]]).toHaveReturnedWith(15);
		});

		it("coverage_fibonacci returns correct values", function() {
			expect(coverage_fibonacci, [0]).toHaveReturnedWith(0);
			expect(coverage_fibonacci, [1]).toHaveReturnedWith(1);
			expect(coverage_fibonacci, [7]).toHaveReturnedWith(13);
		});
	});
});

// Regression - timesource mocking scope
// Guards the regression reported in the GitHub issue: timesources created by game / 3rd-party
// code during the boot window were being silently mocked (returned unusable structs that
// never ticked and were unknown to time_source_exists). Mocking must be scoped to the
// window where suites are actually executing (gmtl_is_running), and time_source_exists
// must recognize mocked timesources.
suite(function() {
	describe("Regression - timesource mocking is scoped to the test run", function() {
		// Issue repro: the exact symptom the user hit - time_source_exists() returning
		// false for a freshly created/started timesource.
		it("time_source_exists() recognizes a mocked timesource through its lifecycle", function() {
			var _ts = time_source_create(time_source_game, 2, time_source_units_seconds, show_debug_message, ["Hello World"], -1);
			expect(time_source_exists(_ts)).toBeTruthy();	// exists after creation

			time_source_start(_ts);
			expect(time_source_exists(_ts)).toBeTruthy();	// exists after starting

			time_source_destroy(_ts);
			expect(time_source_exists(_ts)).toBeFalsy();	// gone after destroy
		});

		// End-to-end through the PUBLIC time_source_create / time_source_start macros
		// (not simulateTimeSource) so the mock create+start path is exercised.
		it("time_source_create() + time_source_start() fire the callback during simulated frames", function() {
			var _inst = create(100, 100, o_gmtl_demo_timer);
			expect(_inst.timer_test_value).toBeEqual(0);

			var _ts = time_source_create(time_source_game, 5, time_source_units_frames, function(_inst) {
				_inst.timer_test_value = 100;
			}, [_inst], 1);
			time_source_start(_ts);

			simulateFrameWait(5);
			expect(_inst.timer_test_value).toBeEqual(100);

			instance_destroy(_inst);
		});

		// PUBLIC call_later macro should be mocked and fire during simulated frames too.
		it("call_later() is mocked and fires during simulated frames", function() {
			global.__gmtl_reg_call_later = 0;
			call_later(10, time_source_units_frames, function() {
				global.__gmtl_reg_call_later = 77;
			});

			simulateFrameWait(10);
			expect(global.__gmtl_reg_call_later).toBeEqual(77);
		});

		// The core fix: OUTSIDE the test-run window the mock must delegate to the real
		// engine, so game / 3rd-party (Input, Scribble, ...) timesources work normally.
		// We temporarily flip the internal running flag to emulate boot / normal gameplay.
		it("timesources created outside the test-run window are REAL, not mocked", function() {
			var _prev_running = gmtl_internal.running;
			gmtl_internal.running = false;
			try {
				var _ts = time_source_create(time_source_game, 1, time_source_units_seconds, function() {}, [], 1);

				// Real engine returns a numeric id, not a mocked GMTL_TimeSource struct.
				expect(is_struct(_ts)).toBeFalsy();

				// ...and the real engine recognizes it as existing.
				expect(time_source_exists(_ts)).toBeTruthy();

				time_source_destroy(_ts);
			} finally {
				// Always restore so a failure here cannot leak into other tests.
				gmtl_internal.running = _prev_running;
			}
		});
	});
});
