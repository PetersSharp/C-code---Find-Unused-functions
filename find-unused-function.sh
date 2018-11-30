#!/bin/bash

    if [[ "${1}" == "" || "${2}" == "" ]] ;
    then
        echo -e "\n\tGit: https://github.com/PetersSharp/C-code---Find-Unused-functions\n"
        echo -e "\tRequired:\n"
        echo -e "\t- GCC 4.x"
        echo -e "\t- nm (any version)"
        echo -e "\t- find :)\n"
        echo -e "\tUse:\n"
        echo -e "\t- add CFLAGS:  -ffunction-sections -fdata-sections"
        echo -e "\t- add LDFLAGS: -Wl,-gc-sections"
        echo -e "\t- (optionals) add to source file: #include \"find-unused-function.h\","
        echo -e "\t  and add prefix you export functions: FUNINLINE or FUNEXPORT (Required find-unused-function.h)"
        echo -e "\tto Makefile, and make source"
        echo -e "\tafter run: ${0} <path/compiled-name.bin> <path/object-dir/*.o> [<path/source-dir/*.c|h>]\n"
        exit 0
    fi
    if [[ ! -f "${1}" ]] ;
    then
        echo -e "\tBinary to compare: ${1} not found"
        exit 0
    fi
    if [[ ! -d "${2}" ]] ;
    then
        echo -e "\tDirectory object files *.o: ${2} not found"
        exit 0
    fi

    TMPDIR="${2}/DebugSymbol"
    # replace possible '//' with '/'
    TMPDIR=${TMPDIR//\/\//\/}

    if [[ ! -d "${TMPDIR}" ]] ;
    then
        mkdir -p "${TMPDIR}"
    fi

    find "${2}" -type f -iname \*.o -exec nm {} \; | grep  " T " | awk '{ print $3 }' | sort | uniq >"${TMPDIR}/symbols.defo"
    find "${2}" -type f -iname \*.o -exec nm {} \; | grep  " U " | awk '{ print $2 }' | sort | uniq >"${TMPDIR}/symbols.exto"
    nm "${1}" | grep  " T " | awk '{ print $3 }' | sort | uniq >"${TMPDIR}/symbols.defb"
    nm "${1}" | grep  " U " | awk '{ print $2 }' | sort | uniq >"${TMPDIR}/symbols.extb"
    diff -u "${TMPDIR}/symbols.defo" "${TMPDIR}/symbols.defb" | grep -v "@" | grep "-" >"${TMPDIR}/symbols.unused-binary"

    if [[ "${3}" != "" && -d "${3}" ]] ;
    then
        find "${3}" -iname "*.[chsCHS]" -exec grep -E "(FUNINLINE|FUNEXPORT)" {} \; | grep -v "define" | awk -F"(" '{ print $1 }' | awk '{ print $NF }' | sort | uniq >"${TMPDIR}/symbols.defs"
        diff -u "${TMPDIR}/symbols.defs" "${TMPDIR}/symbols.defb" | grep -v "@" | grep "-" >"${TMPDIR}/symbols.unused-source"
        echo -e "\n\tSee source export list in: ${TMPDIR}/symbols.unused-source"
    fi

    if [[ "${4}" != "" ]] ;
    then
        cat "${TMPDIR}/symbols.unused-binary"
    fi

    echo -e "\n\tSee result in: ${TMPDIR}/symbols.unused-binary\n"
