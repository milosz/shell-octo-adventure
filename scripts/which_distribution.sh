#!/bin/sh
# Display Linux distribution
#
# Example:
#  Distributor ID: Debian
#  Description:	   Debian GNU/Linux 7.1 (wheezy)
#  Release:        7.1
#  Codename:       wheezy

lsb_release -a 2>/dev/null
