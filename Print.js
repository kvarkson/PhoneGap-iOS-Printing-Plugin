/**
 * Printer Plugin
 * Copyright (c) 2013 Stas Gorodnichenko
 * MIT licensed
 */

var Print =  {

    callbackMap: {},
    callbackIdx: 0,

    /*
     print      - html string or DOM node (if latter, innerHTML is used to get the contents). REQUIRED.
     success    - callback function called if print successful.     {success: true}
     fail       - callback function called if print unsuccessful.  If print fails, {error: reason}. If printing not available: {available: false}
     options    -  {dialogOffset:{left: 0, right: 0}}. Position of popup dialog (iPad only).
     */
    print: function(printHTML, success, fail, options) 
    {
        if (typeof printHTML != 'string'){
            console.log("Print function requires an HTML string. Not an object");
            return;
        }
        //var printHTML = "";
        var dialogLeftPos = 0;
        var dialogTopPos = 0;

        if (options){
            if (options.dialogOffset){
                if (options.dialogOffset.left){
                    dialogLeftPos = options.dialogOffset.left;
                    if (isNaN(dialogLeftPos)){
                        dialogLeftPos = 0;
                    }
                }
                if (options.dialogOffset.top){
                    dialogTopPos = options.dialogOffset.top;
                    if (isNaN(dialogTopPos)){
                        dialogTopPos = 0;
                    }
                }
            }
        }

        args = {}
        args.printHTML = printHTML;
        args.dialogLeftPos = dialogLeftPos;
        args.dialogTopPos = dialogTopPos;
        cordova.exec( null, null, "Print", "print", [args] );
    },

    /*
     * Callback function returns {available: true/false}
     */
    isPrintingAvailable: function(callback) {
        cordova.exec(callback, null, "Print", "isPrintingAvailable");
    }
}