#!/bin/bash
#
# Install jenkins pluggin via Jenkins API
# Tested against Jenkins 2.9
#
# This should be run locally on the jenkins host. Script could be easily modified to 
# take the server in as an ARGV.
#
# Syntax example would be "./install_jenkins_via_api.sh admin somepasssword git" 
#
# This is a simple alternative to using jenkins-cli which may not be installed on the machine.
# Another option could be to download the hpi file in JENKINS_HOME/plugins, unzip and parse META-INF/MANIFEST.MF and
# forefill all deps. This is a slightly horrible method and would also require a jenkins reload or somesort -WC

if [ "$3" = "" ]
then
  echo "Usage: $0 <Jenkins_admin_username jenkins_admin_password jenkins_plugin version(optional)>"
  exit 1
fi

# Default version to latest if not speicifed
if [ "$4" = "" ]
then
  version="latest"
else 
  version=$2
fi

# Define ARGV vars rather than user $*
username="$1"
password="$2"
plugin="$3"
server=http://127.0.0.1:8080

# Grab Jenkins crumb
crumb=$(curl --user ${username}:${password} \
    $server/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))

# Make curl requet to URL
curl -X POST \
--user ${username}:${password} -H "${crumb}" --data "<jenkins><install plugin='${plugin}@${version}' /></jenkins>" \
--header 'Content-Type: text/xml' \
$server/pluginManager/installNecessaryPlugins
