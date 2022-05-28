#!/bin/bash
set -ex


#################################################
# in case specific model or test case is provided

specific_model="ALL"
specific_test_case="ALL"
while getopts m:t: flag
do
    case "${flag}" in
        m) specific_model=${OPTARG};;
        t) specific_test_case=${OPTARG};;
    esac
done

#################################################
# insert the seed data needed for the tests

seeds="$( cat ./conf_test/tests_definitions.csv| cut -d, -f1| uniq )"
for seed in ${seeds[*]} 
do
    if [[ "$specific_model" == "ALL" ]] || [[ "$specific_model" == "$seed" ]]; then

        # skip lines that start with #
        if [[ $seed == \#* ]]; then
            continue
        fi

        dbt seed --full-refresh -m MOCK_$seed --vars '{"test_mode":true}'
    fi
done

#################################################
pop_n_test(){
    # populate the model and test it 

    model=$1
    test_id=$2

    # populate the model with test_id conditions
    dbt run -m $model --vars '{"test_mode":true,"test_id":"'"$test_id"'","model_name":"'"$model"'"}'

    # test that results are as expected
    dbt test --select tag:test_${model}_${test_id} --vars '{"test_mode":true,"test_id":"'"$test_id"'","model_name":"'"$model"'"}'
}

models="$( cat ./conf_test/tests_definitions.csv)"
for pair in ${models}
do

    # decompose each rows into human vars
    model="$(echo $pair | cut -d, -f1)"
    test_id="$(echo $pair | cut -d, -f2)"

    if [[ "$specific_model" == "ALL" ]] || [[ "$specific_model" == "$model" ]]; then
        if [[ "$specific_test_case" == "ALL" ]] || [[ "$specific_test_case" == "$test_id" ]]; then

             #skip lines that start with #
            if [[ $pair == \#* ]]; then
                continue
            fi

            # order is important
            pop_n_test $model $test_id
        fi
    fi
done

set +ex
