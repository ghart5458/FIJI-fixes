startupMacros = getDirectory("imagej") + "macros/StartupMacros.fiji.ijm";
toolDef       = getDirectory("imagej") + "macros/Auto_BC_Tool.ijm";

if (!File.exists(toolDef)) exit();

existing = File.openAsString(startupMacros);
if (indexOf(existing, "Auto BC Action Tool") >= 0) exit();

toolCode = File.openAsString(toolDef);
File.append("\n" + toolCode, startupMacros);
showMessage("Auto BC Tool installed. Please restart Fiji.");
