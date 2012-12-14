%global cartridgedir %{_libexecdir}/openshift/cartridges/embedded/postgresql-9.1
%global frameworkdir %{_libexecdir}/openshift/cartridges/postgresql-9.1

Name: openshift-origin-cartridge-postgresql-9.1
Version: 0.0.1
Release: 1%{?dist}
Summary: Provides embedded PostgreSQL support

Group: Network/Daemons
License: ASL 2.0
URL: http://openshift.redhat.com
Source0: http://mirror.openshift.com/pub/origin-server/source/%{name}/%{name}-%{version}.tar.gz

BuildRoot:    %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch: noarch

BuildRequires: git
Requires: openshift-origin-cartridge-abstract
Requires: rubygem(openshift-origin-node)
Requires: postgresql >= 9
Requires: postgresql-server
Requires: postgresql-libs
Requires: postgresql-devel
Requires: postgresql-contrib
Requires: postgresql-ip4r
Requires: postgresql-jdbc
Requires: postgresql-plperl
Requires: postgresql-plpython
Requires: postgresql-pltcl
Requires: PyGreSQL
Requires: perl-Class-DBI-Pg
Requires: perl-DBD-Pg
Requires: perl-DateTime-Format-Pg
Requires: php-pear-MDB2-Driver-pgsql
Requires: php-pgsql
Requires: gdal
Requires: postgis
Requires: python-psycopg2
%if 0%{?rhel} <= 6 && 0%{?fedora} <=16
Requires: ruby-postgres
%endif
Requires: rubygem-pg
Requires: rhdb-utils
Requires: uuid-pgsql
Obsoletes: cartridge-postgresql-9.1

%description
Provides PostgreSQL cartridge support to OpenShift


%prep
%setup -q


%build
rm -rf git_template
cp -r template/ git_template/
cd git_template
git init
git add -f .
git config user.email "builder@example.com"
git config user.name "Template builder"
git commit -m 'Creating template'
cd ..
git clone --bare git_template git_template.git
rm -rf git_template
touch git_template.git/refs/heads/.gitignore


%install
rm -rf $RPM_BUILD_ROOT
rm -rf %{buildroot}
mkdir -p %{buildroot}%{cartridgedir}
mkdir -p %{buildroot}%{cartridgedir}/info/data/
mkdir -p %{buildroot}/%{_sysconfdir}/openshift/cartridges
cp LICENSE %{buildroot}%{cartridgedir}/
cp COPYRIGHT %{buildroot}%{cartridgedir}/
cp -r info %{buildroot}%{cartridgedir}/
cp -r git_template.git %{buildroot}%{cartridgedir}/info/data/
ln -s %{cartridgedir}/info/configuration/ %{buildroot}/%{_sysconfdir}/openshift/cartridges/%{name}
ln -s %{cartridgedir} %{buildroot}/%{frameworkdir}
ln -s %{cartridgedir}/../../abstract/info/hooks/update-namespace %{buildroot}%{cartridgedir}/info/hooks/update-namespace


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%attr(0750,-,-) %{cartridgedir}/info/hooks/
%attr(0750,-,-) %{cartridgedir}/info/data/
%attr(0750,-,-) %{cartridgedir}/info/build/
%config(noreplace) %{cartridgedir}/info/configuration/
%attr(0755,-,-) %{cartridgedir}/info/bin/
%attr(0755,-,-) %{cartridgedir}/info/lib/
%attr(0755,-,-) %{cartridgedir}/info/connection-hooks/
%attr(0755,-,-) %{frameworkdir}
%{_sysconfdir}/openshift/cartridges/%{name}
%{cartridgedir}/info/changelog
%{cartridgedir}/info/control
%{cartridgedir}/info/manifest.yml
%doc %{cartridgedir}/COPYRIGHT
%doc %{cartridgedir}/LICENSE


%changelog
* Fri Dec 14 2012 Krishna Raman <kraman@gmail.com> 0.0.1-1
- new package built with tito

