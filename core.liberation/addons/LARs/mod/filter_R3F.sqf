// Add R3F Weapons

if ( GRLIB_R3F_enabled ) then {
	GRLIB_R3F_blacklist = [
		"R3F_securite_mag",
		"R3F_securite_fn_mag"
	];

	// Weapons + Equipements (uniforme, etc..)
	(
		"
		((configName _x) select [0,4]) == 'R3F_' &&
		!((configName _x) in GRLIB_R3F_blacklist) &&
		!((configName _x) in GRLIB_blacklisted_from_arsenal)
		"
		configClasses (configfile >> "CfgWeapons" )
	) apply { GRLIB_whitelisted_from_arsenal pushback (configName _x) } ;

	// Others object (bagpack, etc..)
	(
		"
		((configName _x) select [0,4]) == 'R3F_' &&
		!((configName _x) in GRLIB_R3F_blacklist) &&
		!((configName _x) in GRLIB_blacklisted_from_arsenal) &&
		( (configName _x) find '_Bag' == -1 )
		"
		configClasses (configfile >> "CfgVehicles" )
	) apply { GRLIB_whitelisted_from_arsenal pushback (configName _x) } ;

	// Glasses
	(
		"
		((configName _x) select [0,4]) == 'R3F_' &&
		!((configName _x) in GRLIB_R3F_blacklist) &&
		!((configName _x) in GRLIB_blacklisted_from_arsenal)
		"
		configClasses (configfile >> "CfgGlasses" )
	) apply { GRLIB_whitelisted_from_arsenal pushback (configName _x) } ;

	// Magazines
	(
		"
		((configName _x) select [0,4]) == 'R3F_' &&
		(configName _x) find '_Tracer' < 0 &&
		!((configName _x) in GRLIB_R3F_blacklist) &&
		!((configName _x) in GRLIB_blacklisted_from_arsenal)
		"
    	configClasses (configfile >> "CfgMagazines")
	) apply { GRLIB_whitelisted_from_arsenal pushback (configName _x)} ;

};
