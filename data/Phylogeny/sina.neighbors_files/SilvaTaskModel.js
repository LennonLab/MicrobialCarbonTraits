/**
 * The general model of an Silva Task or Job.
 *
 */
Ext.define('Silva.model.SilvaTaskModel', {
    extend: 'Ext.data.Model',
    fields: [{
        name: 'job_id',
        type: 'int'
    }, {
        name: 'job_nr',
        type: 'int'
    }, {
        name: 'jobname',
        type: 'string',
        defaultValue: ''
    },
        'db',
        'job_type',
        'elapsed_time',
        {
            name: 'progress',
            type: 'int'
        },
        {
            name: 'quantity',
            type: 'int'
        },
        'status',
        'status_msg',
        {
            name: 'queue',
            type: 'int'
        },
        'accessions',
        'regions',
        'result',
        'parameters',
        'sharecode',
        'create_time',
        {
            name: 'accessions',
            type: 'int'
        },
        {
            name: 'regions',
            type: 'int'
        }],
    idProperty: 'job_id',
    proxy: {
        type: 'ajax',
        url: '/WS/',
        extraParams: {
            type: 'job',
            action: 'get'
        },
        reader: {
            type: 'json'
        }
    }
});

