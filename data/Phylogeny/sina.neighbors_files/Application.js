/**
 * An SILVA application class with some extended functionalities.
 */
Ext.define('Silva.Application', {
    extend: 'Ext.app.Application',
    statics: {
        AJAXURL: '/WS/',
        BASEURL: {
            align: '/aligner/',
            testprobe: '/search/testprobe/',
            testprime: '/search/testprime/',
            download: '/download/',
            browser: '/browser/'
        },
        COLORS: {
            blue1: '#1F78B4',      blue2: '#A6CEE3',       blue3: '#54bAEF',
            green1: '#B2DF8A',     green2: '#33A02C',      green3: '#90DB4C',
            orange1: '#FDBF6F',    orange2: '#FF7F00',     orange3: '#FF962E',
            red1: '#DC143C',       red2: '#CD2626',        red3: '#8B1A1A',
            gold1: '#FFD700',      gold2: '#EEC900',       gold3: '#CDAD00',
            yellow1: '#CDCD00',    yellow2: '#EEEE00',     yellow3: '#FFFF00'
        },
        QUICKTIPCONFIG: {
            showDelay: 2000,
            dismissDelay: 10000,
            hideDelay: 0
        }
    },
    constructor: function (config) {
        var me = this;
        me.autoCreateViewPort = false;
        me.appFolder = Ext.Loader.getPath("Silva");
        me.enableQuickTips = true;
        //me.name = config.name;
        /************************************/
        /**VTYPE AND VALIDATOR DEFINITION****/
        /************************************/
        /**
         * This VType makes it possible, that an Formfield that has a Ext.model.Model record which
         * was loaded into the form is validated by it's model validators.
         *
         * The ancestor formpanel has to have a validationMessages.fieldname message which will be
         * shown.
         *
         */
        Ext.apply(Ext.form.field.VTypes, {
            silvaModelValidation: function (value, field) {
                Ext.log("Ext.form.field.VTypes.silvaModelValidation(): START");
                var formField = field.up("form"),
                    form = formField.getForm().updateRecord(),
                    validation = formField.getRecord().validate(),
                    errors = validation.getByField(field.getName()),
                    returnValue = true,
                    message = "",
                    x;
                if (errors.length > 0) {
                    returnValue = false;
                    if (formField.labelMap.validationMessages &&
                            formField.labelMap.validationMessages[errors[0].field + "_" + errors[0].message]) {
                        message = formField.labelMap.validationMessages[errors[0].field + "_" + errors[0].message];
                    } else {
                        Ext.log({
                            level: 'warn',
                            msg: "Ext.form.field.Vtypes.silvaModelValidation(): missing validation message " +
                                "for key 'validationMessages." + errors[0].field + "_" + errors[0].message + "'",
                            dump: errors
                        });
                        for (x = 0; x < errors.length; x++) {
                            message += errors[x].message;
                            if (x + 1 < errors.length) {
                                message += " ";
                            }
                        }
                    }
                    Ext.form.field.VTypes.silvaModelValidationText = message;
                }
                Ext.log("Ext.form.field.VTypes.silvaModelValidation(): END");
                return returnValue;
            },
            silvaModelValidationText: ""
        });
        /**
         * define custom model validators.
         */
        Ext.apply(Ext.data.validations, {
            /**
             * regular expressions for validation
             */
            nucleotideReg: (/^[ATCGURYMKWSBDHVN]+$/i),
            /**
             * Validates an Integer value. Optional parameters
             * are the min and max value.
             *
             * The step parameter
             */
            int: function (config, value) {
                var result = true;
                if (!Ext.isNumber(value)) {
                    result = false;
                }
                value = Number(value);
                if (config.min) {
                    result = value >= config.min;
                }
                if (config.max) {
                    result = value <= config.max;
                }
                return result;
            },
            intMessage: 'integer',
            /**
             * Validates an Float value. Optional parameters
             * are the min, the max and the step value.
             *
             * When an step parameter is passed, the value
             * has to be divisible by the step value with
             * a rest of zero.
             */
            float: function (config, value) {
                var result = true,
                    m = 100000; // the multiplier
                if (!Ext.isNumeric(value)) {
                    result = false;
                }
                value = Number(value);
                if (config.step) {
                    result = (((value * m) % (config.step * m)) / m) === 0;
                }
                if (config.min) {
                    result = value >= config.min;
                }
                if (config.max) {
                    result = value <= config.max;
                }
                return result;
            },
            floatMessage: 'float',
            /**
             * Validates for the length of an value specified
             * by the min and max values.
             */
            length: function (config, value) {
                var min = config.min || 0,
                    max = config.max || 0,
                    result = true;
                if (min > 0 && min > value.length) {
                    result = false;
                }
                if (max > 0 && max < value.length) {
                    result = false;
                }
                return result;
            },
            lengthMessage: 'length',
            /**
             * validates a nucleotide sequence to be in IUPAC standard
             */
            nucleotide: function (config, value) {
                return Ext.data.validations.nucleotideReg.test(value);
            },
            nucleotideMessage: 'nucleotide',
            /**
             * COMMENT ME
             */
            ambiguousNucleotide: function (config, value) {
                var maxSequences = config.maxSequences || 0;
                return Silva.functions.solveAmbiguous(value, maxSequences) !== null;
            },
            ambiguousNucleotideMessage: 'ambiguousNucleotide'
            //ambiguousNucleotideMessage: 'Too many ambiguous bases. Solving the ambiguous bases results into too many sequences.'
        });
        /************************************/

        /***********************************/
        Ext.Ajax.on("beforerequest", function (conn, options) {
            var key,
                msg,
                params = options.params;
            if (params) {
                /* if it's an control call mask the page to prevent the user from parallel actions */
                if (options.silvaControl) {
                    msg = options.silvaControlMessage || "please wait...";
                    Ext.getBody().mask(msg);
                }
                /* wrap typo3 plugin name around all parameters */
                Silva.functions.wrapParams(params);
            }
        });
        Ext.Ajax.on("requestcomplete", function (conn, response, options) {
            try {
                var res = Ext.JSON.decode(response.responseText, false);
                if (res.success === false) {
                    Ext.log({
                        level: 'warn',
                        msg: "Silva.Application.Ajax.onRequestComplete(): " +
                            "ajax call failed. response: ",
                        dump: [conn, response, options]
                    });
                }
                if (options.silvaControl) {
                    Ext.getBody().unmask();
                }
            } catch (err) {
                Ext.getBody().unmask();
                Ext.MessageBox.alert("error", "Server connection error, please try again.");
            }
        });
        me.callParent(arguments);
    },
    /**
     * adds a handler that is called when the databasechange event
     * is fired.
     *
     * @param callbackHandler The callback function that shall be executed.
     * @param scope The scope of the callback function defines where "this" points to.
     */
    addChangedDatabaseHandler: function (callbackHandler, scope) {
        scope = scope || this;
        this.on('ChangedDatabase', callbackHandler, scope);
    },
    /**
     * fires the ChangedDatabase event and calls all its handlers.
     *
     * @param source The source object of the event.
     * @param databaseObject Contains: [name, fullname, id, rel, gene]
     */
    fireChangedDatabaseEvent: function (source, databaseObject) {
        Ext.log("Silva.fireChangedDatabaseEvent(): firing event...");
        this.fireEvent('ChangedDatabase', source, databaseObject);
    },
    /**
     * adds a handler that is called when the ChangedCart event
     * is fired.
     *
     * @param callbackHandler The callback function that shall be executed.
     * @param scope The scope of the callback function defines where "this" points to.
     */
    addChangedCartHandler: function (callbackHandler, scope) {
        scope = scope || this;
        this.on('ChangedCart', callbackHandler, scope);
    },
    /**
     * fires the ChangedCart event and calls all its handlers.
     *
     * @param source The source object of the event.
     * @param cartObject The cartObject contains: [size,]
     */
    fireChangedCartEvent: function (source, cartObject) {
        Ext.log("Silva.fireChangedCartEvent(): firing event...");
        this.fireEvent('ChangedCart', source, cartObject);
    },
    /**
     * Function where all ajax callbacks come together.
     */
    handleCallback: function (response) {
        var jsn = Ext.JSON.decode(response.responseText);
        Ext.log({ msg: "Silva.handleCallback(): got response: ", dump: response});
        if (jsn.cart) {
            this.fireChangedCartEvent(this, jsn.cart);
        }
    }
});