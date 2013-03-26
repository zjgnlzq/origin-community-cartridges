%global cartridgedir %{_libexecdir}/openshift/cartridges/v2/ceylon
%global frameworkdir %{_libexecdir}/openshift/cartridges/v2/ceylon

Name: openshift-origin-cartridge-ceylon
Version: 0.1.7
Release: 1%{?dist}
Summary: Ceylon cartridge
Group: Development/Languages
License: ASL 2.0
URL: https://openshift.redhat.com
#TODO source
Source0: http://mirror.openshift.com/pub/origin-community-cartridges/source/%{name}/%{name}-%{version}.tar.gz
Requires: openshift-origin-cartridge-abstract
Requires: java-1.7.0-openjdk
Requires: ceylon >= 0.5
Requires: rubygem(openshift-origin-node)

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

%description
Provides ceylon support to OpenShift

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{cartridgedir}
mkdir -p %{buildroot}/%{_sysconfdir}/openshift/cartridges/v2
cp -r * %{buildroot}%{cartridgedir}/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%dir %{cartridgedir}
%dir %{cartridgedir}/bin
%dir %{cartridgedir}/env
%dir %{cartridgedir}/metadata
%dir %{cartridgedir}/versions
%attr(0755,-,-) %{cartridgedir}/bin/
%attr(0755,-,-) %{frameworkdir}
%{cartridgedir}/metadata/manifest.yml
%doc %{cartridgedir}/README.md

%changelog
* Tue Mar 26 2013 Matej Lazar <matejonnet@gmail.com> 0.1.7-1
- Spec source. (matejonnet@gmail.com)
- Spec source. (matejonnet@gmail.com)
- Spec source. (matejonnet@gmail.com)

* Tue Mar 26 2013 Matej Lazar <matejonnet@gmail.com> 0.1.6-1
- new package built with tito

* Thu Mar 21 2013 Matej Lazar <matejonnet@gmail.com> 1.0.23-1
- Welcome page endpoint. (matejonnet@gmail.com)

