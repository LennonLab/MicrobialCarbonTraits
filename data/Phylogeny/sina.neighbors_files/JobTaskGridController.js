/**
 * COMMENT ME
 */
// FIXME: this controller takes a lot of CPU load
// FIXME: this probably is caused by the "layouting" of all components everytime the grids store reloads...
Ext.define('Silva.controller.JobTaskGridController', {
    extend: 'Ext.app.Controller',
    refs: [{
        selector: '#jobTaskGrid',
        ref: 'jobTaskGrid'
    }, {
        selector: '#jobTaskGrid #toolbarButtonCancel',
        ref: 'toolbarButtonCancel'
    }, {
        selector: '#jobTaskGrid #toolbarButtonRetry',
        ref: 'toolbarButtonRetry'
    }, {
        selector: '#jobTaskGrid #toolbarSplitButtonShare',
        ref: 'toolbarSplitButtonShare'
    }, {
        selector: '#jobTaskGrid #toolbarSplitButtonShare #textfieldLink',
        ref: 'textfieldLink'
    }, {
        selector: '#jobTaskGrid #toolbarSplitButtonShare #buttonShareByMail',
        ref: 'buttonShareByMail'
    }, {
        selector: '#jobTaskGrid #toolbarSplitButtonDownload',
        ref: 'toolbarSplitButtonDownload'
    }, {
        selector: '#jobTaskGrid #toolbarTextBlank',
        ref: 'toolbarTextBlank'
    }, {
        selector: '#jobTaskGrid #toolbarButtonResults',
        ref: 'toolbarButtonResults'
    }, {
        selector: '#jobTaskGrid #toolbarButtonParameters',
        ref: 'toolbarButtonParameters'
    }, {
        selector: '#jobTaskGrid #toolbarButtonShowInBrowser',
        ref: 'toolbarButtonShowInBrowser'
    }, {
        selector: '#jobTaskGrid #toolbarButtonAddToCart',
        ref: 'toolbarButtonAddToCart'
    }],
    selectedJobid: -1,
    handlerJobFinished: [],
    /**
     * A template method that is called when your application boots.
     * It is called before the Application's launch function is
     * executed so gives a hook point to run any code before your
     * Viewport is created.
     */
    init: function () {
        Ext.log('Silva.controller.JobTaskGridController.init(): START');
        this.control({
            '#jobTaskGrid': {
                selectionchange: this.onSelectionChange/*,
                deselect: this.onDeselect*/
            },
            '#jobTaskGrid #toolbarButtonCancel': {
                click: this.onClickToolbarButtonCancel
            },
            '#jobTaskGrid #toolbarButtonRetry': {
                click: this.onClickToolbarButtonRetry
            },
            '#jobTaskGrid #toolbarSplitButtonShare': {
                click: this.onClickToolbarSplitButtonShare
            },
            '#jobTaskGrid #toolbarSplitButtonDownload': {
                click: this.onClickToolbarButtonDownload
            },
            '#jobTaskGrid #toolbarButtonResults': {
                click: this.onClickToolbarButtonResults
            },
            '#jobTaskGrid #toolbarButtonParameters': {
                click: this.onClickToolbarButtonParameters
            },
            '#jobTaskGrid #toolbarButtonShowInBrowser': {
                click: this.onClickToolbarButtonShowInBrowser
            },
            '#jobTaskGrid #toolbarButtonAddToCart': {
                click: this.onClickToolbarButtonAddToCart
            }
        });
        Ext.log('Silva.controller.JobTaskGridController.init(): END');
    },
    /**
     * This is called after the launch method of Application is executed.
     */
    onLaunch: function () {
        Ext.log("Silva.controller.JobTaskGridController.onLaunch(): START");
        /* STORE EVENT HANDLERS */
        //NOTE don't forget the SCOPE! ('this' argument)
        this.getJobTaskGrid().getStore().on('datachanged',
            this.onDataChangedStore,
            this);
        //this.jobTaskDetailWindow = Ext.create("Silva.view.window.JobTaskDetailWindow");
        this.applyFilter();
        Ext.Function.defer(this.startReloadLoop, 6000, this);
        Ext.log("Silva.controller.JobTaskGridController.onLaunch(): END");
    },
    /**
     * PRIVATE FUNCTION
     * starts the reload loop of the grid to always show the updated
     * list of tasks. The loop is started automatically.
     */
    startReloadLoop: function () {
        this.getJobTaskGrid().store.reload();
        Ext.Function.defer(this.startReloadLoop, 6000, this);
    },
    /**
     * COMMENT ME
     */
    applyFilter: function () {
        Ext.log("Silva.controller.JobTaskGridController.applyFilter(): START");
        var taskView = this.getJobTaskGrid();
        if (taskView.config.filter.jobType) {
            Ext.log("Silva.view.SilvaTaskView.applyFilter(): using jobtype filter: " + taskView.config.filter.jobType);
            taskView.store.filter("job_type", taskView.config.filter.jobType);
        }
        if (taskView.config.filter.jobId) {
            Ext.log("Silva.view.SilvaTaskView.applyFilter(): using jobid filter: " + taskView.config.filter.jobId);
            taskView.store.filter("job_id", taskView.config.filter.job_id);
        }
        Ext.log("Silva.controller.JobTaskGridController.applyFilter(): END");
    },
    /**
     * Add an handler that is called when the given jobid has finished.
     * The jobid is passed as argument to the given callbackhandler.
     *
     * @param jobid
     * @param callbackHandler
     * @param scope
     */
    addJobFinishedHandler: function (jobid, callbackHandler, scope) {
        scope = scope || this;
        this.handlerJobFinished.push({
            jobid: jobid,
            callbackHandler: callbackHandler,
            scope: scope
        });
    },
    /**
     * Called when the grids store has changed. Called on every reload.
     *
     * @param store
     */
    onDataChangedStore: function (store) {
        Ext.log("Silva.controller.JobTaskGridController.onDataChangedStore(): START");
        var index = store.findExact('job_id', this.selectedJobid),
            handler,
            record,
            tempHandler;
        if (index > -1) {
            Ext.log("Silva.controller.JobTaskGridController.onDataChangedStore(): selected index " + index);
            this.getJobTaskGrid().getSelectionModel().select(index);
        } else {
            this.handleSelection(-1);
        }
        /**
         * handle the jobFinishedHandler
         */
        tempHandler = [];
        while ((handler = this.handlerJobFinished.pop()) !== undefined) {
            tempHandler.push(handler);
            record = store.findRecord('job_id', handler.jobid);
            if (record !== null) {
                if (record.getData().status.toLowerCase() === "finished") {
                    Ext.callback(handler.callbackHandler, handler.scope, [handler.jobid]);
                    tempHandler.pop();
                }
            }
        }
        this.handlerJobFinished = tempHandler;
        Ext.log("Silva.controller.JobTaskGridController.onDataChangedStore(): STOP");
    },
    /**
     * Called when another row in the grid was selected.
     *
     * @param selectionModel
     * @param modelArray
     * @param index The index of the selected row
     */
    onSelectionChange: function (selectionModel, modelArray, index) {
        Ext.log("Silva.controller.JobTaskGridController.onSelectionChange(): START");
        if (modelArray.length > 1) {
            Ext.log({
                level: 'warn',
                msg: 'Silva.controller.JobTaskGridController.onSelectionChange(): more than one selection.',
                dump: modelArray
            });
        }
        if (modelArray.length === 1) {
            this.handleSelection(modelArray[0].getId());
        } else {
            this.handleSelection(-1);
        }
        Ext.log("Silva.controller.JobTaskGridController.onSelectionChange(): END");
    },
    /**
     * Handles the activation of the buttons in the toolbar depend on the
     * given selected jobid. An jobid id of -1 is handled as "no selection".
     *
     * @param jobid The jobid that was selected.
     */
    handleSelection: function (jobid) {
        var view = this.getJobTaskGrid(),
            store = view.getStore(),
            data = jobid < 0 ? [] : store.getById(jobid).getData(),
            status = jobid < 0 ? "" : data.status.toLowerCase(),
            jobType = jobid < 0 ? "" : data.job_type.toLowerCase(),
            item,
            isAdmin = silvadata && silvadata.taskmanager && silvadata.taskmanager.admin === true;
        data.parameters = Ext.JSON.decode(data.parameters);
        this.selectedJobid = jobid;
        /**
         * CONTROL THE STATIC TOOLBAR BUTTONS
         */
        if (jobid > -1) {
            Ext.log("Silva.controller.JobTaskGridController.handleSelection(): job_id " + jobid + " was selected.");
            this.getToolbarSplitButtonShare().setDisabled(false);
            if (status === "finished") {
                this.getToolbarButtonCancel().setDisabled(true);
                this.getToolbarButtonRetry().setDisabled(true);
            } else if (status === "queued") {
                this.getToolbarButtonCancel().setDisabled(false);
                this.getToolbarButtonRetry().setDisabled(true);
            } else if (status === "failed") {
                this.getToolbarButtonRetry().setDisabled(false);
                this.getToolbarButtonCancel().setDisabled(true);
            } else if (status === "aborted") {
                this.getToolbarButtonCancel().setDisabled(true);
                this.getToolbarButtonRetry().setDisabled(false);
            } else if (status === "overtime") {
                this.getToolbarButtonCancel().setDisabled(true);
                this.getToolbarButtonRetry().setDisabled(true);
            } else {
                this.getToolbarButtonRetry().setDisabled(true);
                this.getToolbarButtonCancel().setDisabled(false);
            }
        } else {
            this.getToolbarSplitButtonShare().setDisabled(true);
            this.getToolbarButtonCancel().setDisabled(true);
            this.getToolbarButtonRetry().setDisabled(true);
        }
        /**
         * CONTROL THE DYNAMIC TOOLBAR BUTTONS
         */
        if (jobid > -1) {
            this.getToolbarTextBlank().hide();
            item = this.getToolbarSplitButtonDownload();
            if (Ext.Array.contains(['export', 'align'], jobType)) {
                if (status === "finished") {
                    var fileObjects = Ext.JSON.decode(data.result, true),
                        nr,
                        obj = [];
                    item.menu.removeAll();
                    for (nr = 0; nr < fileObjects.length; nr++) {
                        if (fileObjects[nr].adminOnly === false || isAdmin === true) {
                            obj.push(fileObjects[nr]);
                        }
                    }
                    item.menu.add(obj);
                    item.setDisabled(false);
                } else {
                    item.setDisabled(true);
                }
                item.show();
            } else {
                item.hide();
            }
            item = this.getToolbarButtonResults();
            if (Ext.Array.contains(['testprobe', 'testprime', 'align'], jobType)) {
                item.setDisabled(status === "finished" ? false : true);
                item.show();
            } else {
                item.hide();
            }
            item = this.getToolbarButtonParameters();
            if (Ext.Array.contains([], jobType)) {
                item.setDisabled(false);
                item.show();
            } else {
                item.hide();
            }
            item = this.getToolbarButtonAddToCart();
            if (Ext.Array.contains(['testprobe', 'testprime', 'align'], jobType)) {
                item.setText(this.getJobTaskGrid().labelMap.toolbarButtonAddToCart[jobType]);
                item.setTooltip(this.getJobTaskGrid().labelMap.toolbarButtonAddToCartTooltip[jobType]);
                if (jobType === 'align') {
                    // ONLY ENABLE ADDTOCART BUTTON FOR ALIGNER JOBS WHEN SEARCH WAS ENABLED
                    item.setDisabled(status === 'finished' && data.parameters['search-and-classify'] === true ? false : true);
                } else {
                    item.setDisabled(status === "finished" ? false : true);
                }
                item.show();
            } else {
                item.hide();
            }
            item = this.getToolbarButtonShowInBrowser();
            if (Ext.Array.contains(['testprobe', 'testprime'], jobType)) {
                item.setDisabled(status === "finished" ? false : true);
                item.show();
            } else {
                item.hide();
            }
        } else {
            this.getToolbarSplitButtonDownload().hide();
            this.getToolbarButtonResults().hide();
            this.getToolbarButtonParameters().hide();
            this.getToolbarButtonAddToCart().hide();
            this.getToolbarButtonShowInBrowser().hide();
            this.getToolbarTextBlank().show();
        }
    },
    /**
     * COMMENT ME
     *
     * @param view
     * @param event
     */
    onClickToolbarButtonCancel: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonCancel(): START");
        this.getToolbarButtonCancel().setDisabled(true);
        Ext.Ajax.request({
            url: Silva.Application.AJAXURL,
            silvaControl: true,
            params: {
                type: 'job',
                action: 'cancel',
                jobid: this.selectedJobid
            }
        });
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonCancel(): END");
    },
    /**
     * COMENT ME
     *
     * @param view
     * @param event
     */
    onClickToolbarButtonRetry: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonRetry(): START");
        this.getToolbarButtonRetry().setDisabled(true);
        Ext.Ajax.request({
            url: Silva.Application.AJAXURL,
            silvaControl: true,
            params: {
                type: 'job',
                action: 'retry',
                jobid: this.selectedJobid
            }
        });
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonRetry(): END");
    },
    onClickToolbarSplitButtonShare: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonShare(): START");
        var taskGrid = this.getJobTaskGrid(),
            store = taskGrid.getStore(),
            data = store.getById(this.selectedJobid).getData(),
            shareLink = "http://" + location.host +
                Silva.Application.BASEURL.download +
                "job/" + this.selectedJobid + "/" + data.sharecode,
            jobName = data.jobname ? " - " + data.jobname : "",
            mailLink = "mailto:?subject=arb-silva.de - " + data.job_type +
                jobName + "&body=" + shareLink;
        this.getTextfieldLink().setValue(shareLink);
        view.showMenu();
        this.getButtonShareByMail().href = mailLink;
        this.getButtonShareByMail().setParams({});
        Ext.log("Silva.controller.JobTaskGridController.onClickToolbarButtonShare(): END");
    },
    onClickToolbarButtonResults: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonResults(): START");
        var store = this.getJobTaskGrid().getStore(),
            data = store.getById(this.selectedJobid).getData(),
            status = data.status.toLowerCase(),
            jobType = data.job_type.toLowerCase();
        location.href = Silva.Application.BASEURL[jobType] + "job/" + this.selectedJobid;
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonResults(): END");
    },
    onClickToolbarButtonParameters: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonParameters(): START");
        var store = this.getJobTaskGrid().getStore(),
            data = store.getById(this.selectedJobid).getData(),
            status = data.status.toLowerCase(),
            jobType = data.job_type.toLowerCase();
        location.href = Silva.Application.BASEURL[jobType] + "job/" + this.selectedJobid;
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonParameters(): END");
    },
    onClickToolbarButtonAddToCart: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonAddToCart(): START");
        var me = this,
            store = this.getJobTaskGrid().getStore(),
            data = store.getById(this.selectedJobid).getData(),
            jobType = data.job_type.toLowerCase();
        Ext.Ajax.request({
            url: Silva.Application.AJAXURL,
            silvaControl: true,
            silvaControlMessage: this.getJobTaskGrid().labelMap.eventAddToCart,
            params: {
                type: jobType,
                action: 'addtocart',
                jobid: this.selectedJobid
            },
            success: function (response) {
                me.application.handleCallback(response);
            }
        });
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonAddToCart(): END");
    },
    /**
     * Changes the location to the taxonomic browser showing the job
     * that is currently selected.
     *
     * @param view
     * @param event
     */
    onClickToolbarButtonShowInBrowser: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonShowInBrowser(): START");
        var store = this.getJobTaskGrid().getStore(),
            data = store.getById(this.selectedJobid).getData(),
            status = data.status.toLowerCase(),
            jobType = data.job_type.toLowerCase(),
            href,
            seqCol;
        data.db = Ext.JSON.decode(data.db);
        data.parameters = Ext.JSON.decode(data.parameters);
        // choose taxonomy matching database type when showing in browser
        switch(data.parameters.databasetype) {
            case 'ref':
                seqCol = '/silva-ref/'
                break;
            case 'nr':
                seqCol = '/silva-ref-nr/';
                break;
            case 'ltp':
                seqCol = '/ltp/'
                break;
            default:
                seqCol = '/silva/';
        }
        href = Silva.Application.BASEURL.browser + data.db.id + seqCol + jobType + "/" + data.job_id + "/";
        location.href = href;
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonShowInBrowser(): END");
    },
    onClickToolbarButtonDownload: function (view, event) {
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonDownload(): START");
        /**
         * When menu has only one item start download directly,
         * otherwise open the dropdown menu which shows all files.
         */
        if (view.menu.items.length === 1) {
            location.href = view.menu.items.get(0).href;
        } else {
            view.showMenu();
        }
        Ext.log("Silva.controller.JobTaskGridController.onClickButtonDownload(): END");
    }
});