macro "Auto BC Action Tool - C037T1b09BT9b09C" {
	if (nImages == 0) {
		showStatus("No image open.");
		return;
	}

	imgPath = toLowerCase(getDirectory("image") + getTitle());

	// RDN_seg: full 8-bit scale, no histogram needed
	if (indexOf(imgPath, "rdn_seg") >= 0) {
		setMinAndMax(0, 255);
		showStatus("Display range: 0 to 255");
		return;
	}

	// Determine fixed max from segmentation tag (most specific first)
	maxVal = -1;
	if (indexOf(imgPath, "masksegin") >= 0 || indexOf(imgPath, "mask_seg_in") >= 0) {
		maxVal = 2;
	} else if (indexOf(imgPath, "masksegout") >= 0 || indexOf(imgPath, "mask_seg_out") >= 0) {
		maxVal = 2;
	} else if (indexOf(imgPath, "miathresh") >= 0 || indexOf(imgPath, "mia_thresh") >= 0 ||
	           indexOf(imgPath, "mia") >= 0) {
		maxVal = 2;
	} else if (indexOf(imgPath, "maskseg") >= 0 || indexOf(imgPath, "mask_seg") >= 0 ||
	           indexOf(imgPath, "label") >= 0) {
		maxVal = 3;
	} else if (indexOf(imgPath, "outermask") >= 0 || indexOf(imgPath, "outer_mask") >= 0 ||
	           indexOf(imgPath, "innermask") >= 0 || indexOf(imgPath, "inner_mask") >= 0 ||
	           indexOf(imgPath, "trab") >= 0 || indexOf(imgPath, "seg") >= 0) {
		maxVal = 1;
	}

	// No segmentation tag: use built-in Auto
	if (maxVal == -1) {
		run("Enhance Contrast", "saturated=0.35");
		showStatus("Auto brightness/contrast applied");
		return;
	}

	setMinAndMax(0, maxVal);
	showStatus("Display range: 0 to " + maxVal);
}
