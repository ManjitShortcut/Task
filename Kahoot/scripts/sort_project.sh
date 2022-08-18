#!/bin/bash

APP_PROJECT_FILE="Kahoot.xcodeproj/project.pbxproj"

$(swift scripts/SortProjectFile/main.swift ${APP_PROJECT_FILE})
