/**
 * The SilvaTaskView is grid that shows the status information of jobs
 * created by the user.
 */
//TODO: what if the joblist is very long? create a page browser!
//TODO: change empty message dependend on the filter that is active on the store
//example: there are no testprobe jobs to show...
Ext.define('Silva.view.grid.JobTaskGrid', {
    extend: 'Silva.view.grid.BaseGrid',
    alias: 'widget.slv-jobtaskgrid',
    config: {
        toolbarHeight: 25,
        // filter parameters allow to show only jobs matching the given jobType / jobId
        filter: {
            jobType: undefined,
            jobId: undefined
        },
        // columns parameter allows to show only given column names (as string array)
        enableColumns: undefined
    },
    labelMap: {
        emptyJobMessage: 'none found...',
        eventAddToCart: 'Adding sequences to your cart...',
        toolbarButtonCancel: 'Cancel',
        toolbarButtonCancelTooltip: 'Cancel the selected job.',
        toolbarButtonRetry: 'Retry',
        toolbarButtonRetryTooltip: 'Retry the execution of the selected job. ' +
            'Due technical problems that occur from time to time ' +
            'it might happen that an job fails though it has correct parameters.' +
            'To retry the job could solve the problem.',
        toolbarButtonShare: 'Share',
        toolbarButtonShareTooltip: 'Share this job with other users by sending them the generated link.',
        toolbarButtonShareTextfieldLink: 'Job share link',
        toolbarButtinShareButtonSendMail: 'Share by mail',
        toolbarButtinShareButtonSendMailTooltip: 'Share this job with other users by email.',
        toolbarTextBlank: '<b>Please select a job</b>',
        toolbarTextBlankTooltip: 'Select a Job to show the options that are available for that job.',
        toolbarButtonResults: 'Show result',
        toolbarButtonResultsTooltip: 'Shows the result page of the selected job.',
        toolbarButtonParameters: 'Show parameters',
        toolbarButtonParametersTooltip: 'Shows the job creation page with the settings that where specified for this job.',
        toolbarButtonShowInBrowser: 'Show in taxonomy browser',
        toolbarButtonShowInBrowserTooltip: 'Shows the results in the taxonomic browser where ' +
            ' the results can be shown in dependency on the taxa that is chosen.',
        toolbarButtonAddToCart: {
            'align': 'Add neighbors to cart',
            'testprime': 'Add matches to cart',
            'testprobe': 'Add matches to cart'
        },
        toolbarButtonAddToCartTooltip: {
            'align': 'Add the neighbor sequences that where found by the aligner to your cart.',
            'testprime': 'Add the sequences that where matched by the used probe sequence to your cart.',
            'testprobe': 'Add the sequences that where matched by the used primer pair to your cart.'
        },
        toolbarButtonDownload: 'Download file',
        toolbarButtonDownloadTooltip: 'Download the file that was produced during this job'
    },
    gridConfig: {
        job_id: {
            header: 'Jobid',
            type: 'int',
            hidden: true,
            width: 30
        },
        job_nr: {
            header: '#',
            type: 'int',
            width: 11
        },
        jobname: {
            header: 'Job Name',
            width: 60
        },
        create_time: {
            header: 'Creation Time',
            width: 52
        },
        job_type: {
            header: 'Job Type',
            width: 34
        },
        status: {
            header: 'Status',
            width: 40,
            renderer: function (value) {
                var res = value;
                if (Ext.Array.contains(['processing', 'starting'], value.toLowerCase())) {
                    res = value + " <img src='/typo3conf/ext/pm_tree/pi1/include" +
                          "/gfx/icons/animation_loading_snake_16x16.gif' " +
                          "height='10' width='10'/> ";
                }
                return res;
            }
        },
        accessions: {
            header: 'Matched Accessions',
            width: 45,
            type: 'int',
            hidden: true
        },
        regions: {
            header: 'Matched Regions',
            width: 40,
            type: 'int',
            hidden: true
        },
        quantity: {
            header: 'Quantity',
            width: 32,
            renderer: function (value) {
                return Number(value) < 0 ? "" : value;
            }
        },
        progress: {
            header: 'Progress',
            width: 32,
            renderer: function (value) {
                return Number(value) <= 0 ? "" : value;
            }
        },
        status_msg: {
            header: 'Status Message'
        },
        elapsed_time: {
            header: 'Elapsed Time',
            width: 36,
            align: 'right'
        },
        queue: {
            header: 'Queue',
            type: 'int',
            width: 24
        }
    },
    frame: true,
    forceFit: true,
    allowDeselect: true,
    viewConfig: {
        loadMask: false
    },
    minHeight: 100,
    itemId: 'jobTaskGrid',
    constructor: function (config) {
        var columnName;
        if (config.columns) {
            for (columnName in this.gridConfig) {
                if (this.gridConfig.hasOwnProperty(columnName)) {
                    if (Ext.Array.contains(config.columns, columnName)) {
                        Ext.apply(this.gridConfig[columnName], { hidden: false });
                    } else {
                        Ext.apply(this.gridConfig[columnName], { hidden: true });
                    }
                } else {
                    Ext.log({
                        msg: "Silva.view.grid.JobTaskGrid.constructor(): invalid parameter, column '" + columnName + "' does not exist",
                        level: "error"
                    });
                }
            }
        }
        this.initConfig(config);
        this.callParent(arguments);
    },
    initComponent: function () {
        Ext.log("Silva.view.grid.JobTaskGrid.initComponent(): START");
        var columns = [],
            obj,
            fields,
            field,
            x;
        this.emptyText = this.labelMap.emptyJobMessage;
        //TODO: this.jobTaskDetailWindow = Ext.create('Silva.view.window.JobTaskDetailWindow');
        this.store = {
            model: 'Silva.model.SilvaTaskModel',
            autoLoad: true
        };
        this.columns = this.buildColumns(this.gridConfig);
        this.dockedItems = [{
            xtype: 'toolbar',
            dock: 'bottom',
            itemId: 'toolbarBottom',
            height: this.config.toolbarHeight,
            items: [{
                xtype: 'button',
                text: this.labelMap.toolbarButtonCancel,
                tooltip: this.labelMap.toolbarButtonCancelTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_cancel_11x11.png',
                itemId: 'toolbarButtonCancel',
                disabled: true
            }, {
                xtype: 'button',
                text: this.labelMap.toolbarButtonRetry,
                tooltip: this.labelMap.toolbarButtonRetryTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_retry_14x13.png',
                itemId: 'toolbarButtonRetry',
                disabled: true
            }, {
                xtype: 'splitbutton',
                text: this.labelMap.toolbarButtonShare,
                tooltip: this.labelMap.toolbarButtonShareTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_share_16x16.png',
                itemId: 'toolbarSplitButtonShare',
                menu: Ext.create('Ext.menu.Menu', {
                    frame: true,
                    bodyStyle: 'background: none !important;',
                    showSeparator: false,
                    items: [{
                        xtype: 'fieldcontainer',
                        layout: {
                            type: 'vbox',
                            align: 'stretch'
                        },
                        items: [{
                            xtype: 'textfield',
                            itemId: 'textfieldLink',
                            fieldLabel: this.labelMap.toolbarButtonShareTextfieldLink,
                            labelAlign: 'top',
                            readOnly: true,
                            selectOnFocus: true,
                            width: 570
                        }, {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch'
                            },
                            items: [{
                                flex: 1,
                                border: false,
                                bodyStyle: 'background: none;'
                            }, {
                                xtype: 'button',
                                text: this.labelMap.toolbarButtinShareButtonSendMail,
                                tooltip: this.labelMap.toolbarButtinShareButtonSendMail,
                                itemId: 'buttonShareByMail',
                                //specify an href to make the button work as link, controller sets target
                                href: ' '
                            }]
                        }]
                    }]
                }),
                disabled: true
            }, {
                xtype: 'tbseparator'
            }, {
                xtype: 'tbtext',
                text: this.labelMap.toolbarTextBlank,
                tooltip: this.labelMap.toolbarTextBlankTooltip,
                itemId: 'toolbarTextBlank'
            }, {
                xtype: 'button',
                text: this.labelMap.toolbarButtonResults,
                tooltip: this.labelMap.toolbarButtonResultsTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_results_16x16.png',
                itemId: 'toolbarButtonResults',
                disabled: true,
                hidden: true
            }, {
                xtype: 'button',
                text: this.labelMap.toolbarButtonParameters,
                tooltip: this.labelMap.toolbarButtonParametersTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_parameters_16x16.png',
                itemId: 'toolbarButtonParameters',
                disabled: true,
                hidden: true
            }, {
                xtype: 'splitbutton',
                text: this.labelMap.toolbarButtonDownload,
                tooltip: this.labelMap.toolbarButtonDownloadTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_download_orange_15x13.png',
                itemId: 'toolbarSplitButtonDownload',
                menu: new Ext.menu.Menu(),
                disabled: true,
                hidden: true
            }, {
                xtype: 'button',
                text: this.labelMap.toolbarButtonShowInBrowser,
                tooltip: this.labelMap.toolbarButtonShowInBrowserTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_tree_13x15.png',
                itemId: 'toolbarButtonShowInBrowser',
                disabled: true,
                hidden: true
            }, {
                xtype: 'button',
                text: '',
                tooltip: '',
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_cart_add_12x13.png',
                itemId: 'toolbarButtonAddToCart',
                disabled: true,
                hidden: true
            }]
        }];
        /*
        add action column that contains icons that are eventlistened
        by the controller. The controller identifies the icon that the
        event comes form with the iconCls.
         */
        /*columns.push({
            xtype: 'actioncolumn',
            menuDisabled: false,
            header: 'Control',
            sortable: false,
            width: 60,
            itemId: 'actionColumn1',
            items: [{
                tooltip: this.labelMap.controlColumnDetailTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_details_15x13.png',
                iconCls: 'cursorPointer detail'
            }, {
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_spacer_4x16.png'
            }, {
                tooltip: this.labelMap.controlColumnCancelTooltip,
                icon: '/typo3conf/ext/pm_tree/pi1/include/gfx/icons/icon_cancel_13x13.png',
                iconCls: 'cursorPointer cancel'
            }]
        });*/
        this.callParent(arguments);
        Ext.log("Silva.view.grid.JobTaskGrid.initComponent(): END");
    },
    setShareUrl: function (shareLink, buttonHref) {

    }
});
