<?php
function clientCode($numberOne,$numberTwo)
{

    foreach (range($numberOne, $numberTwo) as $key =>$value){

        switch ($value) {
            case $value % 3 == 0:
                echo "Foo";
                break;
            case $value % 5 == 0:
                echo "Bar";
                break;
            case $value % 3 == 0 &&  $value % 5 == 0:
                echo "FooBar";
                break;
            default:
                echo $value;
        }

    };



}

if(count($argv) && $argv[1]<$argv[0]) {

    clientCode($argv[0], $argv[1]);

}else{

    exit("Exception!");
}