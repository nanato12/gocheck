#!/bin/sh -l

# color
ESC=$(printf '\033')
RESET="${ESC}[0m"

TARGET_PATH_COLOR="${ESC}[38;5;51m"
GOCHECK_COLOR="${ESC}[38;5;190m"
VERSION_COLOR="${ESC}[38;5;69m"
SUCCESS_COLOR="${ESC}[38;5;120m"
TIME_COLOR="${ESC}[38;5;14m"
ERROR_COLOR="${ESC}[38;5;196m"

set -eau

echo -e "\nstart date: $(date)\n"

echo -e "${GOCHECK_COLOR}"
echo "##################################################"
echo "#                                                #"
echo "#                Starting gocheck                #"
echo "#                                                #"
echo "##################################################"
echo -e "\n${RESET}"

echo -e "target path to check: ${TARGET_PATH_COLOR} $@ ${RESET}\n"

echo -e "\n${VERSION_COLOR}$(go version)${RESET}"

# go mod
if [ -e "go.mod" ];
then
    # go build
    echo -e "\n${VERSION_COLOR}go build${RESET}"
    result="$(go build)"
    echo -e "${TARGET_PATH_COLOR}${result}${RESET}"

    echo -e "${VERSION_COLOR}go mod${RESET}"
    echo -n "[go mod tidy] check"
    result="$(go mod tidy -v 2>&1 > /dev/null)"
    if [ -z "${result}" ];
    then
        echo -e "  ${SUCCESS_COLOR}success${RESET}"
    else
        echo -e "  ${ERROR_COLOR}failed${RESET}"
        echo -e "${ERROR_COLOR}${result}${RESET}"
        exit 1
    fi
fi

# gofmt
echo -e "\n${VERSION_COLOR}gofmt start${RESET}"
TIME_A=`date +%s`
for file_name in `find .`; do
    file_ext=`basename $file_name | sed 's/^.*\.\([^\.]*\)$/\1/'`
    if [ -z $file_ext ] || [ "go" != $file_ext ];
    then
        continue
    fi
    echo -n "[gofmt] check: ${file_name}"
    result="$(gofmt -d ${file_name})"
    if [ -z "${result}" ];
    then
        echo -e "  ${SUCCESS_COLOR}success${RESET}"
    else
        echo -e "  ${ERROR_COLOR}failed${RESET}"
        echo -e "\n${ERROR_COLOR}${result}${RESET}"
        exit 1
    fi
done
TIME_B=`date +%s`
GOFMT_PROCCESS_TIME=$((TIME_B-TIME_A))


# goimports
echo -e "\n${VERSION_COLOR}goimports start${RESET}"
TIME_A=`date +%s`
for file_name in `find .`; do
    file_ext=`basename $file_name | sed 's/^.*\.\([^\.]*\)$/\1/'`
    if [ -z $file_ext ] || [ "go" != $file_ext ];
    then
        continue
    fi
    echo -n "[goimports] check: ${file_name}"
    result="$(goimports -d ${file_name})"
    if [ -z "${result}" ];
    then
        echo -e "  ${SUCCESS_COLOR}success${RESET}"
    else
        echo -e "  ${ERROR_COLOR}failed${RESET}"
        echo -e "\n${ERROR_COLOR}${result}${RESET}"
        exit 1
    fi
done
TIME_B=`date +%s`
GOIMPORTS_PROCCESS_TIME=$((TIME_B-TIME_A))

# go vet
set +e
echo -e "\n${VERSION_COLOR}go vet start${RESET}"
TIME_A=`date +%s`
for file_name in `find .`; do
    file_ext=`basename $file_name | sed 's/^.*\.\([^\.]*\)$/\1/'`
    if [ -z $file_ext ] || [ "go" != $file_ext ];
    then
        continue
    fi
    echo -n "[go vet] check: ${file_name}${ERROR_COLOR}"
    result="$(go vet ${file_name} 2>&1 > /dev/null)"
    if [ -z "${result}" ];
    then
        echo -e "  ${SUCCESS_COLOR}success${RESET}"
    else
        echo -e "  ${ERROR_COLOR}failed\n${result}${RESET}"
        exit 1
    fi
done
TIME_B=`date +%s`
GOVET_PROCCESS_TIME=$((TIME_B-TIME_A))
set -e

# golint
set +e
echo -e "\n${VERSION_COLOR}golint start${RESET}"
TIME_A=`date +%s`
for file_name in `find .`; do
    file_ext=`basename $file_name | sed 's/^.*\.\([^\.]*\)$/\1/'`
    if [ -z $file_ext ] || [ "go" != $file_ext ];
    then
        continue
    fi
    echo -n "[golint] check: ${file_name}"
    result="$(golint ${file_name})"
    if [ -z "${result}" ];
    then
        echo -e "  ${SUCCESS_COLOR}success${RESET}"
    else
        echo -e "  ${ERROR_COLOR}failed${result}${RESET}"
        exit 1
    fi
done
TIME_B=`date +%s`
GOVET_PROCCESS_TIME=$((TIME_B-TIME_A))
set -e

echo -e "${GOCHECK_COLOR}"
echo "##################################################"
echo "#                                                #"
echo "#                Complete gocheck                #"
echo "#                                                #"
echo "##################################################"
echo -e "${RESET}"

echo -e "${TIME_COLOR}"
echo "gofmt: ${GOFMT_PROCCESS_TIME}s"
echo "goimports: ${GOIMPORTS_PROCCESS_TIME}s"
echo "govet: ${GOVET_PROCCESS_TIME}s"
echo -e "${RESET}"

echo -e "\nfinish date: $(date)\n"
