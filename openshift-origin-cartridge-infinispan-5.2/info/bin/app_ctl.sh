#!/bin/bash -ex

source "/etc/openshift/node.conf"
source ${CARTRIDGE_BASE_PATH}/abstract/info/lib/util

# Import Environment Variables
for f in ~/.env/*
do
    . $f
done

cartridge_type=$(get_cartridge_name_from_path)

# gear directory i.e. /var/lib/openshift/<uid>/infinispan-5.2
cartridge_dir=$OPENSHIFT_HOMEDIR/$cartridge_type

translate_env_vars

if ! [ $# -eq 1 ]
then
    echo "Usage: \$0 [start|restart|graceful|graceful-stop|stop|threaddump]"
    exit 1
fi

validate_run_as_user

. app_ctl_pre.sh

isrunning() {
    # Check for running app
    #pid=`pgrep -U $uid -f ".*infinispan.*${OPENSHIFT_INTERNAL_IP}.*" 2> /dev/null`
    pid=`jps -lmv | grep ".*infinispan.*${OPENSHIFT_INTERNAL_IP}.*" | awk {"print $1"} 2> /dev/null`
    if [ -n "$pid" ]; then
      return 0
    fi
    # not running
    return 1
}

start_infinispan() {
  src_user_hook pre_start_${cartridge_type}
  set_app_state started

  conf_dir="${cartridge_dir}/conf/"

  # Create a link for each file in user config to server standalone/config
  if [ -e ${OPENSHIFT_REPO_DIR}.openshift/config ]; then
    for f in ${OPENSHIFT_REPO_DIR}.openshift/config/*; do
      target=$(basename $f)

      # Remove any target that is being overwritten
      if [ -e $conf_dir/$target ]; then
        echo "Removing existing $target"
        rm -f "$conf_dir/$target"
      fi
      ln -s $f $conf_dir
    done
  fi

  # Now go through the configuration and remove any stale links from previous deployments
  # TODO AMG I don't think the below will actually do anything
  for f in $conf_dir/*; do
    target=$(basename $f)
    if [ ! -e $f ]; then
      echo "Removing obsolete $target"
      rm -rf $f
    fi
  done

  infinispan_protocol=${INFINISPAN_PROTOCOL:-hotrod}
  infinispan_worker_threads=${INFINISPAN_WORKER_THREADS:-20}
  infinispan_idle_timeout=${INFINISPAN_IDLE_TIMEOUT:-1}
  infinispan_tcp_no_delay=${INFINISPAN_TCP_NO_DELAY:-true}

  export JVM_PARAMS="-DINFINISPAN_LOG_DIR=$OPENSHIFT_INFINISPAN_LOG_DIR"
  export JVM_PARAMS="$JVM_PARAMS -DINFINISPAN_JGROUPS_EXTERNAL_ADDR=$OPENSHIFT_GEAR_DNS"
  export JVM_PARAMS="$JVM_PARAMS -DINFINISPAN_JGROUPS_EXTERNAL_PORT=$OPENSHIFT_INFINISPAN_CLUSTER_PROXY_PORT"
  export JVM_PARAMS="$JVM_PARAMS -DINFINISPAN_JGROUPS_BIND_ADDR=$OPENSHIFT_INTERNAL_IP"
  export JVM_PARAMS="$JVM_PARAMS -DINFINISPAN_JGROUPS_INITIAL_HOSTS=$OPENSHIFT_INFINISPAN_CLUSTER"
  export JVM_PARAMS="$JVM_PARAMS -DINFINISPAN_JGROUPS_AUTH_VALUE=$OPENSHIFT_INFINISPAN_CLUSTER"

  nohup ${cartridge_dir}/bin/startServer.sh \
    -r $infinispan_protocol \
    -l $OPENSHIFT_INTERNAL_IP \
    -p $OPENSHIFT_INTERNAL_PORT \
    -t $infinispan_worker_threads \
    -i $infinispan_idle_timeout \
    -n $infinispan_tcp_no_delay \
    -c $conf_dir/infinispan.xml > /dev/null 2>&1 &

  echo $! > /dev/null

  if [ $? -eq 0 ]; then
    run_user_hook post_start_${cartridge_type}
  fi
}

stop_infinispan() {
  src_user_hook pre_stop_${cartridge_type}
  set_app_state stopped
  kill -TERM $pid > /dev/null 2>&1
  wait_for_stop $pid
  run_user_hook post_stop_${cartridge_type}
}

case "$1" in
    start)
        _state=`get_app_state`
        if [ -f ${cartridge_dir}/run/stop_lock -o idle = "$_state" ]
        then
            echo "Application is explicitly stopped!  Use 'rhc app start -a ${cartridge_type}' to start back up." 1>&2
            exit 0
        else
            if isrunning
            then
                echo "Application is already running!" 1>&2
                exit 0
            fi
            start_infinispan
        fi
    ;;
    graceful-stop|stop)
        if isrunning
        then
            stop_infinispan
        else
            echo "Application is already stopped!" 1>&2
            exit 0
        fi
    ;;
    restart|graceful)
        if isrunning
        then
            stop_infinispan
        fi
        start_infinispan
    ;;
    reload)
        # the plugin automatically does a reload prior to a build - so a no-op here
        exit 0
    ;;
    status)
        if ! isrunning; then
            echo "Application '${cartridge_type}' is either stopped or inaccessible"
            exit 0
        fi
        print_user_running_processes `id -u`
        exit 0
    ;;
esac
