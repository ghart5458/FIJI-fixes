# FIJI-fixes
FIJI plugins, macros and patches for FEMR workflows. Written with Claude.  

## Install instructions
### 1. MHD Metadata Reader
Ensures accurate ElementSize/ElementSpacing is retrieved from MHD upon read.  

File: [Fix_MHD_Spacing.js](install/Fix_MHD_Spacing.js)  
Add to `Fiji.app/scripts/Plugins/AutoRun/`.  

### 2. Brightness/Contrast Auto-Adjust
Adds a brightness/contrast (BC) button to the toolbar. Recognizes appropriate range via filename and filepath - e.g., filename containing `OuterMask` automatically adjusts to 0-1. Two steps to install:  
- File: [Auto_BC_Tool.ijm](install/Auto_BC_Tool.ijm)  
    Add to `Fiji.app/macros/`.
- File: [Install_Auto_BC.ijm](install/Install_Auto_BC.ijm)  
    Add to `Fiji.app/macros/AutoRun/`.

## Notes
[Install_Auto_BC.ijm](install/Install_Auto_BC.ijm) requires you to restart FIJI twice so that the tool can be appended to StartupMacros. After that, should run without issue. 