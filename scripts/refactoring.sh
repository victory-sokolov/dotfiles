#!/bin/sh

toIso() # Convert DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)
{
    sed 's_\([0-9]\{1,2\}\)/\([0-9]\{1,2\}\)/\([0-9]\{4\}\)_\3-\2-\1_g'
}
