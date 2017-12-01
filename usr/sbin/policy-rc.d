#!/bin/sh
# policy rc.d - helper
#  1. default policy = 101
#  2. if exist load from /etc/default/policy-rc.d
#  3. if exist use shell snippet from
#     * /etc/policy-rc.d/$SERVICE-$ACTION
#     * /etc/policy-rc.d/$SERVICE
#     * /etc/policy-rc.d/DEFAULT-$ACTION
#     * /etc/policy-rc.d/DEFAULT
#     these shell snippet should mostly only contain "exit $RC" statements
#     see https://people.debian.org/~hmh/invokerc.d-policyrc.d-specification.txt
#  4. Fallback, if no file of above exist, exit with DEFAULT_POLICY

#( # debug helper
# TAG="$(date "+%Y-%m-%d %H:%M:%S") ${0##*/}[$$]"
#  echo "$TAG: cmdline '$0 $*'"
#  env | egrep -v '^(LC_|LANG)'
#) >> /var/log/policy-rc.d.log >&2

SERVICE="$1"
ACTION="$2"
RUNLEVEL="$3"

DEFAULT_FILE=/etc/default/policy-rc.d
CONFIG_DIR=/etc/policy-rc.d

POLICY_SUCCESS=0
POLICY_UNKNOWN=100
POLICY_DENIED=101
POLICY_SUBSYS_ERROR=102
POLICY_SYNTAX_ERROR=103
POLICY_ALLOWED=104
POLICY_UNCERTAIN=105     # WTF
POLICY_FALLBACK=106

DEFAULT_POLICY=101
if [ -f "$DEFAULT_FILE" ]; then
  . "$DEFAULT_FILE"
fi

for cfg in "$CONFIG_DIR/$SERVICE-$ACTION" "$CONFIG_DIR/$SERVICE" "$CONFIG_DIR/DEFAULT-$ACTION" "$CONFIG_DIR/DEFAULT"; do
  if [ -f "$cfg" ]; then
    if [ -x "$cfg" ]; then
      exec "$cfg" "$SERVICE" "$ACTION" "$RUNLEVEL"
    fi
  fi
done

exit "$DEFAULT_POLICY"
# vim: ts=2 sw=2 et ft=sh
