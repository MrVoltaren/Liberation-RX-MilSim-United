if ( isNil "active_sectors" ) then { active_sectors = [] };

while { GRLIB_endgame == 0 } do {
	sleep round (60 + random 150);
	waitUntil {sleep 10; (GRLIB_side_civilian countSide allUnits) < (GRLIB_civilians_amount * 3) };

	private _civveh = objNull;
	private _spawnsector = "";
	private _usable_sectors = [];
	{
		if ( ( ( [ getmarkerpos _x , 1000 , GRLIB_side_friendly ] call F_getUnitsCount ) == 0 ) && ( count ( [ getmarkerpos _x , 3500 ] call F_getNearbyPlayers ) > 0 ) ) then {
			_usable_sectors pushback _x;
		}

	} foreach ((sectors_bigtown + sectors_capture + sectors_factory) - (active_sectors));

	if ( count _usable_sectors > 0 ) then {
		_spawnsector = selectRandom _usable_sectors;

		private _civnumber = 1 + (floor (random 2));
		private _civs = [_spawnsector, _civnumber] call F_spawnCivilians;
		private _grp = group (_civs select 0);

		if ( random 100 > 35 ) then {
			_nearestroad = objNull;
			_max_try = 10;
			while { isNull _nearestroad || _max_try > 0} do {
				_nearestroad = [ [getmarkerpos (_spawnsector), random(100), random(360)] call BIS_fnc_relPos, 200, [] ] call BIS_fnc_nearestRoad;
				_max_try = _max_try - 1;
				sleep 0.5;
			};

			if (!isNull _nearestroad) then {
				private _spawnpos = getpos _nearestroad;
				private _classname = selectRandom civilian_vehicles;
				if ( _classname isKindOf "Air" ) then {
					_civveh = createVehicle [_classname, _spawnpos, [], 0, 'FLY'];
					_civveh setPos (getPosATL _civveh vectorAdd [0, 0, 250]);
					_civveh flyInHeight 250;
				} else {
					if (surfaceIsWater _spawnpos) then {
						_classname = selectRandom boats_names;
					};
					_civveh = _classname createVehicle _spawnpos;
					_civveh setpos _spawnpos;
				};
				(_civs select 0) moveInDriver _civveh;

				_civveh addMPEventHandler ['MPKilled', {_this spawn kill_manager}];
				_civveh addEventHandler ["HandleDamage", { private [ "_damage" ]; if ( side (_this select 3) == GRLIB_side_friendly ) then { _damage = _this select 2 } else { _damage = 0 }; _damage }];
				_civveh addEventHandler ["Fuel", { if (!(_this select 1)) then {(_this select 0) setFuel 1}}];
				[_grp] call add_civ_waypoints;
			};
		};

		if ( local _grp ) then {
			_headless_client = [] call F_lessLoadedHC;
			if ( !isNull _headless_client ) then {
				_grp setGroupOwner ( owner _headless_client );
			};
		};

		waitUntil {
			sleep (30 + (random 30));
			( ( ( { alive _x } count ( units _grp ) ) == 0 ) || ( count ( [ getpos leader _grp , 4000 ] call F_getNearbyPlayers ) == 0 ) )
		};

		if ( count (units _grp) > 0 ) then {
			if ( count ( [ getpos leader _grp , 4000 ] call F_getNearbyPlayers ) == 0 ) then {

				if ( !(isNull _civveh) ) then {
					 if ( { ( alive _x ) && (side group _x == GRLIB_side_friendly ) } count (crew _civveh) == 0 ) then {
						deleteVehicle _civveh
					};
				};

				{ deletevehicle _x } foreach units _grp;
			};
		};
	};

};