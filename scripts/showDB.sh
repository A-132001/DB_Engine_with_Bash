#!/bin/bash
if [ -z "$(find "./Databases" -mindepth 1 -type d -print -quit 2>/dev/null)" ]; then
    echo "No databases created yet"
else
    echo "All databases are already created"
    ls -d "./Databases/"*/
fi
