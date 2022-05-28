{%- macro ref_t(table_name) -%}
    {%- if var('model_name','') == this.table -%}
        {%- if var('test_mode',false) -%}
            {%- if var('test_id','not_provided') == 'not_provided' -%}
                {%- do exceptions.warn("WARNING: test_mode is true but test_id is not provided, rolling back to normal behavior") -%}
                {{ ref(table_name) }} 
            {%- else -%}
                {%- do log("stab ON, replace table: ["+table_name+"] --> ["+this.table+"_MOCK_"+table_name+"_"+var('test_id')+"]", info=True) -%}
                {{ ref(this.table+'_MOCK_'+table_name+'_'+var('test_id')) }}
            {%- endif -%}
        {%- else -%}
            {{ ref(table_name) }} 
        {%- endif -%}
    {%- else -%}
        {{ ref(table_name) }} 
    {%- endif -%}
        
{%- endmacro -%}

{%- macro source_t(schema, table_name) -%}

    {%- if var('model_name','') == this.table -%}
        {%- if var('test_mode',false) -%}
            {%- if var('test_id','not_provided') == 'not_provided' -%}
                {%- do exceptions.warn("WARNING: test_mode is true but test_id is not provided, rolling back to normal behavior") -%}
                {{ builtins.source(schema,table_name) }}
            {%- else -%}
                {%- do log("stab ON, replace table: ["+schema+"."+table_name+"] --> ["+this.table+"_MOCK_"+table_name+"_"+var('test_id')+"]", info=True) -%}
                {{ ref(this.table+'_MOCK_'+table_name+'_'+var('test_id')) }}
            {%- endif -%}
        {%- else -%}
            {{ builtins.source(schema,table_name) }}
        {%- endif -%}
    {%- else -%}
        {{ builtins.source(schema,table_name) }}
    {%- endif -%}
        
{%- endmacro -%}
