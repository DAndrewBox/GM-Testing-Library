
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
			expect(_addNumbers, [1, 1]).toHaveReturnedWith(3);
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
			}
			simulateMouseClickRelease(mb_left);
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