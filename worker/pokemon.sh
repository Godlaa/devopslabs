#!/bin/bash

image=$(curl -s "https://pokeapi.co/api/v2/pokemon/$1" |
jq -r '.sprites.other["official-artwork"].front_default')

image2=$(curl -s "https://pokeapi.co/api/v2/pokemon/$((RANDOM % 1025 + 1))" |
jq -r '.sprites.other["official-artwork"].front_default')


echo "
<!DOCTYPE html>
<html lang=\"ru\">
<head>
    <meta charset=\"UTF-8\">
    <title>Pokemons</title>
</head>
<body style=\"
    margin: 0;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;\">
" > /var/www/html/index.html

echo -e "\n<h1>Указанный в аргументе</h1> <img src=\"$image\">" >> /var/www/html/index.html

echo -e "\n<h1>Рандомный</h1> <img src=\"$image2\">" >> /var/www/html/index.html


echo "
</body>
</html>
" >> /var/www/html/index.html
