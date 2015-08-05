/**
 * COMMENT ME
 */
Ext.define('Silva.view.grid.BaseGrid', {
    extend: 'Ext.grid.Panel',
    width: '100%',
    forceFit: true,
    verticalScroller: {
        trailingBufferZone: 200,
        leadingBufferZone: 5000
    },
    /**
     * Build method for columns
     *
     * parameter example:
     * fields = ['job_id', 'job_type']
     * columnsConfig = {
     *  job_id: {
     *      header: 'Job Id',
     *      hidden: true,
     *      width: 30     *
     *  },
     *  job_type: {
     *      header: 'Job Type'
     *  }
     * }
     *
     * @param gridConfig An Object that contains a config for every field name.
     * @returns The build column config, ready for usage in the grid.
     */
    buildColumns: function (gridConfig) {
        var columns = [],
            fields = [],
            field,
            obj,
            x;
        for (field in gridConfig) {
            if (gridConfig.hasOwnProperty(field)) {
                fields.push(field);
            }
        }
        for (x = 0; x < fields.length; x++) {
            field = fields[x];
            obj = {
                dataIndex: field
            };
            Ext.apply(obj, gridConfig[field]);
            columns.push(obj);
        }
        return columns;
    },
    /**
     * Creates a usable default store configuration object
     * with the given grid- and proxyConfig objects.
     *
     * @param gridConfig
     * @return {*}
     */
    buildStore: function (gridConfig, proxyConfig, storeConfig) {
        var fields = [],
            field,
            obj;
        for (field in gridConfig) {
            if (gridConfig.hasOwnProperty(field)) {
                obj = {
                    name: field
                };
                Ext.apply(obj, gridConfig[field]);
                fields.push(obj);
            }
        }
        return Ext.apply({
            fields: fields,
            proxy: proxyConfig,
            autoLoad: true,
            pageSize: 100,
            remoteSort: true
        }, storeConfig);
    }
});
