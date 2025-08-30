///	@func	GMTL_TimeSource(parent, period, units, callback, args, repetitions, expiryType)
///	@param	{Any}							parent
///	@param	{Real}							period
///	@param	{Constant.TimeSourceUnits}		units
///	@param	{Function}						callback
///	@param	{Array}							args
///	@param	{Real}							reps
///	@param	{Constant.TimeSourceExpiryType}	expiryType
function GMTL_TimeSource(_parent, _period, _units, _callback, _args = [], _reps = 1, _expiry = undefined) constructor {
	__internal_id = current_time;
	/* Time to execute the callback */
	__internal_ts_period = _period * (_units == time_source_units_frames ? 1 : game_get_speed(gamespeed_fps));
	/* The frame count that has been simulated into this timesource */
	__internal_ts_frames = 0;
	/* The current state of the virtual timesource */
	__internal_ts_state = time_source_state_initial;
	/* The callback to be called at period end */
	__internal_ts_callback = _callback;
	/* The callback arguments */
	__internal_ts_args = _args;
	/* The current repetitions executed */
	__internal_ts_reps_current = 0;
	/* The max amount of repetitions to execute */
	__internal_ts_reps_max = _reps == -1 ? infinity : _reps;
	
	/// @func	start()
	function start() {
		__internal_ts_state = time_source_state_active;
		__internal_ts_frames = 0;
		frameCheck();
	}
	
	/// @func	startLater(frames)
	/// @param	{Real}	frames
	/// @desc	Starts the frame check after a defined set of frames. Adds a delay to the start()
	/// @ignore
	function startLater(_frames) {
		__internal_ts_frames = -abs(_frames - 1);
	}
	
	/// @func	stop()
	/// @desc	Hard resets the timesource and stops it.
	function stop() {
		__internal_ts_state = time_source_state_stopped;
		__internal_ts_frames = 0;
		__internal_ts_reps_current = 0;
	}
	
	/// @func	pause()
	/// @desc	Pauses the timesource to not increase frames every frame.
	function pause() {
		__internal_ts_state = time_source_state_paused;
	}
	
	/// @func	resume()
	/// @desc	Resumes an already paused timesource.
	function resume() {
		if (__internal_ts_state == time_source_state_paused) {
			__internal_ts_state = time_source_state_active;
		} else {
			__gmtl_internal_fn_log($"WARNING: Trying to resume a timesource that is not paused. Timesource ID: ${__internal_id}");
		}
	}
	
	/// @func	destroy()
	/// @desc	Destroys the timesource and removes it from the global timesources array to be simulated.
	function destroy() {
		var _all_ts_len = array_length(gmtl_timesources);
		for (var i = 0; i < _all_ts_len; i++) {
			if (is_struct(gmtl_timesources[i]) && gmtl_timesources[i].__internal_id == __internal_id) {
				stop();
				delete gmtl_timesources[i];
			}
		}
		
		gmtl_timesources = array_filter(gmtl_timesources, function (_elem) {
			return is_struct(_elem);
		});
	}
	
	/// @func	frameCheck()
	/// @desc	Internal check for every virtually simulated frame.
	/// @ignore
	function frameCheck() {
		if (__internal_ts_reps_current >= __internal_ts_reps_max) return;
		
		if (__internal_ts_frames < 0) {
			__internal_ts_frames += 1;
			 if (__internal_ts_frames == 0) {
				start();
			}
			return;
		} else if (__internal_ts_frames == round(__internal_ts_period)) {
			script_execute_ext(__internal_ts_callback, __internal_ts_args);
			__internal_ts_frames = 0;
			
			if (__internal_ts_reps_current < __internal_ts_reps_max) {
				__internal_ts_reps_current += 1;
			} else {
				stop();
			}
		} else {
			if (__internal_ts_state != time_source_state_active) return;
			__internal_ts_frames += 1;
		}
	}
}