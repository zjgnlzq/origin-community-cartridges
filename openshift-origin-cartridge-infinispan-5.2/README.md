Infinispan 5.2 cartridge for OpenShift

Requires Infinispan 5.2.x installed in /opt/infinispan-5.2

Work in progress :-)

NOTE: in order to create a new infinispan-5.2 app, you must:
  * edit cartridge_cache.rb (e.g. /usr/lib/ruby/gems/1.8/gems/openshift-origin-controller-1.0.12/lib/openshift-origin-controller/app/models/cartridge_cache.rb):
    - add "infinispan-5.2" to FRAMEWORK_CART_NAMES
    - restart the broker
  * edit /usr/libexec/openshift/cartridges/abstract/info/lib/util
    - add "infinispan-5.2" to get_installed_framework_carts
