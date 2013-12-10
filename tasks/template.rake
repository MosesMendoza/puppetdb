# Template task to handle all of puppetdb's erb templates
#
# Pkg::Util::File is defined in the packaging repo
# https://github.com/puppetlabs/packaging
#
task :template => [ :clean ] do

  mkdir_p "ext/files/debian"
  mkdir_p "ext/files/dev/redhat"
  mkdir_p "ext/files/systemd"

  templates = {
    # files for deb and rpm
    "ext/templates/log4j.properties.erb"               => "ext/files/log4j.properties",
    "ext/templates/config.ini.erb"                     => "ext/files/config.ini",
    "ext/templates/jetty.ini.erb"                      => "ext/files/jetty.ini",
    "ext/templates/repl.ini.erb"                       => "ext/files/repl.ini",
    "ext/templates/database.ini.erb"                   => "ext/files/database.ini",
    "ext/templates/puppetdb-foreground.erb"            => "ext/files/puppetdb-foreground",
    "ext/templates/puppetdb-import.erb"                => "ext/files/puppetdb-import",
    "ext/templates/puppetdb-export.erb"                => "ext/files/puppetdb-export",
    "ext/templates/puppetdb-anonymize.erb"             => "ext/files/puppetdb-anonymize",

    # files for deb
    "ext/templates/init_debian.erb"                    => "ext/files/debian/#{@name}.init",
    "ext/templates/puppetdb_default.erb"               => "ext/files/debian/#{@name}.default",
    "ext/templates/deb/control.erb"                    => "ext/files/debian/control",
    "ext/templates/deb/prerm.erb"                      => "ext/files/debian/#{@name}.prerm",
    "ext/templates/deb/postrm.erb"                     => "ext/files/debian/#{@name}.postrm",
    "ext/templates/deb/base.install.erb"               => "ext/files/debian/#{@name}.install",
    "ext/templates/deb/terminus.install.erb"           => "ext/files/debian/#{@name}-terminus.install",
    "ext/templates/deb/rules.erb"                      => "ext/files/debian/rules",

    "ext/templates/deb/changelog.erb"                  => "ext/files/debian/changelog",
    "ext/templates/deb/preinst.erb"                    => "ext/files/debian/#{@name}.preinst",
    "ext/templates/deb/postinst.erb"                   => "ext/files/debian/#{@name}.postinst",
    "ext/templates/logrotate.erb"                      => "ext/files/debian/#{@name}.logrotate",
    "ext/templates/init_debian.erb"                    => "ext/files/#{@name}.debian.init",

    # files for rpm
    "ext/templates/logrotate.erb"                      => "ext/files/puppetdb.logrotate",
    "ext/templates/init_redhat.erb"                    => "ext/files/puppetdb.redhat.init",
    "ext/templates/init_suse.erb"                      => "ext/files/puppetdb.suse.init",
    "ext/templates/puppetdb_default.erb"               => "ext/files/puppetdb.default",

    # developer utility files for redhat
    "ext/templates/dev/redhat/redhat_dev_preinst.erb"  => "ext/files/dev/redhat/redhat_dev_preinst",
    "ext/templates/dev/redhat/redhat_dev_postinst.erb" => "ext/files/dev/redhat/redhat_dev_postinst",

    # files for OpenBSD
    "ext/templates/init_openbsd.erb"                   => "ext/files/puppetdb.openbsd.init",

    # files for systemd
    "ext/templates/puppetdb.service.erb"               => "ext/files/systemd/#{@name}.service"
  }

  templates.each { |t,f| Pkg::Util::File.erb_file(t, f, false, :binding => binding) }

  chmod 0700, "ext/files/puppetdb-foreground"
  chmod 0700, "ext/files/puppetdb-import"
  chmod 0700, "ext/files/puppetdb-export"
  chmod 0700, "ext/files/puppetdb-anonymize"
  chmod 0755, "ext/files/debian/rules"
  cp_pr FileList["ext/templates/deb/*"].reject { |f| File.extname(f) == ".erb" }, "ext/files/debian"
  cp_pr "ext/templates/puppetdb-ssl-setup", "ext/files"
  chmod 0700, "ext/files/puppetdb-ssl-setup"
  chmod 0644, "ext/files/systemd/#{@name}.service"
end
