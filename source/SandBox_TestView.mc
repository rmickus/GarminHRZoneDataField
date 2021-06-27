import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.UserProfile;
import Toybox.WatchUi;

class SandBox_TestView extends WatchUi.DataField {

    hidden var mHeartRate as Numeric;
    hidden var mLabel = "Heart Rate";
    hidden var mHeartRateZones as Array<Number>;
	
    function initialize() {
        DataField.initialize();
        mHeartRate = 0;
        var currSport = UserProfile.getCurrentSport();
    	mHeartRateZones = UserProfile.getHeartRateZones(currSport);
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

        return true;
        
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mHeartRate = info.currentHeartRate as Number;
            } else {
                mHeartRate = 0.0f;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
    	
    	// Set the Background color based on current zone
    	var background = View.findDrawableById("Background");
    	if (mHeartRate < mHeartRateZones[0]) {
    		// Outside Zone 1
    		background.setColor(Graphics.COLOR_WHITE);
		} else if (mHeartRate < mHeartRateZones[1]) {
			// Zone 1
			background.setColor(Graphics.COLOR_LT_GRAY);
		} else if (mHeartRate < mHeartRateZones[2]) {
			// Zone 2
			background.setColor(Graphics.COLOR_BLUE);
		} else if (mHeartRate < mHeartRateZones[3]) {
			// Zone 3
			background.setColor(Graphics.COLOR_GREEN);
		} else if (mHeartRate < mHeartRateZones[4]) {
			// Zone 4
			background.setColor(0xFFA500); // Orange
		} else {
			// Zone 5 or Past Max
			background.setColor(Graphics.COLOR_RED);
		}
    	
    	// Set the foreground color and value
    	var value = View.findDrawableById("value");
		value.setColor(Graphics.COLOR_BLACK);
		value.setText(mHeartRate.format("%d"));
		
		// label also needs to be updated regularly
		var label = View.findDrawableById("label");
		if (label != null) {
			label.setText(mLabel);
			label.setColor(Graphics.COLOR_BLACK);
		}
		
		// Call parent's onUpdate(dc) to redraw the layout
		View.onUpdate(dc);
    }

}
