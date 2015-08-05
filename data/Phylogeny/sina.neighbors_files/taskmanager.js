Ext.Loader.setConfig({
    enabled: true,
    paths: {
        Silva: 'typo3conf/ext/pm_tree/pi1/include/js/silva/app'
    }
});
Ext.require("Silva.Application");
Ext.onReady(function () {
    Ext.define('Silva.application.TaskManager', {
        name: 'TaskManager',
        extend: 'Silva.Application',
        labelMap: {
            taskManagerGridTitle: 'SILVA Taskmanager'
        },
        requires: [
            'Ext.data.Store',
            'Ext.form.FieldContainer',
            'Ext.form.field.Text',
            'Ext.button.Split',
            'Ext.toolbar.TextItem',
            'Silva.functions',
            'Silva.Application',
            'Silva.view.grid.JobTaskGrid',
            'Silva.model.SilvaTaskModel',
            'Silva.controller.JobTaskGridController'
        ],
        views: [
            'Silva.view.grid.JobTaskGrid',
            'Silva.model.SilvaTaskModel'
        ],
        controllers: [
            'Silva.controller.JobTaskGridController'
        ],
        launch: function () {
            Ext.log("taskmanager.launch(): START");
            var container = Ext.create('Ext.container.Container', {
                renderTo: 'silva_pmtree',
                items: [{
                    layout: {
                        type: 'vbox',
                        align: 'center'
                    },
                    frame: false,
                    border: false,
                    bodyStyle: 'background: none;',
                    items: [{
                        xtype: 'slv-jobtaskgrid',
                        title: this.labelMap.taskManagerGridTitle,
                        margin: '0 0 10 0'
                    }]
                }]
            });
            Ext.log("taskmanager.launch(): END");
        }
    });
    Ext.onReady(function () {
        Silva.application.TaskManager.create();
    });
});