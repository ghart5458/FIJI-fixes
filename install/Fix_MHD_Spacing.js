// Runs at Fiji startup (scripts/Plugins/AutoRun/).
// Registers a listener that reads ElementSpacing from the .mhd/.mha header
// and applies it to the image as it opens, fixing the built-in reader which
// discards this value and defaults to 1 1 1.

var ImageListener = Java.type('ij.ImageListener');
var ImagePlus     = Java.type('ij.ImagePlus');
var BufferedReader = Java.type('java.io.BufferedReader');
var FileReader     = Java.type('java.io.FileReader');

function readElementSpacing(path) {
    try {
        var reader = new BufferedReader(new FileReader(path));
        var line;
        while ((line = reader.readLine()) !== null) {
            var idx = line.indexOf('=');
            if (idx >= 0 && line.substring(0, idx).trim().toLowerCase() === 'elementspacing') {
                reader.close();
                return line.substring(idx + 1).trim().split(/\s+/).map(parseFloat);
            }
        }
        reader.close();
    } catch (e) {}
    return null;
}

var File = Java.type('java.io.File');

function findMhdPath(fi) {
    var dir  = fi.directory || '';
    var name = fi.fileName  || '';
    if (!name) return null;
    var full  = dir + name;
    var lower = full.toLowerCase();
    // Direct match — header file was recorded in file info.
    if (lower.endsWith('.mhd') || lower.endsWith('.mha')) return full;
    // MetaImage_Reader stores the .raw data file in fi.fileName, not the header.
    // Derive the header path by swapping the extension.
    if (lower.endsWith('.raw')) {
        var base = full.substring(0, full.lastIndexOf('.'));
        var mhd  = base + '.mhd';
        if (new File(mhd).exists()) return mhd;
        var mha  = base + '.mha';
        if (new File(mha).exists()) return mha;
    }
    return null;
}

var fixer = new (Java.extend(ImageListener))({
    imageOpened: function(imp) {
        var fi = imp.getOriginalFileInfo();
        if (!fi) return;
        var mhdPath = findMhdPath(fi);
        if (!mhdPath) return;
        var s = readElementSpacing(mhdPath);
        if (!s) return;
        var cal = imp.getCalibration();
        cal.pixelWidth  = s[0];
        cal.pixelHeight = s.length > 1 ? s[1] : s[0];
        cal.pixelDepth  = s.length > 2 ? s[2] : s[0];
        imp.setCalibration(cal);
    },
    imageClosed:  function(imp) {},
    imageUpdated: function(imp) {}
});

ImagePlus.addImageListener(fixer);
