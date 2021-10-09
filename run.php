<?php
function clientCode($numberOne,$numberTwo)
{

    foreach (range($numberOne, $numberTwo) as $key =>$value){

        switch ($value) {
            case $value % 3 == 0 &&  $value % 5 == 0:
                echo "FooBar";
                break;
            case $value % 3 == 0:
                echo "Foo";
                break;
            case $value % 5 == 0:
                echo "Bar";
                break;
            default:
                echo $value;
        }

    };



}

if(count($argv)===3 && $argv[2]<$argv[1]) {

    clientCode($argv[1], $argv[2]);

}else{

    exit("Exception!");
}
