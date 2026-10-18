# Define Sailfish as it is absent
%if !0%{?fedora}
%define sailfishos 1
%endif

%if 0%{?sailfishos}
# "Harbour RPM packages should not provide anything."
%define __provides_exclude_from ^%{_datadir}/.*$
%endif

Name:       harbour-confla

Summary:    Conference schedule application
Version:    0.1.0
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://github.com/jmlich/harbour-confla
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   sailfish-components-pickers-qt5
Requires:   qt5-qtdeclarative-import-positioning
Requires:   qt5-qtdeclarative-import-localstorage
Requires:   qt5-qtgraphicaleffects
Requires:   nemo-qml-plugin-notifications-qt5
Requires:   libkeepalive
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Sql)
BuildRequires:  pkgconfig(Qt5Widgets)
BuildRequires:  pkgconfig(Qt5Positioning)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils
BuildRequires:  git
BuildRequires:  cmake

%description
Conference schedule application for Sailfish OS

%if 0%{?_chum}
Title: Confla
Type: desktop-application
Categories:
 - Office
Custom:
  Repo: https://github.com/jmlich/harbour-confla
PackageIcon: https://raw.githubusercontent.com/jmlich/harbour-confla/master/icons/scalable/harbour-confla.svg
Links:
  Homepage: https://github.com/jmlich/harbour-confla
  Bugtracker: https://github.com/jmlich/harbour-confla/issues
%endif

%prep
%setup -q -n %{name}-%{version}

%build
%if 0%{?sailfishos}
    cmake \
        -DCMAKE_INSTALL_PREFIX:PATH='/usr' \
        -DFLAVOR=silica \
        .
%else
    cmake \
        -DCMAKE_INSTALL_PREFIX:PATH='/usr' \
        -DFLAVOR=kirigami \
        .
%endif

cmake --build "." %{?_smp_mflags} --verbose

%install
rm -rf %{buildroot}
DESTDIR=%{buildroot} cmake --install .

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
