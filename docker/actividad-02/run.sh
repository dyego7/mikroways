#!/bin/sh

dd if=/dev/zero bs=$1 count=1 of=created-file
