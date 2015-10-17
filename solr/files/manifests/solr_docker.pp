node default {
$muninservers='127.0.0.1'
$memcache_host='localhost'
$tomcat_manager_script_user='admin'
$tomcat_manager_script_pwd='cupid559'
$tomcat_manager_gui_pwd='AdmTomMgr'
$solr_master='localhost'
#$we7_environment='docker'
#$::we7_environment='docker'



  #include network

  include ::java, ::munin
  include ::repository::prod
#  include ::repository::build_prod
#  include ::memcached, ::resources::packages, ::sysctl
  
# Solr
include ::solr::master
}


