#! /usr/bin/env bash
#
#   Copyright 2017, DeiC, Niels Thomas Haugård
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

function generate_locales()
{
    locale-gen en_DK.utf8       # prevent perl from complaining during tests (Niels Thomas)
    locale-gen en_GB.UTF-8      # danish locale required by postgres (sorting)
    locale-gen da_DK.UTF-8      # danish locale required by postgres (sorting)
    locale-gen en_US.UTF-8      # US english locale required by postgres (sorting)
}


function main()
{
    # check on how to suppress newline (found in an Oracle installation script ca 1992)
    echo="/bin/echo"
    case ${N}$C in
        "") if $echo "\c" | grep c >/dev/null 2>&1; then
            N='-n'
        else
            C='\c'
        fi ;;
    esac

    echo "Installing OS utilities  ..."
    generate_locales

    # your code goes here ...

    exit 0

}

################################################################################
# Main
################################################################################
#
# clean up on trap(s)
#

main $*

