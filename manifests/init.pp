# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include splunk_forwarder
class splunk_forwarder {
    include splunk_forwarder::pre_install
    include splunk_forwarder::install
    include splunk_forwarder::post_install
    include splunk_forwarder::input
}