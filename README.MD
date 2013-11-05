PhoneGap-iOS-Printing-Plugin
================================================

PhoneGap iOS plugin for printing via Air Print. Remake of (this)[https://github.com/phonegap/phonegap-plugins/tree/master/iOS/PrintPlugin] plugin (I think the repo is dead now). The plugin works with PhoneGap 3.0+ and ARC.

#Installing the plugin

Copy Print.h and Print.m files to your Plugins folder and Print.js file to 'www/js/plugins' folder.

Add js file to your index.html.

    <script type="text/javascript" src="js/plugins/Print.js"></script>

Then add the following code to your config.xml:

	<feature name="Print">
		<param name="ios-package" value="Print" />
		<param name="onload" value="true" />
	</feature>

#Using the plugin
Signature:

    Print.print(html, isPdf, filePath, successCallback, failCallback)

- Html can be null or docuemnt to print
- isPdf false by default. Need to set true if you want to print a pdf
- filePath - string url to a pdf file

For adding new html conten that needs to be printed do the following:

	var html = <h1>Your html content</h1>;
    Print.print( html, function(result) {
        	alert("Printing successful"); }, 
        function(result) {
            if (!result.available) { 
                alert("Printing is not available");
            } else {
                alert(result.error);
            }
    });

Before printing you might want to check the feature's availability:

    Print.isPrintingAvailable( function(result) {
        alert(result.available);
    });

isPrintingAvailable method will return object "{ available: true }" if the printing is working on the device. In other case it will return false;

#License

The MIT License

Copyright (c) 2013 Stas Gorodnichenko, Alex Shmaliy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
