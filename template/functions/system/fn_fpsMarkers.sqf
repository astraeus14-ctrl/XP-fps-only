/*
	XPT_fnc_fpsMarkers
	Author: Superxpdude
	Creates map markers to indicate server and headless client framerates, and unit counts
	
	Parameters:
		Designed to be called in postInit.
		
	Returns: Nothing
*/


// Not to be run on player clients
if (hasInterface and !isServer) exitWith {};
private ["_serverMark"];

private _markerSpacing = 250;

// If running on the server, create the markers themselves.
if (isServer) then {
	_serverMark = createMarker ["fpsmarker_server", [250,_markerSpacing]];
	_serverMark setMarkerType "mil_start";
	_serverMark setMarkerSize [0.7, 0.7];
	_serverMark setMarkerColor "ColorBlue";
	_serverMark setMarkerText "Server: Setup";
	
};

// Spawn the loop (since it needs to run forever)

[] spawn {
	private _fnc_scriptName = "XPT_fnc_fpsMarkers";
	private ["_marker", "_name", "_fps"];
	// Make sure we're editing the correct marker
	switch (true) do {
		case (isServer): {
			_marker = "fpsmarker_server";
			_name = "Server";
		};
	};
		
	// Wait until the mission has started
	sleep 1;
	
	while {true} do {
		_fps = diag_fps;
		_marker setMarkerColor "ColorGREEN";
		if (_fps <= 30) then {_marker setMarkerColor "ColorYELLOW";};
		if (_fps <= 20) then {_marker setMarkerColor "ColorORANGE";};
		if (_fps <= 10) then {_marker setMarkerColor "ColorRED";};
		
		_marker setMarkerText format ["%1: %2 fps | %3 units", _name, (round(_fps*100))/100, {local _x} count allUnits];
		
		// Wait 15 seconds between updates
		sleep 15;
	};
};