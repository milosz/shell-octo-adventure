#!/bin/sh
# Parse and process software raid [mdadm] events
# Requires additional configuration
# Source: https://blog.sleeplessbeastie.eu/2016/02/01/how-to-parse-and-process-linux-software-raid-events/

# Script requires an action and parameter to get started
if [ "$#" -lt 2 ]; then
  echo "Illegal number of parameters"
  exit 1;
fi

# Get action
action=$1;
shift;

# Parse action
case "$action" in
  "Fail")
    # Sample: Fail /dev/md1 /dev/sdb2
    # Action requires 2 parameters
    if [ "$#" -ne 2 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [Fail] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Device $2 failed on array $1";
    ;;
  "FailSpare")
    # Sample: FailSpare /dev/md1 /dev/sdb2
    # Action requires 2 parameters
    if [ "$#" -ne 2 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [FailSpare] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Spare device $2 failed on array $1";
    ;;
  "RebuildStarted")
    # Sample: RebuildStarted /dev/md1
    # Action requires 1 parameter
    if [ "$#" -ne 1 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [RebuildStarted] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Rebuild started on array $1";
    ;;
  "RebuildFinished")
    # Sample: RebuildFinished /dev/md1
    # Action requires 1 parameter
    if [ "$#" -ne 1 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [RebuildFinished] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Rebuild finished on array $1";
    ;;
  "SpareActive")
    # Sample: SpareActive /dev/md1 /dev/sdb2
    # Action requires 2 parameters
    if [ "$#" -ne 2 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [SpareActive] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Spare device $2 activated on array $1";
    ;;
  "DeviceDisappeared")
    # Sample: DeviceDisappeared /dev/md/1
    # Action requires 1 parameter
    if [ "$#" -ne 1 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [DeviceDisappeared] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "Array $1 disappeared";
    ;;
  "NewArray")
    # Sample: NewArray /dev/md1
    # Action requires 1 parameter
    if [ "$#" -ne 1 ]; then
      logger --priority "local0.debug" --tag "mdadm" \
             "Action [NewArray] Illegal number of parameters: $*";
      exit 1;
    fi
    # Perform custom action
    logger --priority "local0.notice" --tag "mdadm" "New array $1 has been detected";
    ;;
  *)
    # Perform test action
    logger --priority "local0.debug" --tag "mdadm" "Unknow action $action $*";
    ;;
esac
