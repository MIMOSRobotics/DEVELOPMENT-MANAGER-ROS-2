#!/bin/bash
# Author: Mahir Sehmi
# Date: 2024-06-11

DEV_MANAGER_REVISION=20250101	# Functional revision. Change if any new feature is added or any existing feature is modified.

###### GLOBAL ENVIRONMENT ######
export WS_DIR="$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")"
export WS_DEV_INIT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/dev_init.bash"
export WS_DEV_MANAGER_DIR_NAME="$(basename $(dirname "$(readlink -f "${BASH_SOURCE[0]}")"))"
export WS_DEV_MANAGER_DIR="$WS_DIR/$WS_DEV_MANAGER_DIR_NAME"
WS_DEV_VERBOSITY="${3:-1}" # 0: quiet, 1: normal

###### RESET PROJECT ENVIRONMENT ######
source $WS_DEV_MANAGER_DIR/scripts/reset.bash


###### PROJECT ENVIRONMENT ######
export WS_PROJECT_REPO="$WS_DIR${1:-/$WS_DEV_MANAGER_DIR_NAME/temp}"
export WS_PROJECT_DIR_NAME="$(basename $WS_PROJECT_REPO)"
export WS_PROJECT_WORKSPACE="$2"


###### DEVELOPMENT SESSION ######
if [ "$WS_PROJECT_REPO" == "$WS_DIR/$WS_DEV_MANAGER_DIR_NAME/temp" ]; then
	source $WS_DEV_MANAGER_DIR/config/settings.bash
	source $WS_PROJECT_REPO/config/settings.bash
	source $WS_DEV_MANAGER_DIR/config/aliases.bash
	unalias r2devw
	unalias r2pkg
	export WS_DEV_SESSION_CHECK=99
else
	source $WS_DEV_MANAGER_DIR/config/settings.bash
	source $WS_PROJECT_REPO/config/init.bash
	source $WS_PROJECT_REPO/config/settings.bash    # If contain duplicate, this will overwrite settings from dev_manager.
	source $WS_DEV_MANAGER_DIR/config/aliases.bash
	source $WS_PROJECT_REPO/config/aliases.bash     # If contain duplicate, this will overwrite aliases from dev_manager.
	export WS_DEV_SESSION_CHECK=1
fi

alias r2dev="source $WS_DEV_MANAGER_DIR/scripts/menu_dev_manager.bash"




###### DISPLAY ######
# display below only when WS_DEV_VERBOSITY is 1
if [ $WS_DEV_VERBOSITY == 1 ]; then
	clear -x
	echo -e "\e[33m===================================================================
                      _______  _   _        __      __
                  /\ |__   __|| \ | |    /\ \ \    / /
                 /  \   | |   |  \| |   /  \ \ \  / /
                / /\ \  | |   |     |  / /\ \ \ \/ /
               / ____ \ | |   | |\  | / ____ \ \  / 
              /_/    \_\|_|   |_| \_|/_/    \_\ \/
=================================================== Est. 2023 ====="
	echo -e "$BASH_INFO Initializing..."
	if [ "$WS_PROJECT_REPO" != "$WS_DIR/$WS_DEV_MANAGER_DIR_NAME/temp" ]; then
		if [ "$WS_DEV_MANAGER_REVISION" -lt "$DEV_MANAGER_REVISION" ]; then
			echo -e "$BASH_WARNING The current project is using development manager revision \e[36m$WS_DEV_MANAGER_REVISION\e[0m which is older than current manager revision \e[36m$DEV_MANAGER_REVISION\e[0m. You may continue using but some features may not work. Please use older version or upgrade current project repo following the latest content."
		fi

		if [ "$WS_DEV_MANAGER_REVISION" -gt "$DEV_MANAGER_REVISION" ]; then
			echo -e "$BASH_WARNING The current project is using development manager revision \e[36m$WS_DEV_MANAGER_REVISION\e[0m which is newer than current manager revision \e[36m$DEV_MANAGER_REVISION\e[0m. You may continue using but some features may not work. Please upgrade the manager."
		fi
	fi
	echo "==================================================================="
	if [ $WS_DEV_SESSION_CHECK == 99 ]; then
		# source $WS_DEV_MANAGER_DIR/scripts/display_info.bash
		echo -e "$BASH_INFO WELCOME TO ROS 2 DEVELOPMENT MANAGER"
		echo "==================================================================="
		echo -e "$BASH_INFO Type '\e[33mr2devp\e[0m' to create a new project."
		echo -e "$BASH_INFO Type '\e[33mr2devg\e[0m' to clone git project."
		echo -e "$BASH_INFO Type '\e[33mr2dev\e[0m' for menu."
		echo -e "$BASH_INFO Refer to README.md for more information."
		cd $WS_DEV_MANAGER_DIR
	fi

	if [ $WS_DEV_SESSION_CHECK == 1 ]; then
		r2info
		echo "==================================================================="
		r2s
		r2cdw
		echo -e "$BASH_INFO Type '\e[33mr2pkg\e[0m' for package manager menu."
	fi
else 
	if [ $WS_DEV_SESSION_CHECK == 99 ]; then
		echo -e "$BASH_INFO WELCOME TO ROS 2 DEVELOPMENT MANAGER"
		cd $WS_DEV_MANAGER_DIR
	fi
	if [ $WS_DEV_SESSION_CHECK == 1 ]; then
		echo -e "$BASH_INFO Project Name: \e[36m$DEV_PROJECT_NAME\e[0m"
		r2cdw
	fi
fi