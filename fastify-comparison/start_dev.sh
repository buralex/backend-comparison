#!/bin/bash

set -o allexport && . ./.env.local && set +o allexport \
&& nodemon --transpileOnly src/index.ts