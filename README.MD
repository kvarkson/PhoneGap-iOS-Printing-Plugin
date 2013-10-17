PhoneGap-iOS-Printing-Plugin
================================================

PhoneGap iOS plugin for printing via Air Print.

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

#License

The MIT License

Copyright (c) 2013 Stas Gorodnichenko, Alex Shmaliy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
