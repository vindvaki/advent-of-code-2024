# Hordur's solutions to Advent of Code 2024

## Install dependencies

``` shell
bundle install
```

## REPL with autoloaded code

``` shell
bin/irb
```

To reload code, call `reload!`.

## Run solution against input

``` shell
bin/rake run[$day,$part]
```

For example, to run day 1 part 2:

``` shell
bin/rake run[1,2]
```

## Run tests

All tests:

``` shell
bin/rake test
```

Specific tests:

``` shell
bin/rake test N=/day_1/
```
