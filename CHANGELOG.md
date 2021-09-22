# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.2.0 (2020-03-13)

Re-adds `Enum.thru/2`. Not redundant with `Enum.each/2` since it returns the
original enum instead of `:ok` 🤦🏼‍♂️.

## 2.1.0 (2020-03-04)

Adds `Enum.find_by/3` and `Enum.find_by/4`.

## 2.0.0 (2020-03-04)

*Breaking*: Removes `Enum.thru/2` as it was redundant with `Enum.each/2`
Adds `tap/2` and `thru/2`
