#!/usr/bin/env bash

# Give the documentation container some time to spin up.
sleep 2

# Read the content into the variable "PC".
PC=$(curl -s http://127.0.0.1:8081)

# Check if the string "Material for MkDocs" is somewhere in the html content.
if [[ "${PC}" = *"Material for MkDocs"* ]]
then
  # If found, return success.
  exit 0
else
  # If not, return failure.
  exit 1
fi