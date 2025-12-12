# just a test. do not use this.
$name_map = @{
	"ValhallaRoom" = "VRoom";
	"ValhallaPlate" = "VPlate";
	"ValhallaVintageVerb" = "VVintageVerb";
	"ValhallaUberMod" = "VUberMod";
	"HoRNetDeeLay_x64" = "HoRNetDeeLay";
}
$prefs_folder = "Cubase 12_64";
$vst3_plugins = $env:appdata + "\Steinberg\" + $prefs_folder + "\Cubase Pro VST3 Cache\vst3plugins.xml"
$vst2_plugins = $env:appdata + "\Steinberg\" + $prefs_folder + "\Vst2xPlugin Infos Cubase.xml"

# backup copy 

[xml]$vst3 = get-content $vst3_plugins
$changed=$false
$vst3.plugins.plugin.class | %{ 
	if ($_.category -eq "Audio Module Class" -or $_.category -eq "Component Controller Class") {  
		if ( $name_map.ContainsKey($_.name)) { 
		$changed=$true
			write-host ("change {0} to {1}" -f $_.name, $name_map[$_.name] )
			$_.name = $name_map[$_.name]
		}; 
	}
}
if ( $changed ) {
	copy-item $vst3_plugins "${vst3_plugins}.backup-$(get-date -format 'yyyymmdd-HHmm')"
	$vst3.save($vst3_plugins)
}



[xml]$vst2 = get-content $vst2_plugins
$changed=$false
 $vst2.SelectNodes("//member[@name='Vst2xPlugInfo']/string[@name='name']") | %{
	if ( $name_map.ContainsKey($_.Value) ) {
		$changed=$true
		write-host ("change {0} to {1}" -f $_.Value, $name_map[$_.Value] )
		$_.Value = $name_map[$_.Value]
	}
}
if ( $changed ) {
	copy-item $vst2_plugins "${vst2_plugins}.backup-$(get-date -format 'yyyymmdd-HHmm')"
	$vst2.save($vst2_plugins)
}
 
