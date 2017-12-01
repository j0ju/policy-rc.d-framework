# Framework for policy-rc.d in Debian / Ubuntu

This is a very simplistic script to change the default behavior of Debian and Ubunutu autostarting services after installation.
This often interferes with config management or service/cluster managers in large productive environments.

It does prevent automatic starting of services after ```apt-get install``` or similar.

It does not manage autostart of services via Upstart/Init/Systemd.

## Defaults

Services are not started after installation.

Actions defined in some initscripts like rotate or reload need eg. for log rotation are not handled as normal.

## Config files

### /etc/default/policy-rc.d

Here the defaults for unhandled services or actions are defined.

### Files below /etc/policy-rc.d/

These files are named $SERVICE-$ACTION.

SERVICE is the service name passed to invoke-rc.d .
eg.:
 * nginx
 * rsyslog, apache

DEFAULTt is an allowed service name.

ACTION is the action passed to invoke-rc.d . The allowed names are described in the Debian Policy and Debian Manual.
The frameware does not check if an action is allowed. (In fact invoke-rc.d already tells on invokation via STDERR, that an action
is not in the list of known actions, but does call out to the initscript with that action anyway.
eg.:
 * start
 * restart
 * stop
 * reload

So the files might have names like
 * nginx-reload
 * apache-start
 * rsyslog-rotate

If no file for the $SERVICE-$ACTION is found, the file DEFAULT-$ACTION is used, if that is not found, too, the default action
is used defined in /etc/default/policy-rc.d is used.

A file /etc/policy-rc.d/$SERVICE-$ACTION must be executable and should contain only command to exit with an defined exit code.

If /etc/default/policy-rc.d is empty the default exit code is 101, signaling invoke-rc.d not to fullfill the request.

