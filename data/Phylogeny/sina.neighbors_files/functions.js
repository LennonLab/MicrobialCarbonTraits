/**
 * SILVA tool functions that are used globally
 */
Ext.define('Silva.functions', {
    statics: {
        /**
         * wraps the given params object keys with the
         * 'tx_pmtree_pi1' tag to make typo3 pass it
         * through to the pmtree plugin.
         *
         * @param params
         */
        wrapParams: function (params) {
            var key,
                nr,
                clone = Ext.clone(params);
            for (key in clone) {
                if (clone.hasOwnProperty(key)) {
                    params['tx_pmtree_pi1[' + key + ']'] = params[key];
                    delete params[key];
                }
            }
        },
        /**
         * A method to transpose matrices (2D arrays). The given matrix will be returned transposed.
         *
         * @param matrix The matrix that shall be transposed
         * @return {Array} the transposed matrix
         */
        transpose: function (matrix) {
            Ext.log({
                msg: "Silva.functions.transpose(): START - given matrix:",
                dump: matrix
            });
            var height = matrix.length,
                width = 0,
                x,
                y,
                transposed = [];
            //check maximum width
            for (x = 0; x < height; x++) {
                if (matrix[x] instanceof Array) {
                    if (matrix[x].length > width) {
                        width = matrix[x].length;
                    }
                } else {
                    matrix[x] = [];
                }
            }
            //make every matrix the same width
            for (x = 0; x < height; x++) {
                for (y = 0; y < width; y = y + 1) {
                    if (!matrix[x][y]) {
                        matrix[x][y] = "";
                    }
                }
            }
            for (x = 0; x < width; x++) {
                transposed[x] = [];
                for (y = 0; y < height; y++) {
                    transposed[x][y] = matrix[y][x];
                }
            }
            Ext.log({
                msg: "Silva.functions.transpose(): END - returning matrix:",
                dump: transposed
            });
            return transposed;
        },

        /**
         * method to solve ambiguous bases in a single sequence and returns an list array
         * of the solved sequences. The second argument specifies the maximum number of
         * sequences, if the max value is crossed null gets returned. If the max value
         * is zero there will be no limit.
         *
         * @param sequence the sequence to solve the ambiguous bases from.
         * @param max an int value of the maximum allowed solved sequences. 0 will allow unlimited.
         * @return null if the sequence is solved in more sequences than the specified
         * max value. Otherwise an array list is returned with the solved sequences
         * containing no more ambiguous bases.
         */
        solveAmbiguous: function (sequence, max) {
            Ext.log("Silva.functions.solveAmbiguous(): START");
            sequence = String(sequence).toUpperCase();
            //when more sequences than "max" are detected null is returned
            var result,
                iupac = {'R': ['A', 'G'], 'Y': ['C', 'T'], 'M': ['A', 'C'],
                    'K': ['G', 'T'],      'W': ['A', 'T'], 'S': ['C', 'G'],
                    'B': ['C', 'G', 'T'], 'D': ['A', 'G', 'T'],
                    'H': ['A', 'C', 'T'], 'V': ['A', 'C', 'G'],
                    'N': ['A', 'C', 'G', 'T'] },
                sequenceAmbiguous = sequence.match(/[RYMKWSBDHVN]/g), //check if ambiguous are present
                sequences = [sequence], //create array with sequence in it
                left,
                right,
                pointerPosition = -1,
                resultArrayPointer = 0,
                ambiguousBasePosition,
                amb,
                rep;
            //none are present
            if (sequenceAmbiguous === null) {
                Ext.log("Silva.functions.solveAmbiguous(): END - no ambiguous bases found.");
                return [sequence];
            }
            do {
                pointerPosition++;
                ambiguousBasePosition = String(sequences[pointerPosition]).search(/[RYMKWSBDHVN]{1}/);
                if (ambiguousBasePosition >= 0) {
                    resultArrayPointer = pointerPosition + 1;
                    //check if sequences is solved into more sequences than allowed
                    if (max > 0 && sequences.length - resultArrayPointer > max) {
                        Ext.log("Silva.functions.solveAmbiguous(): END - input sequence where solved into more than allowed by max value " + max + ".");
                        return null;
                    }
                    //get left part of sequence of the current ambiguous base
                    if (ambiguousBasePosition > 0) {
                        left = String(sequences[pointerPosition]).substring(0, ambiguousBasePosition);
                    } else {
                        left = "";
                    }
                    //get right part of sequence of the current ambiguous base
                    if (ambiguousBasePosition + 1 !== sequences[pointerPosition].length) {
                        right = String(sequences[pointerPosition]).substring(ambiguousBasePosition + 1);
                    } else {
                        right = "";
                    }
                    //solve current ambiguous base and add them to the sequence array
                    amb = String(sequences[pointerPosition]).substring(ambiguousBasePosition, ambiguousBasePosition + 1);
                    for (rep = 0; rep < iupac[amb].length; ++rep) {
                        sequences.push(left + iupac[amb][rep] + right);
                    }
                }
            } while (pointerPosition !== sequences.length - 1);
            result = sequences.slice(resultArrayPointer);
            Ext.log("Silva.functions.solveAmbiguous(): END - all ambiguous bases solved successfully.", result);
            return result;
        },

        /**
         * Builds an url from an parameter object.
         * For example the parameter object of:
         * { type: 'testprime', action: 'export' }
         * will return url:
         * "/WS/?tx_pmtree_pi1[type]=testprime&tx_pmtree_pi1[action]=export"
         *
         * @param params An Object which contains key value pairs.
         * @return {string} The build URL
         */
        buildUrl: function (params) {
            Ext.log("Silva.functions.buildUrl(): START");
            var url = Silva.Application.AJAXURL,
                nr = 0,
                template = "tx_pmtree_pi1[##KEY##]=##VALUE##",
                param;
            if (!Ext.isObject(params)) {
                Ext.log({
                    level: 'error',
                    msg: "Silva.functions.buildUrl(): given argument is no object",
                    dump: params
                });
            }
            for (param in params) {
                //"/WS/?tx_pmtree_pi1[type]=testprime&tx_pmtree_pi1[action]=exportHitlistToCsv&tx_pmtree_pi1[jobid]="+window.params.jobid;
                if (params.hasOwnProperty(param)) {
                    if (!Ext.isPrimitive(params[param])) {
                        Ext.log({
                            level: 'error',
                            msg: 'Silva.functions.buildUrl(): parameter value is not primitive, dumped [key, value]',
                            dump: [param, params[param]]
                        });
                    } else {
                        nr++;
                        if (nr === 1) {
                            url += "?";
                        } else {
                            url += "&";
                        }
                        url += template.replace('##KEY##', param).replace('##VALUE##', params[param]);
                    }
                }
            }
            Ext.log("Silva.functions.buildUrl(): END, returning: '" + url + "'");
            return url;
        }
    }
});
