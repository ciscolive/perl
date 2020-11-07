# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox;

use 5.008_008;  # Require Perl 5.8.8 or higher.

use Carp;

#
my $status_code;
my $status_detail;
my $options;

our $VERSION = "8.00260060371069";

sub __options {
    my $opt = shift;
    return $options->{$opt};
}

sub import {
    my ($class, @options) = @_;

    #
    $options->{'accessrights'} = 0;

    foreach my $current (@options) {
        if ($current && $current eq ':hostaddress') {
            $options->{'hostaddress'} = 1;
            require Infoblox::IBAP::DHCP_HostAddr;
        } elsif ($current && $current eq ':ipv6connection') {
            $options->{'ipv6'} = 1;
            require Net::INET6Glue::INET_is_INET6;
            require LWP::UserAgent;

            if ($] < 5.014002) {
                die "IPv6 connections are supported only for perl version 5.14.2 and onwards, this is version $]";
            }

            if ($LWP::UserAgent::VERSION < 6.03 ) {
                die "IPv6 connections are supported only for libwww-perl version 6.03 and onwards, this is version " . $LWP::UserAgent::VERSION;
            }
        } elsif ($current && $current eq ':accessrights') {
            $options->{'accessrights'} = 1;
        } elsif ($current && $current eq ':noaccessrights') {
            $options->{'accessrights'} = 0;
        }
        else {
            die "Unrecognized import option $current for Infoblox.pm";
        }
    }

    #
    #
    require Infoblox::Session;
    require Infoblox::Result;
    require Infoblox::Util;
    require Infoblox::IBAPObjects;
}

sub new {
    my $class = shift;
    my $self  = {};

    bless $self, $class;
    return $self;
}

sub status_code {
    my $class = shift;
    my $code  = shift;
    if (defined $code) {
        $status_code = $code;
    } else {
        return $status_code;
    }
}

sub status_detail {
    my $class  = shift;
    my $detail = shift;
    if (defined $detail) {
        $status_detail = $detail;
    } else {
        return $status_detail;
    }
}

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#

1;

__END__

=head1 NAME

Infoblox - API Installation and Usage Instructions

=head1 VERSION

 8.2.6-371069

=head1 Infoblox API Installation Instructions

Infoblox provides a Perl API (application programming interface) to help facilitate the integration of the Infoblox device into network environments. The Infoblox DMAPI (Data and Management API) is a set of packages delivered with the Infoblox device to install the package.  Use the usual Perl module installation tools on your management system to install the package. For Windows systems using the ActiveState build of Perl, the package is called PPM ("Perl Package Manager" or "Programmer's Package Manager"). For UNIX systems, the package is called CPAN, a global archive of Perl resources.


L<Windows Management System>

L<Unix Management System>


=head2 Windows Management System

To install the Infoblox DMAPI packages on a Windows management system, download and install PPM (from L<http://www.activestate.com/>). Then do the following:

L<1a.   Install Crypt::SSLeay and libwww-perl.> for IPv4 connections

L<1b.   Install the supporting libraries.> for IPv6 connections

L<2.   PPM 3.x: Add the Infoblox device as a repository.>

L<3.   PPM 3.x: Search the Infoblox device for Infoblox packages.>

L<4.   PPM 3.x: Install Infoblox packages on your management system.>

L<5.   PPM 4.0: Fetch and install Infoblox packages.>

=head3 Requirements for Windows Management Systems and IPv4 connections

- Perl 5.8.8 or later

- For Windows management systems: the ActiveState version of Perl 5.8.8 or later with PPM 3.x or later

- Crypt::SSLeay version 0.51 or later (and its dependencies: ssleay32.dll and libeay32.dll)

- LWP::UserAgent version 5.813 or later

- XML::Parser

=head3 Requirements for Windows Management Systems and IPv6 connections

- Perl 5.14.2 or later

- For Windows management systems: the ActiveState version of Perl 5.14.2 or later with PPM 3.x or later

- LWP::UserAgent version 6.02 or later and relevant dependencies, including LWP::Protocol::https

- Net::INET6Glue

- XML::Parser

=head3 1a.   Install Crypt::SSLeay and libwww-perl.

=over

1.0 Check your Perl version.

The Crypt::SSLeay package is Perl version sensitive. Perl version 5.8.x requires different packages than 5.10.x. To check the Perl version installed, enter the command: perl -v.

If Perl 5.8.x is installed, the command will return the following:

 C:\>perl -v
 This is perl, v5.8.8 built for MSWin32-x86-multi-thread...

If Perl 5.10.x is installed, the command will return the following:

 C:\>perl -v
 This is perl, v5.10.0 built for MSWin32-x86-multi-thread...


1.1 Install Crypt-SSLeay.

The Crypt::SSLeay package allows you to make an HTTPS connection to the Infoblox device. Crypt::SSLeay is not part of the core Perl distribution.  To check if it is installed, enter the command: ppm query Crypt-SSLeay.  If the Crypt-SSLeay package is already installed, the query returns the following result:

 C:\>ppm query Crypt-SSLeay
 Querying target 1 (ActivePerl 5.8.8.817)
 1. Crypt-SSLeay [0.51] OpenSSL glue that provides LWP https

If the Crypt::SSLeay package is not installed, the query returns the following:

 C:\>ppm query Crypt-SSLeay
 Querying target 1 (ActivePerl 5.8.8.817)
 No matches for 'Crypt-SSLeay; see 'help query'.

To install Crypt::SSLeay (and its dependencies ssleay32.dll and libeay32.dll) one needs to either build it from the source distribution, or locate a precompiled Crypt-SSLeay.ppd archive.

Note that Crypt::SSLeay does not support TLSv1.1 and higher until version 0.58. To use TLS v1.1 and higher, you must install Crypt::SSLeay version 0.58 and higher.

1.2 Install libwww-perl.

If you need to update LWP::UserAgent, then you will have to install the latest libwww-perl package.

If the PPM version is 3.x, you will first need to add a PPM repository:

 C:\> ppm repo add bribes http://www.bribes.org/perl/ppm

To install libwww-perl:

 C:\> ppm install libwww-perl -force

=back

=head3 1b.   Install the supporting libraries.

Infoblox recommends using the ActiveState ppm tool to install the needed modules and dependencies, which may already be installed as part of the perl distribution. For some platforms, some Perl modules may not be available at the time of this writing. an example: Net::INET6Glue, which depends on IO::Socket::INET6; Net::INET6Glue can be compiled following the instructions at

 http://www.activestate.com/blog/2010/10/how-install-cpan-modules-activeperl

using the Microsoft(r) SDK section of the instructions. Please refer to ActiveState's website and documentation for further questions.

=head3 2.   PPM 3.x: Add the Infoblox device as a repository.

=over

The following steps add the Infoblox device as a repository in your PPM 3.x configuration, included with Active Perl from version 5.8.0.802 to 5.8.8.817.

(For PPM 4.0, included with ActivePerl 5.8.8.818 and later, see "5.   PPM 4.0: Fetch and install Infoblox packages.")

B<2.1 Add a PPM repository to the configuration by issuing the ppm repository command;>

=over

*  For <repo_name>, type a meaningful name for the repository, such as 'Infoblox-device'.
*  For <ip_addr>, type the IP address that you use for managing the Infoblox device or a
resolvable domain name (for a grid, use the address or domain name of the grid master).

 C:\> ppm repo add <repo_name> https://<ip_addr>/api/dist/ppm
 Repositories:
 [1] <repo_name>
 [2] ActiveState Package Repository

(Note that the packages are connected via HTTPS, not HTTP. You only need to add the repository once.)

=back

B<2.2 To ensure that you have the correct URL, open a Web browser and visit the URL you specified for the repository. If the URL is correct, you can see a directory listing.>

=over

=back

=back

=head3 3.   PPM 3.x: Search the Infoblox device for Infoblox packages.

=over

Start PPM from a command shell:

 C:\> ppm
 PPM - Programmer's Package Manager version 3.4.
 Copyright (c) 2001 ActiveState Software Inc.  All Rights Reserved.

 Entering interactive shell. Using Term::ReadLine::Perl as readline library.

 Type 'help' to get started.

 ppm>

 Use PPM to find the Infoblox package:

 ppm> search Infoblox
 Searching in Active Repositories
 1. Infoblox [4.9999990014709] Infoblox Data and Management API 4.x

=back

=head3 4.   PPM 3.x: Install Infoblox packages on your management system.

=over

Install the Infoblox package with PPM:

 ppm> install Infoblox
 ====================
 Install 'Infoblox' version 4.9999990014709 in ActivePerl 5.8.8.817.
 ====================
 Downloaded 167481 bytes.
 ...
 Successfully installed Infoblox version 4.9999990014709 in ActivePerl 5.8.8.817.

=back

=head3 5.   PPM 4.0: Fetch and install Infoblox packages.

=over

There is a bug in PPM version 4.0 which is included in ActivePerl 5.8.8.818 and 5.8.8.819 which prevents PPM 4.0 from accessing a module archive with https.  This bug, and ActiveState's workaround is described at:

http://bugs.activestate.com/show_bug.cgi?id=52508

If you have ActivePerl 5.8.8.818 or 5.8.8.819 (use perl -v at a command line to see), either upgrade to ActivePerl 5.8.8.820 or use the workaround described in the bug: http://bugs.activestate.com/show_bug.cgi?id=52508

You can also work around the bug by following the steps in section 5.3.

If you have ActivePerl 5.8.8.820 installed, skip the patch step in 5.1 and immediately install the package by following the steps in section 5.2.

B<5.1   PPM 4.0: Patch lib/ActivePerl/PPM/limited_inc.pm>

=over

If you have ActivePerl 5.8.8.818 or 5.8.8.819, please patch your PPM installation so PPM will be able to find modules stored in repositories accessed by https.

As shown in

http://bugs.activestate.com/show_bug.cgi?id=52508

apply this patch one time to your ActiveState PPM installation for each win32 client:


 Index: lib/ActivePerl/PPM/limited_inc.pm
 --- lib/ActivePerl/PPM/limited_inc.pm.~1~ Tue Nov 28 16:01:09 2006
 +++ lib/ActivePerl/PPM/limited_inc.pm Tue Nov 28 16:01:09 2006
 @@ -9,7 +9,7 @@
 (my $dir = __FILE__) =~ s,/ActivePerl/PPM/.*,,;
 Make a new directory, naming it something like "ibpack", and then change the command prompt to that directory.
 if (grep $_ eq $dir, @INC) {
 - shift(@INC) while $INC[0] ne $dir;
 + push(@INC, shift(@INC)) while $INC[0] ne $dir;
 }

 1;

To find the full path to this file on your system, use perl -V at the command line.  The contents of @INC are at the end of the output.  The limited_inc.pm file is in the lib directory, not in the site/lib directory.

If you are unfamiliar with diffs, the + and - notation just means to replace the line:

 shift(@INC) while $INC[0] ne $dir;

line with the

 push(@INC, shift(@INC)) while $INC[0] ne $dir;

When complete, the lines of the patched limited_inc.pm should look like:

 if (grep $_ eq $dir, @INC) {
 # patch from http://bugs.activestate.com/show_bug.cgi?id=52508
 #    shift(@INC) while $INC[0] ne $dir;
 push(@INC, shift(@INC)) while $INC[0] ne $dir;
 }

Continue on to step 5.2

=back

B<5.2   PPM 4.0: Install the Infoblox modules>

=over

Enter the following command, substituting the IP address or resolvable hostname of the Infoblox device for <ip_addr>:

C:\tmp>ppm install https://<ip_addr>/api/dist/ppm/Infoblox.ppd

or you can use the GUI version of PPM by running the GUI, searching for the Infoblox module and installing it in the usual way.

=back

B<5.3   PPM 4.0 Alternate Work Around to Install>

=over

Make a new directory and name the directory, for example, "ibpack". Then change the command prompt to that directory.

Make a new directory, naming it something like "ibpack", and then change the command prompt to that directory.

 C:\> md ibpack

 C:\> cd ibpack

 C:\ibpack>

Next, transfer the files that contain the module distribution from the Infoblox device to your management system using 'lwp-request'. You must transfer two files: a description file, and the main distribution. The description file is always named "Infoblox.ppd".

Enter the following command, substituting the IP address or resolvable hostname of the Infoblox device for <ip_addr>:

 C:\ibpack> lwp-request https://<ip_addr>/api/dist/ppm/Infoblox.ppd > Infoblox.ppd

View the Infoblox.ppd file:

 C:\ibpack> type Infoblox.ppd
 <?xml version="1.0" encoding="UTF-8"?>
 <SOFTPKG NAME="Infoblox" VERSION="4,999999001478,0,0">
 <TITLE>Infoblox</TITLE>
 <ABSTRACT>Infoblox Data and Management API 4.x</ABSTRACT>
 <AUTHOR>Infoblox, Inc.</AUTHOR>
 <IMPLEMENTATION>
 <CODEBASE HREF="Infoblox-4.999999001478.tar.gz" />
 </IMPLEMENTATION>
 </SOFTPKG>

The file name of the main distribution package is contained in the HREF attributes of the CODEBASE element. In the output shown above, it is "Infoblox-4.999999001478.tar.gz". Use lwp-request to fetch that file.

 C:\ibpack> lwp-request https://<ip_addr>/api/dist/ppm/Infoblox-4.999999001478.tar.gz > Infoblox-4.999999001478.tar.gz

Use PPM to install the Infoblox DMAPI from the local file system:

 C:\ibpack> ppm install Infoblox.ppd
 Unpacking Infoblox-4.999999001478...done
 Generating HTML for Infoblox-4.999999001478...done
 Installing to site area...done
 64 files installed

The installation is complete.


Uninstalling and Reinstalling the Infoblox Package

After you configure PPM to search the Infoblox repository, use the appropriate command to uninstall and reinstall the Infoblox package:

 ppm> uninstall Infoblox
 ====================
 Remove 'Infoblox' version 4.9999990014709 in ActivePerl 5.8.8.817.
 ====================
 ...
 Successfully removed Infoblox version 4.9999990014709 from ActivePerl 5.8.8.817.

 ppm> install Infoblox
 ====================
 Install 'Infoblox' version 4.9999990014709 in ActivePerl 5.8.8.817.
 ====================
 ...
 Successfully installed Infoblox version 4.9999990014709 in ActivePerl 5.8.8.817.

=back

=back

=head2 Unix Management System

=head3 Requirements for Unix Management Systems

For IPv4 connections the following are required

- Perl 5.8.8 or later

- Crypt::SSLeay version 0.51 or later

- LWP::UserAgent version 5.813 or later

- XML::Parser

For IPv6 connections the following are required

- Perl 5.14.2 or later

- LWP::UserAgent version 6.02 or later and relevant dependencies, including LWP::Protocol::https

- Net::INET6Glue

- XML::Parser

to easily install the required libraries it is recommented to use CPAN, after installing perl run

 perl -e shell -MCPAN

and once configured simply run

 install LWP::UserAgent
 install XML::Parser

and the other packages you need depending on IPv4 or IPv6 accessibility.

=head3 DIRECT INSTALLATION

To install the Infoblox DMAPI packages on a UNIX management system, first download and install the API package from:

 https://<ip_addr>/api/dist/CPAN/authors/id/INFOBLOX/

where ip_addr is the IP address of the appliance. Then locate and download the file Infoblox-xxxxxxx.tar.gz
where xxxxxxx is an integer depending on your API package version.

After you download the package, extract it to a temporary directory with:

 tar xvfz Infoblox-xxxxxxx.tar.gz

Then execute the following commands:

 cd Infoblox-xxxxxxx/
 perl Makefile.PL
 make
 make install

Optionally, before you install, test the package by running:

 make test

The installation is complete.

=head1 Infoblox API Usage Guidelines

The usage instructions are provided to assist you in using the Infoblox API.

=head2 Library options

The Infoblox library can optionally be invoked by supplying the following options

  :accessrights     - If this is specified, 'Infoblox::Grid::Admin::Group' sends a request for 'Infoblox::Grid::Admin::Permission' to set the member 'permission_list'.
  :noaccessrights   - If this is specified, 'Infoblox::Grid::Admin::Group' does not send a request for 'Infoblox::Grid::Admin::Permission' and the member 'permission_list' is not set. This is specified by default.
  :ipv6connection   - This will allow the API to connect to IPv6 members.
  :hostaddress      - if this is specified the new 'Infoblox::DHCP::HostAddr' and 'Infoblox::DHCP::IPv6HostAddr' types will be supported, see 'Infoblox::DNS::Host' for more information

for example, to enable :ipv6connection the use line would be

  use Infoblox qw ( :ipv6connection );

=head2 UTF8 Considerations

=over

If there are utf-8 characters in your script, remember to use the pragma 'use utf8'.  If you need more information, please see http://search.cpan.org/~nwclark/perl-5.8.8/lib/utf8.pm on the utf8 pragma.

=back

=head2 search() Considerations

=over

When using the search() method, you can retrieve more information than expected. Include additional checks for exact matches.

=back

=over

=item B<Example>

 my @result_array = $session->search(
        "object" => "Infoblox::DNS::Record::A",
        "name" => "infoblox.com" );

 my $obj;

 foreach my $match (@result_array)
 {
    if( ($match->name() eq "infoblox.com") && ($match->ipv4addr() eq "2.2.2.2") )
    {
       print "Matches\n";
       $obj = $match;
    }
 }

=back

=head2 Object inheritance

=over

Values set in PAPI object members might differ from the effective value used for that particular member during product operation, which could be a value inherited from the Grid or the Grid Member depending on the particular object in question and the state of the object override flags.

=back

=head1 Alternate installation instructions

The following is provided for reference purposes only, as CPAN::Site has not supported this installation method for some time.

=head3 CPAN INSTALLATION (obsolete, only for CPAN::Site pre 1.02)

To install the Infoblox DMAPI packages on a UNIX management system, first download and install ActivePerl (from www.activestate.com), and then do the following steps:

L<1.   Install Crypt::SSLeay and CPAN::Site on your management system.>

L<2.   Run CPAN::Site, instead of CPAN.>

L<3.   Add the Infoblox device URL to the top of the CPAN URL list.>

L<4.   (Optional) Reduce the number of CPAN fetch methods.>

L<5.   Reload the CPAN::Site index.>

L<6.   Install the Infoblox package on your management system.>

Typically, the installation is done at the root level. See perlfaq8 under the question "How do I keep my own module/library directory?" for instructions on how to install a module as a user other than root.

If you have never used CPAN on the client UNIX machine, you will need to follow the instructions, when you run it for the first time, you will be prompted for many configuration variables.  Follow the procedure at 0.  First Time CPAN Installation

CPAN::Site Overview

The Infoblox modules are installed using a variant of CPAN named CPAN::Site.  See

http://search.cpan.org/search?mode=module&query=CPAN%3A%3ASite

for more information on CPAN::Site.

In the usual CPAN model, there is a single CPAN repository, and every copy is a full and complete copy of every available package.  In the CPAN::Site model, there are multiple repositories which may have a given module. As the Infoblox modules are deployed with CPAN::Site, you must use CPAN::Site instead of CPAN to install them.  This is covered in more detail in step 2.  If you use CPAN instead of CPAN::Site, typically the installation process will not find the Infoblox module in step 5.

One consequence of using CPAN::Site is the installation searches multiple sites for the same set of files, finding some of them in some locations but not in others. This is a normal result. Additionally, CPAN has the ability to search for and fetch files using several different mechanisms: curl, FTP, lynx, ncftpget, wget, and LWP. Both CPAN and CPAN::Site use each of these methods in turn when it tries to find files. If the CPAN configuration lists many sites in its URL list and many access methods, the installation may take a long time while CPAN::Site tries each of the access methods on each of the listed sites. For this reason, Infoblox recommends that you reduce the number of sites in the URL list and the number of access methods as described in step 4.

If you are installing a new version of the Infoblox modules and your urllist configuration still includes the Infoblox appliance, skip directly to steps 5 and 6.

=head4 First Time CPAN Installation

=over

If you have never used CPAN on this client machine before, enter the following command:

 [root@lx2 ~]# perl -MCPAN -e shell

and follow the prompts through the CPAN configuration.  You can accept all of the defaults, except for the list of CPAN sites close to your physical location.  Navigate the menus and choose 1 or 2 CPAN sites that are close to your site.  When your configuration choices are complete, exit CPAN by typing exit at the prompt.

=back

=head4 1.   Install Crypt::SSLeay and CPAN::Site on your management system.

=over

The Crypt::SSLeay package allows you to make an HTTPS connection to the Infoblox device. If Crypt::SSLeay is not already installed, open a terminal window, login as the root user, and use CPAN to install the Crypt::SSLeay package and all its dependencies:

 lx> perl -MCPAN -e 'install Crypt::SSLeay'

Install the CPAN::Site module:

 lx> perl -MCPAN -e 'install CPAN::Site'

When the system prompts: "Running client or server?", enter 'client'.  The installation process is asking if you want to install CPAN::Site as a server or as a client.  Since CPAN::Site retrieves the Infoblox modules from a server, CPAN::Site acts as a client.

=back

=head4 2.   Run CPAN::Site, instead of CPAN.

=over

Use CPAN::Site instead of CPAN:

 lx> perl -MCPAN::Site -e shell
 CPAN: File::HomeDir loaded ok

 cpan shell -- CPAN exploration and modules installation (v1.87)
 ReadLine support enabled

You must use CPAN::Site every time to access the Infoblox modules.

=back

=head4 3.   Add the Infoblox device URL to the top of the CPAN URL list.

=over

B<3.0 You can manipulate the contents of the urllist with the usual perl functions push, pop, shift and unshift.  push and pop operate on the end of the list, while shift and unshift operate on the beginning of the list.  To empty the urllist, issue repeated shift or pop operands like this:>

=over

 cpan> o conf urllist
 urllist
 [ftp://mirrors.kernel.org/pub/CPAN]
 [http://mirrors.kernel.org/pub/CPAN]
 Type 'o conf' to view all configuration items

 cpan> o conf urllist shift

 cpan> o conf urllist shift

 cpan> o conf urllist
 urllist
Type 'o conf' to view all configuration items

You can put an item on the list at the beginning with unshift and at the end of the list with push:

 cpan> o conf urllist unshift ftp://mirrors.kernel.org/pub/CPAN

 cpan> o conf urllist push ftp://bogus.site.at.end.of.list/CPAN

 cpan> o conf urllist
 urllist
 [ftp://mirrors.kernel.org/pub/CPAN]
 [ftp://bogus.site.at.end.of.list/CPAN]
Type 'o conf' to view all configuration items

When you finish configuring the urllist, you must have the Infoblox appliance as the first item in the list.  This is a requirement of CPAN::Site.  The best configuration of urllist is a two-item list with the Infoblox appliance first and one other close, fast CPAN site second.  For example, at the Infoblox headquarters a good set of choices for urllist is:

 cpan> o conf urllist
 urllist
 [https://<ip_addr>/api/dist/CPAN]
 [ftp://mirrors.kernel.org/pub/CPAN]
Type 'o conf' to view all configuration items

The complete list of CPAN sites can be found at:

http://www.cpan.org/SITES.html

=back

B<3.1 Configure the Infoblox device first in the CPAN URL list, so that CPAN::Site finds it first when searching for packages. Type the IP address or domain name of your Infoblox device for <ip_addrE<gt> (for a grid, use the address of the grid master):>

=over

cpan> o conf urllist unshift https://<ip_addr>/api/dist/CPAN

(Note: You only need to add the repository to the URL list once.)

=back

B<3.2 You must have at least one other normal CPAN site in the list in case your client needs other public packages. The following is a sample URL list for a set of CPAN sites in North America:>

=over

 cpan> o conf urllist
 urllist
 [https://<ip_addr>/api/dist/CPAN]
 [ftp://mirrors.kernel.org/pub/CPAN]
 [ftp://cpan.pair.com/pub/CPAN/]
Type 'o conf' to view all configuration items

If you do not have any other CPAN sites in your URL list, add at least one before continuing. Use the command

o conf urllist push <url_string>

=back

B<3.3 To ensure that you have the correct URL for the Infoblox modules, open a Web browser and visit the URL you specified for the repository, in this example https://<ip_addrE<gt>/api/dist/CPAN. If the URL is correct, you can see a directory listing of the module files.>

=over

=back

B<3.4 Save your CPAN configuration:>

=over

 cpan> o conf commit
commit: wrote '/usr/lib/perl5/5.8.8/CPAN/Config.pm'

=back

=back

=head4 4. (Optional) Reduce the number of CPAN fetch methods.

=over

By reducing the number of CPAN fetch methods, you can shorten the installation process. For an explanation why Infoblox recommends this step, see the note in the introduction (before step 1).

 CPAN (and CPAN::Site) supports up to six different ways to search for and fetch files: curl, FTP, lynx, ncftpget, wget, and LWP. Infoblox recommends that you choose the method that work best for you and only configure those methods. For the typical cases, Infoblox recommends keeping LWP, FTP, and ncftpget enabled and disabling curl, lynx and wget. To disable a fetch method, set it to an empty string and then commit the configuration. In the example below, you first display the configuration parameters for curl, lynx, and wget, and then set them to an empty string:

 cpan> o conf curl
 curl	                            [/usr/bin/curl]

 cpan> o conf curl ""
 curl	                            []

 cpan> o conf lynx
 lynx	                         [/usr/bin/lynx]

 cpan> o conf lynx ""
 lynx	                         []

 cpan> o conf wget
 wget	                         [/usr/bin/wget]

 cpan> o conf wget ""
 wget	                         []

 cpan> o conf commit
 commit: wrote '/usr/lib/perl5/5.8.8/CPAN/Config.pm'

=back

=head4 5.   Reload the CPAN::Site index.

=over

Use CPAN to reload the CPAN::Site index:

 cpan> reload index
 CPAN: Storable loaded ok
 Going to read /root/.cpan/Metadata
 Database was generated on Sat, 09 Sep 2006 22:32:52 GMT
 CPAN: LWP::UserAgent loaded ok
 Fetching with LWP:
 https://<ip_addr>/api/dist/CPAN/authors/01mailrc.txt.gz
 ...
 Fetching with LWP:
 https://<ip_addr>/api/dist/CPAN/modules/03modlist.data.gz
 LWP failed with code[404] message[Not Found]
 Fetching with LWP:
 ftp://mirrors.kernel.org/pub/CPAN/modules/03modlist.data.gz
 Going to read /root/.cpan/sources/modules/03modlist.data.gz
 Going to write /root/.cpan/Metadata

Note: Unlike CPAN, CPAN::Site is designed so that some of the files that describe the available packages are not found in all of the locations in your URL list.  It is normal to see some "file not found" errors during the index reload.

=back

=head4 6.   Install the Infoblox package on your management system.

=over

The usual CPAN process for installing Perl modules is:

=over

B<6.1 Search>

B<6.2 Test>

B<6.3 Install>

B<6.4 Uninstall and Reinstall>

=back

B<6.1 Search>

=over

Use the m operator to search for the Infoblox module:

 cpan> m /Infoblox/
 CPAN: Storable loaded ok
 Going to read /root/.cpan/Metadata
 Database was generated on Mon, 18 Sep 2006 06:29:55 GMT
 CPAN: LWP::UserAgent loaded ok
 . . .
 Fetching with LWP:
 https://<ip_addr>/api/dist/CPAN/site/01mailrc.txt.gz
 Going to read /root/.cpan/sources/site/01mailrc.txt.gz
 Module id = Infoblox
 CPAN_USERID  INFOBLOX (Infoblox Technical Support <support@infoblox.com>)
 CPAN_VERSION 4.9999990014709
 CPAN_FILE    INFOBLOX/Infoblox-4.9999990014709.tar.gz
 INST_FILE    (not installed)

If the search cannot find the Infoblox modules:

a.  Ensure that you are using CPAN::Site, not CPAN as shown in 2.   Run CPAN::Site, instead of CPAN.
b.  Check the Infoblox appliance in the urllist as shown in step 3.3.

=back

B<6.2 Test>

=over

You can optionally test the package before the installation:

 cpan> test Infoblox
 Running test for module Infoblox
 Running make for Infoblox-4.999990014709.tar.gz
 ...
 All tests successful.
 Files=1, Tests=1,  0 wallclock secs ( 0.74 cusr +  0.08 csys =  0.82 CPU)
 /usr/bin/make test - OK

=back

B<6.3 Install>

=over

Install the Infoblox package:

 cpan> install Infoblox
 Running install for module Infoblox
 Running make for INFOBLOX/Infoblox-4.9999990014709.tar.gz
 ...
 Writing /usr/lib/perl5/site_perl/5.8.8/i386-linux-thread-multi/auto/Infoblox/.packlist
 Appending installation info to /usr/lib/perl5/5.8.8/i386-linux-thread-multi/perllocal.pod
 /usr/bin/make install  -- OK

To exit the CPAN::Site shell:

 cpan> quit

The installation is complete.

=back

B<6.4 Uninstalling and Reinstalling the Infoblox Package>

=over

Although not directly supported by CPAN, it is simple to uninstall the Infoblox package using published techniques. One way to do it is provided by the modrm program that is described in the ExtUtils::Packlist documentation. See http://search.cpan.org/~yves/ExtUtils-Install-1.41/lib/ExtUtils/Packlist.pm#EXAMPLE for the modrm program. To reinstall it, repeat steps 5 and 6 above.

=back

=back

=cut
L<IInfoblox::Grid::Member::DNS::ViewAddressSetting|IInfoblox::Grid::Member::DNS::ViewAddressSetting> - The Grid member DNS view address settings.

L<Infoblox::CiscoISE::EAAssociation|Infoblox::CiscoISE::EAAssociation> - A Cisco ISE extensible attributes association.

L<Infoblox::CiscoISE::Endpoint|Infoblox::CiscoISE::Endpoint> - A Cisco ISE endpoint object.

L<Infoblox::CiscoISE::PublishSetting|Infoblox::CiscoISE::PublishSetting> - A Cisco ISE publish settings.

L<Infoblox::CiscoISE::PublishSetting|Infoblox::CiscoISE::PublishSetting> - A Cisco ISE subscribe settings.

L<Infoblox::Cursor|Infoblox::Cursor> - Manages paged searches.

L<Infoblox::DHCP::DDNS|Infoblox::DHCP::DDNS> - DHCP DDNS object.

L<Infoblox::DHCP::ExclusionRange|Infoblox::DHCP::ExclusionRange> - DHCP ExclusionRange object.

L<Infoblox::DHCP::ExclusionRangeTemplate|Infoblox::DHCP::ExclusionRangeTemplate> - DHCP ExclusionRangeTemplate object.

L<Infoblox::DHCP::ExpandNetwork|Infoblox::DHCP::ExpandNetwork> - Join or Expand an existing network

L<Infoblox::DHCP::FailOver|Infoblox::DHCP::FailOver> - DHCP Failover object.

L<Infoblox::DHCP::Filter::Fingerprint|Infoblox::DHCP::Filter::Fingerprint> - DHCP Fingerprint Filter object.

L<Infoblox::DHCP::Filter::MAC|Infoblox::DHCP::Filter::MAC> - DHCP MAC Address Filter object.

L<Infoblox::DHCP::Filter::NAC|Infoblox::DHCP::Filter::NAC> - DHCP NAC Filter object.

L<Infoblox::DHCP::Filter::Option|Infoblox::DHCP::Filter::Option> - DHCP filter option object

L<Infoblox::DHCP::Filter::RelayAgent|Infoblox::DHCP::Filter::RelayAgent> - DHCP relay agent filter object

L<Infoblox::DHCP::FilterRule::Fingerprint|Infoblox::DHCP::FilterRule::Fingerprint> - DHCP Fingerprint Filter Rule object.

L<Infoblox::DHCP::FilterRule::MAC|Infoblox::DHCP::FilterRule::MAC> - DHCP MAC Address Filter Rule object.

L<Infoblox::DHCP::FilterRule::NAC|Infoblox::DHCP::FilterRule::NAC> - DHCP NAC Filter Rule object.

L<Infoblox::DHCP::FilterRule::Option|Infoblox::DHCP::FilterRule::Option> - DHCP filter rule option object.

L<Infoblox::DHCP::FilterRule::RelayAgent|Infoblox::DHCP::FilterRule::RelayAgent> - DHCP RelayAgent Filter Rule object.

L<Infoblox::DHCP::Fingerprint|Infoblox::DHCP::Fingerprint> - DHCP Fingerprint object.

L<Infoblox::DHCP::FixedAddr|Infoblox::DHCP::FixedAddr> - DHCP Fixed Address object.

L<Infoblox::DHCP::FixedAddrTemplate|Infoblox::DHCP::FixedAddrTemplate> - DHCP Fixed Address template object.

L<Infoblox::DHCP::HostAddr|Infoblox::DHCP::HostAddr> - DHCP Host Address object.

L<Infoblox::DHCP::IPv6FixedAddr|Infoblox::DHCP::IPv6FixedAddr> - DHCP IPv6 Fixed Address object.

L<Infoblox::DHCP::IPv6FixedAddrTemplate|Infoblox::DHCP::IPv6FixedAddrTemplate> - DHCP IPv6 Fixed Address Template object

L<Infoblox::DHCP::IPv6HostAddr|Infoblox::DHCP::IPv6HostAddr> - DHCP IPv6 Host Address object.

L<Infoblox::DHCP::IPv6Network|Infoblox::DHCP::IPv6Network> - DHCP IPv6 Network object

L<Infoblox::DHCP::IPv6NetworkContainer|Infoblox::DHCP::IPv6NetworkContainer> - DHCP IPv6 Network Container object

L<Infoblox::DHCP::IPv6NetworkTemplate|Infoblox::DHCP::IPv6NetworkTemplate> - DHCP IPv6 Network Template object

L<Infoblox::DHCP::IPv6OptionDefinition|Infoblox::DHCP::IPv6OptionDefinition> - DHCP IPv6 option definition object

L<Infoblox::DHCP::IPv6OptionSpace|Infoblox::DHCP::IPv6OptionSpace> - DHCP IPv6 OptionSpace object.

L<Infoblox::DHCP::IPv6Range|Infoblox::DHCP::IPv6Range> - DHCP IPv6 Range object.

L<Infoblox::DHCP::IPv6RangeTemplate|Infoblox::DHCP::IPv6RangeTemplate> - DHCP IPv6 RangeTemplate object.

L<Infoblox::DHCP::IPv6SharedNetwork|Infoblox::DHCP::IPv6SharedNetwork> - DHCP IPv6 Shared Network object

L<Infoblox::DHCP::Lease|Infoblox::DHCP::Lease> - DHCP Lease object.

L<Infoblox::DHCP::MAC|Infoblox::DHCP::MAC> - DHCP MAC object.

L<Infoblox::DHCP::MSOption|Infoblox::DHCP::MSOption> - Microsoft (r) Server DHCP Option object.

L<Infoblox::DHCP::MSServer|Infoblox::DHCP::MSServer> - Microsoft (r) DHCP Server object.

L<Infoblox::DHCP::MSSuperscope|Infoblox::DHCP::MSSuperscope> - Microsoft (r) Server Superscope object.

L<Infoblox::DHCP::Member|Infoblox::DHCP::Member> - DHCP Member object.

L<Infoblox::DHCP::Network|Infoblox::DHCP::Network> - DHCP Network object

L<Infoblox::DHCP::NetworkContainer|Infoblox::DHCP::NetworkContainer> - DHCP Network Container object

L<Infoblox::DHCP::NetworkTemplate|Infoblox::DHCP::NetworkTemplate> - DHCP Network Template object

L<Infoblox::DHCP::NetworkUser|Infoblox::DHCP::NetworkUser> - a DHCP Network User object.

L<Infoblox::DHCP::Option|Infoblox::DHCP::Option> - DHCP Option object.

L<Infoblox::DHCP::Option60MatchRule|Infoblox::DHCP::Option60MatchRule> - DHCP  Option60MatchRule object.

L<Infoblox::DHCP::OptionDefinition|Infoblox::DHCP::OptionDefinition> - DHCP  option definition object

L<Infoblox::DHCP::OptionSpace|Infoblox::DHCP::OptionSpace> - DHCP OptionSpace object.

L<Infoblox::DHCP::OrderedRanges|Infoblox::DHCP::OrderedRanges> - Ordered Ranges object.

L<Infoblox::DHCP::Range|Infoblox::DHCP::Range> - DHCP Range object.

L<Infoblox::DHCP::RangeTemplate|Infoblox::DHCP::RangeTemplate> - DHCP RangeTemplate object.

L<Infoblox::DHCP::RoamingHost|Infoblox::DHCP::RoamingHost> - DHCP Roaming Host object.

L<Infoblox::DHCP::SharedNetwork|Infoblox::DHCP::SharedNetwork> - DHCP Shared Network object

L<Infoblox::DHCP::SplitNetwork|Infoblox::DHCP::SplitNetwork> - Split network object.

L<Infoblox::DHCP::Statistics|Infoblox::DHCP::Statistics> - Manages DHCP statistics.

L<Infoblox::DHCP::Template|Infoblox::DHCP::Template> - DHCP Template object.

L<Infoblox::DHCP::View|Infoblox::DHCP::View> - DHCP Network View object

L<Infoblox::DNS::AllRPZRecords|Infoblox::DNS::AllRPZRecords> - A synthetic object used to return record object types that belong to a Response Policy Zone.

L<Infoblox::DNS::AllRecords|Infoblox::DNS::AllRecords> - A synthetic object used to return all record object types belonging to a zone.

L<Infoblox::DNS::BulkHost|Infoblox::DNS::BulkHost> - Create a group of hosts.

L<Infoblox::DNS::DDNS::PrincipalCluster|Infoblox::DNS::DDNS::PrincipalCluster> - A DDNS Principal Cluster object.

L<Infoblox::DNS::DDNS::PrincipalCluster::Group|Infoblox::DNS::DDNS::PrincipalCluster::Group> - A DDNS Principal Cluster Group object.

L<Infoblox::DNS::DNSSecKey|Infoblox::DNS::DNSSecKey> - DNSSEC key object.

L<Infoblox::DNS::DNSSecKeyAlgorithm|Infoblox::DNS::DNSSecKeyAlgorithm> - DNSSEC key algorithm object.

L<Infoblox::DNS::DnssecTrustedKey|Infoblox::DNS::DnssecTrustedKey> - DNSSEC trusted key object.

L<Infoblox::DNS::FireEyeAlertMap|Infoblox::DNS::FireEyeAlertMap> - FireEye Alert Map object

L<Infoblox::DNS::FireEyeRuleMapping|Infoblox::DNS::FireEyeRuleMapping> - FireEye Rule Mapping object

L<Infoblox::DNS::GlueRecordAddr|Infoblox::DNS::GlueRecordAddr> - Infoblox DNS Glue Record Object.

L<Infoblox::DNS::Host|Infoblox::DNS::Host> - DNS Host record object.

L<Infoblox::DNS::MSServer|Infoblox::DNS::MSServer> - Microsoft (r) DNS Server object

L<Infoblox::DNS::Member|Infoblox::DNS::Member> - DNS Member object

L<Infoblox::DNS::Member::SoaMname|Infoblox::DNS::Member::SoaMname> - a per-master SOA MNAME information.

L<Infoblox::DNS::Member::SoaSerial|Infoblox::DNS::Member::SoaSerial> - a per-master SOA serial information.

L<Infoblox::DNS::NSEC3PARAM |Infoblox::DNS::NSEC3PARAM > - NSEC3PARAM Record object

L<Infoblox::DNS::Nameserver|Infoblox::DNS::Nameserver> - DNS Nameserver object

L<Infoblox::DNS::Nameserver::Address|Infoblox::DNS::Nameserver::Address> - NS Name Server object.

L<Infoblox::DNS::OrderedResponsePolicyZones|Infoblox::DNS::OrderedResponsePolicyZones> - Ordered Response Policy Zones object.

L<Infoblox::DNS::RPZRecord::A|Infoblox::DNS::RPZRecord::A> - Response Policy Zone (RPZ) Substitute (A Record) Rule object.

L<Infoblox::DNS::RPZRecord::AAAA|Infoblox::DNS::RPZRecord::AAAA> - Response Policy Zone (RPZ) Substitute (AAAA Record) Rule object.

L<Infoblox::DNS::RPZRecord::AAAAIpAddress|Infoblox::DNS::RPZRecord::AAAAIpAddress> - Response Policy Zone (RPZ) Substitute (IPv6 Address) Rule object.

L<Infoblox::DNS::RPZRecord::AIpAddress|Infoblox::DNS::RPZRecord::AIpAddress> - Response Policy Zone (RPZ) Substitute (IPv4 Address) Rule object.

L<Infoblox::DNS::RPZRecord::CNAME|Infoblox::DNS::RPZRecord::CNAME> - DNS Response Policy Zone (RPZ) CNAME record object.

L<Infoblox::DNS::RPZRecord::CNAME::ClientIpAddress|Infoblox::DNS::RPZRecord::CNAME::ClientIpAddress> - DNS Response Policy Zone (RPZ) CNAMEClientIpAddress record object.

L<Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN|Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN> - DNS Substitute Domain Name (Based on Client IP Address) rule object.

L<Infoblox::DNS::RPZRecord::CNAME::IpAddress|Infoblox::DNS::RPZRecord::CNAME::IpAddress> - DNS Response Policy Zone (RPZ) CNAMEIpAddress record object.

L<Infoblox::DNS::RPZRecord::CNAME::IpAddressDN|Infoblox::DNS::RPZRecord::CNAME::IpAddressDN> - DNS Substitute Domain Name (Based on IP Address) rule object.

L<Infoblox::DNS::RPZRecord::MX|Infoblox::DNS::RPZRecord::MX> - Response Policy Zone (RPZ) Substitute (MX Record) Rule object

L<Infoblox::DNS::RPZRecord::NAPTR |Infoblox::DNS::RPZRecord::NAPTR > - Response Policy Zone (RPZ) Substitute (NAPTR Record) Rule object.

L<Infoblox::DNS::RPZRecord::PTR|Infoblox::DNS::RPZRecord::PTR> - Response Policy Zone (RPZ) Substitute (PTR Record) Rule object.

L<Infoblox::DNS::RPZRecord::SRV|Infoblox::DNS::RPZRecord::SRV> - Response Policy Zone (RPZ) Substitute (SRV Record) Rule object

L<Infoblox::DNS::RPZRecord::TXT|Infoblox::DNS::RPZRecord::TXT> - Response Policy Zone (RPZ) Substitute (TXT Record) Rule object.

L<Infoblox::DNS::Record::A|Infoblox::DNS::Record::A> - DNS A record object.

L<Infoblox::DNS::Record::AAAA|Infoblox::DNS::Record::AAAA> - DNS AAAA record object.

L<Infoblox::DNS::Record::CNAME|Infoblox::DNS::Record::CNAME> - DNS CNAME record object.

L<Infoblox::DNS::Record::DHCID|Infoblox::DNS::Record::DHCID> - DNS DHCID record object.

L<Infoblox::DNS::Record::DNAME|Infoblox::DNS::Record::DNAME> - DNAME record object.

L<Infoblox::DNS::Record::DNSKEY |Infoblox::DNS::Record::DNSKEY > - DNSKEY Record object.

L<Infoblox::DNS::Record::DS |Infoblox::DNS::Record::DS > - DS Record object.

L<Infoblox::DNS::Record::DTCLBDN|Infoblox::DNS::Record::DTCLBDN> - A DTC Load Balanced Domain Name Record object.

L<Infoblox::DNS::Record::MX|Infoblox::DNS::Record::MX> - DNS MX record object

L<Infoblox::DNS::Record::NAPTR |Infoblox::DNS::Record::NAPTR > - NAPTR record object.

L<Infoblox::DNS::Record::NS|Infoblox::DNS::Record::NS> - DNS NS record object

L<Infoblox::DNS::Record::NSEC |Infoblox::DNS::Record::NSEC > - NSEC Record object

L<Infoblox::DNS::Record::NSEC3 |Infoblox::DNS::Record::NSEC3 > - NSEC3 Record object.

L<Infoblox::DNS::Record::PTR|Infoblox::DNS::Record::PTR> - DNS PTR record object.

L<Infoblox::DNS::Record::RRSIG |Infoblox::DNS::Record::RRSIG > - RRSIG Record object

L<Infoblox::DNS::Record::SRV|Infoblox::DNS::Record::SRV> - DNS SRV record object

L<Infoblox::DNS::Record::TLSA|Infoblox::DNS::Record::TLSA> - DNS TLSA record object.

L<Infoblox::DNS::Record::TXT|Infoblox::DNS::Record::TXT> - DNS TXT record object.

L<Infoblox::DNS::RootNameServer|Infoblox::DNS::RootNameServer> - Custom root name server object.

L<Infoblox::DNS::Ruleset|Infoblox::DNS::Ruleset> - Ruleset object

L<Infoblox::DNS::Ruleset::NxdomainRule|Infoblox::DNS::Ruleset::NxdomainRule> - Rule of Ruleset object

L<Infoblox::DNS::SRG|Infoblox::DNS::SRG> - Create a shared record group.

L<Infoblox::DNS::SharedRecord::A|Infoblox::DNS::SharedRecord::A> - DNS shared A record object.

L<Infoblox::DNS::SharedRecord::AAAA|Infoblox::DNS::SharedRecord::AAAA> - DNS AAAA shared record object.

L<Infoblox::DNS::SharedRecord::CNAME|Infoblox::DNS::SharedRecord::CNAME> - DNS shared CNAME record object.

L<Infoblox::DNS::SharedRecord::MX|Infoblox::DNS::SharedRecord::MX> - DNS shared MX record object

L<Infoblox::DNS::SharedRecord::SRV|Infoblox::DNS::SharedRecord::SRV> - DNS shared SRV record object

L<Infoblox::DNS::SharedRecord::TXT|Infoblox::DNS::SharedRecord::TXT> - DNS shared TXT record object.

L<Infoblox::DNS::Sortlist|Infoblox::DNS::Sortlist> - DNS Sortlist Object.

L<Infoblox::DNS::TSIGKey|Infoblox::DNS::TSIGKey> - DNS TSIGKey object

L<Infoblox::DNS::View|Infoblox::DNS::View> - DNS View object

L<Infoblox::DNS::Zone|Infoblox::DNS::Zone> - DNS Zone object

L<Infoblox::DNS::Zone::Discrepancy|Infoblox::DNS::Zone::Discrepancy> - DNS Zone discrepancy object.

L<Infoblox::DTC|Infoblox::DTC> - A DTC functions.

L<Infoblox::DTC::AllRecords|Infoblox::DTC::AllRecords> - A synthetic object used to return all DTC record object types belonging to a DTC server.

L<Infoblox::DTC::Certificate|Infoblox::DTC::Certificate> - a DTC Certificate object.

L<Infoblox::DTC::Health|Infoblox::DTC::Health> - A DTC health information object.

L<Infoblox::DTC::LBDN|Infoblox::DTC::LBDN> - A DTC Load Balanced Domain Name object.

L<Infoblox::DTC::Monitor|Infoblox::DTC::Monitor> - A DTC Health Monitor object.

L<Infoblox::DTC::Monitor::HTTP|Infoblox::DTC::Monitor::HTTP> - An DTC HTTP Health Monitor object.

L<Infoblox::DTC::Monitor::ICMP|Infoblox::DTC::Monitor::ICMP> - A DTC ICMP Health Monitor object.

L<Infoblox::DTC::Monitor::PDP|Infoblox::DTC::Monitor::PDP> - A DTC PDP Health Monitor object.

L<Infoblox::DTC::Monitor::SIP|Infoblox::DTC::Monitor::SIP> - A DTC SIP Health Monitor object.

L<Infoblox::DTC::Monitor::SNMP|Infoblox::DTC::Monitor::SNMP> - A DTC SNMP Health Monitor object.

L<Infoblox::DTC::Monitor::SNMP::OID|Infoblox::DTC::Monitor::SNMP::OID> - a DTC SNMP Monitor OID object.

L<Infoblox::DTC::Monitor::TCP|Infoblox::DTC::Monitor::TCP> - A DTC TCP Health Monitor object.

L<Infoblox::DTC::Object|Infoblox::DTC::Object> - An object for all managed objects on DNS traffic control devices.

L<Infoblox::DTC::Pool|Infoblox::DTC::Pool> - a DTC Pool object.

L<Infoblox::DTC::Pool::DynamicRatioSetting|Infoblox::DTC::Pool::DynamicRatioSetting> - An DTC Pool dynamic ratio setting object.

L<Infoblox::DTC::Pool::Link|Infoblox::DTC::Pool::Link> - An DTC Pool Link object.

L<Infoblox::DTC::Query::Parameters|Infoblox::DTC::Query::Parameters> - A DTC query call parameters object.

L<Infoblox::DTC::Query::Response|Infoblox::DTC::Query::Response> - A DTC query call response object.

L<Infoblox::DTC::Query::Result|Infoblox::DTC::Query::Result> - A DTC Query result object.

L<Infoblox::DTC::Record::A|Infoblox::DTC::Record::A> - A DTC A record object.

L<Infoblox::DTC::Record::AAAA|Infoblox::DTC::Record::AAAA> - A DTC AAAA record object.

L<Infoblox::DTC::Record::CNAME|Infoblox::DTC::Record::CNAME> - A DTC CNAME record object.

L<Infoblox::DTC::Record::NAPTR |Infoblox::DTC::Record::NAPTR > - A DTC NAPTR record object.

L<Infoblox::DTC::Server|Infoblox::DTC::Server> - A DTC Server object.

L<Infoblox::DTC::Server::Link|Infoblox::DTC::Server::Link> - An DTC Server Link object.

L<Infoblox::DTC::Server::Monitor|Infoblox::DTC::Server::Monitor> - A DTC Server Monitor object.

L<Infoblox::DTC::Topology|Infoblox::DTC::Topology> - A DTC Topology object.

L<Infoblox::DTC::Topology::Label|Infoblox::DTC::Topology::Label> - A DTC Topology label object.

L<Infoblox::DTC::Topology::Rule|Infoblox::DTC::Topology::Rule> - A DTC Topology Rule object.

L<Infoblox::DTC::Topology::Rule::Source|Infoblox::DTC::Topology::Rule::Source> - A DTC Topology Rule Source object.

L<Infoblox::DXL::Endpoint|Infoblox::DXL::Endpoint> - A Data Exchange Layer (DXL) endpoint object.

L<Infoblox::DXL::Endpoint::Broker|Infoblox::DXL::Endpoint::Broker> - A Data Exchange Layer (DXL) endpoint broker object.

L<Infoblox::Discovery::NetworkDeprovisionInfo|Infoblox::Discovery::NetworkDeprovisionInfo> - Network deprovision information.

L<Infoblox::Grid|Infoblox::Grid> - Manages the Grid settings.

L<Infoblox::Grid::Admin::AdAuthServer|Infoblox::Grid::Admin::AdAuthServer> - Active Directory Authentication Server object

L<Infoblox::Grid::Admin::AdAuthService|Infoblox::Grid::Admin::AdAuthService> - Active Directory Authentication Service object

L<Infoblox::Grid::Admin::AuthPolicy|Infoblox::Grid::Admin::AuthPolicy> - Authentication Policy object

L<Infoblox::Grid::Admin::CertificateAuthService|Infoblox::Grid::Admin::CertificateAuthService> - a Certificate Authentication Service.

L<Infoblox::Grid::Admin::Group|Infoblox::Grid::Admin::Group> - Admin Group object.

L<Infoblox::Grid::Admin::LocalUserAuthService|Infoblox::Grid::Admin::LocalUserAuthService> - Local User Authentication Service object

L<Infoblox::Grid::Admin::Permission|Infoblox::Grid::Admin::Permission> - Admin Permission object.

L<Infoblox::Grid::Admin::RadiusAuthServer|Infoblox::Grid::Admin::RadiusAuthServer> - RADIUS Authentication Server object

L<Infoblox::Grid::Admin::RadiusAuthService|Infoblox::Grid::Admin::RadiusAuthService> - RADIUS Authentication Service object

L<Infoblox::Grid::Admin::Role|Infoblox::Grid::Admin::Role> - Admin Role object.

L<Infoblox::Grid::Admin::TACACSPlusAuthServer|Infoblox::Grid::Admin::TACACSPlusAuthServer> - TACACS+ Authentication Server object

L<Infoblox::Grid::Admin::TACACSPlusAuthService|Infoblox::Grid::Admin::TACACSPlusAuthService> - TACACS+ Authentication Service object

L<Infoblox::Grid::Admin::User|Infoblox::Grid::Admin::User> - User Admin object.

L<Infoblox::Grid::Admin::User::Profile|Infoblox::Grid::Admin::User::Profile> - User Profile object.

L<Infoblox::Grid::AllEndpoints|Infoblox::Grid::AllEndpoints> - A class that represents all Grid endpoints.

L<Infoblox::Grid::ApprovalWorkflow|Infoblox::Grid::ApprovalWorkflow> - An approval object.

L<Infoblox::Grid::BFD::Template|Infoblox::Grid::BFD::Template> - a Bidirectional Forwarding Detection (BFD) template object.

L<Infoblox::Grid::CACertificate|Infoblox::Grid::CACertificate> - CA certificate description.

L<Infoblox::Grid::CSVImportStatus|Infoblox::Grid::CSVImportStatus> - CSV import status object

L<Infoblox::Grid::CloudAPI |Infoblox::Grid::CloudAPI > - Infoblox::Grid::CloudAPI object.

L<Infoblox::Grid::CloudAPI::CloudStatistics|Infoblox::Grid::CloudAPI::CloudStatistics> - Infoblox::Grid::CloudAPI::CloudStatistics object.

L<Infoblox::Grid::CloudAPI::Info |Infoblox::Grid::CloudAPI::Info > - Infoblox::Grid::CloudAPI::Info object.

L<Infoblox::Grid::CloudAPI::Member |Infoblox::Grid::CloudAPI::Member > - Infoblox::Grid::CloudAPI::Member  object.

L<Infoblox::Grid::CloudAPI::Tenant|Infoblox::Grid::CloudAPI::Tenant> - Infoblox::Grid::CloudAPI::Tenant object.

L<Infoblox::Grid::CloudAPI::User|Infoblox::Grid::CloudAPI::User> - Infoblox::Grid::CloudAPI::User object.

L<Infoblox::Grid::CloudAPI::VMAddress|Infoblox::Grid::CloudAPI::VMAddress> - Infoblox::Grid::CloudAPI::VMAddress object.

L<Infoblox::Grid::ConsentBannerSetting|Infoblox::Grid::ConsentBannerSetting> - The consent banner setting.

L<Infoblox::Grid::DBSnapshot|Infoblox::Grid::DBSnapshot> - OneDB snapshot information object.

L<Infoblox::Grid::DHCP|Infoblox::Grid::DHCP> - Grid DHCP services object.

L<Infoblox::Grid::DNS|Infoblox::Grid::DNS> - DNS objects management and configuration

L<Infoblox::Grid::DNS::AllNsgroups|Infoblox::Grid::DNS::AllNsgroups> - All NS Groups object.

L<Infoblox::Grid::DNS::AttackDetect|Infoblox::Grid::DNS::AttackDetect> - a DNS Attack Detect object.

L<Infoblox::Grid::DNS::AttackMitigation|Infoblox::Grid::DNS::AttackMitigation> - a DNS Attack Mitigation object.

L<Infoblox::Grid::DNS::AutoBlackHole|Infoblox::Grid::DNS::AutoBlackHole> - a DNS Auto Blackhole object.

L<Infoblox::Grid::DNS::BulkHostNameTemplate|Infoblox::Grid::DNS::BulkHostNameTemplate> - Manages the DNS bulk host name formats defined at the grid level.

L<Infoblox::Grid::DNS::ClientSubnetDomain|Infoblox::Grid::DNS::ClientSubnetDomain> - a DNS client subnet domain object.

L<Infoblox::Grid::DNS::DNS64Group|Infoblox::Grid::DNS::DNS64Group> - DNS64 Synthesis Group object

L<Infoblox::Grid::DNS::FileTransferSetting|Infoblox::Grid::DNS::FileTransferSetting> - A DNS traffic capture file transfer setting object.

L<Infoblox::Grid::DNS::FixedRRSetOrderFQDN|Infoblox::Grid::DNS::FixedRRSetOrderFQDN> - A fixed RRset order FQDN object.

L<Infoblox::Grid::DNS::Nsgroup|Infoblox::Grid::DNS::Nsgroup> - Creates a name server group.

L<Infoblox::Grid::DNS::Nsgroup::DelegationMember|Infoblox::Grid::DNS::Nsgroup::DelegationMember> - A delegation nameservers group.

L<Infoblox::Grid::DNS::Nsgroup::ForwardStubServer|Infoblox::Grid::DNS::Nsgroup::ForwardStubServer> - A forward/stub external nameserver group.

L<Infoblox::Grid::DNS::Nsgroup::ForwardingMember|Infoblox::Grid::DNS::Nsgroup::ForwardingMember> - A forwarding member group.

L<Infoblox::Grid::DNS::Nsgroup::StubMember|Infoblox::Grid::DNS::Nsgroup::StubMember> - A stub member group.

L<Infoblox::Grid::DNS::ResponseRateLimiting|Infoblox::Grid::DNS::ResponseRateLimiting> - a DNS Response Rate Limiting object.

L<Infoblox::Grid::DNS::ScavengingSetting|Infoblox::Grid::DNS::ScavengingSetting> - A DNS scavenging settings object.

L<Infoblox::Grid::DNS::ScavengingTask|Infoblox::Grid::DNS::ScavengingTask> - A DNS scavenging task object.

L<Infoblox::Grid::Dashboard|Infoblox::Grid::Dashboard> - A Grid Dashboard object.

L<Infoblox::Grid::DataCollection::BlacklistedCluster|Infoblox::Grid::DataCollection::BlacklistedCluster> - A Data Collection blacklisted cluster object.

L<Infoblox::Grid::DataCollection::Cluster|Infoblox::Grid::DataCollection::Cluster> - A data collection cluster object.

L<Infoblox::Grid::DataCollection::IPInfo|Infoblox::Grid::DataCollection::IPInfo> - A data collection IP information object.

L<Infoblox::Grid::DateTime|Infoblox::Grid::DateTime> - Grid date and time object.

L<Infoblox::Grid::Discovery|Infoblox::Grid::Discovery> - Grid discovery functions.

L<Infoblox::Grid::Discovery::AdvancedPollSettings|Infoblox::Grid::Discovery::AdvancedPollSettings> - advanced polling settings.

L<Infoblox::Grid::Discovery::AutoConversionSetting|Infoblox::Grid::Discovery::AutoConversionSetting> - Auto conversion setting.

L<Infoblox::Grid::Discovery::BasicPollSettings|Infoblox::Grid::Discovery::BasicPollSettings> - basic polling settings.

L<Infoblox::Grid::Discovery::CLICredential|Infoblox::Grid::Discovery::CLICredential> - 

L<Infoblox::Grid::Discovery::ConversionAttributes|Infoblox::Grid::Discovery::ConversionAttributes> - conversion attributes.

L<Infoblox::Grid::Discovery::DSBundle|Infoblox::Grid::Discovery::DSBundle> - the device support bundle.

L<Infoblox::Grid::Discovery::Data|Infoblox::Grid::Discovery::Data> - the discovered data.

L<Infoblox::Grid::Discovery::Device|Infoblox::Grid::Discovery::Device> - the discovery device.

L<Infoblox::Grid::Discovery::Device::PortStatistics|Infoblox::Grid::Discovery::Device::PortStatistics> - the device port statistics object.

L<Infoblox::Grid::Discovery::DeviceComponent|Infoblox::Grid::Discovery::DeviceComponent> - 

L<Infoblox::Grid::Discovery::DeviceDataCollectionStatus|Infoblox::Grid::Discovery::DeviceDataCollectionStatus> - the device data collection status.

L<Infoblox::Grid::Discovery::DeviceInterface|Infoblox::Grid::Discovery::DeviceInterface> - the discovery interface.

L<Infoblox::Grid::Discovery::DeviceNeighbor|Infoblox::Grid::Discovery::DeviceNeighbor> - the neighbor associated with the device.

L<Infoblox::Grid::Discovery::DeviceSupportInfo|Infoblox::Grid::Discovery::DeviceSupportInfo> - the device support info.

L<Infoblox::Grid::Discovery::DeviceSupportInfoResponse|Infoblox::Grid::Discovery::DeviceSupportInfoResponse> - the device support info response.

L<Infoblox::Grid::Discovery::DiagnosticTask|Infoblox::Grid::Discovery::DiagnosticTask> - The discovery diagnostic task.

L<Infoblox::Grid::Discovery::DiagnosticsStatus|Infoblox::Grid::Discovery::DiagnosticsStatus> - The discovery diagnostic status.

L<Infoblox::Grid::Discovery::DiscoveryDataConversionResult|Infoblox::Grid::Discovery::DiscoveryDataConversionResult> - discovery data conversion result.

L<Infoblox::Grid::Discovery::IFAddrInfo|Infoblox::Grid::Discovery::IFAddrInfo> - IFAddr information associated with the discovery interface.

L<Infoblox::Grid::Discovery::JobProcessDetails|Infoblox::Grid::Discovery::JobProcessDetails> - job process details object.

L<Infoblox::Grid::Discovery::Port|Infoblox::Grid::Discovery::Port> - the discovery port structure.

L<Infoblox::Grid::Discovery::Port::Config::AdminStatus|Infoblox::Grid::Discovery::Port::Config::AdminStatus> - admin status of port configuration.

L<Infoblox::Grid::Discovery::Port::Config::Description|Infoblox::Grid::Discovery::Port::Config::Description> - port configuration description.

L<Infoblox::Grid::Discovery::Port::Config::VlanInfo|Infoblox::Grid::Discovery::Port::Config::VlanInfo> - VLAN information of port configuration.

L<Infoblox::Grid::Discovery::Port::Control::Info|Infoblox::Grid::Discovery::Port::Control::Info> - port control information.

L<Infoblox::Grid::Discovery::Port::Control::TaskDetails|Infoblox::Grid::Discovery::Port::Control::TaskDetails> - port control task details.

L<Infoblox::Grid::Discovery::Properties|Infoblox::Grid::Discovery::Properties> - Grid discovery properties.

L<Infoblox::Grid::Discovery::Properties::BlackoutSetting|Infoblox::Grid::Discovery::Properties::BlackoutSetting> - 

L<Infoblox::Grid::Discovery::SNMP3Credential|Infoblox::Grid::Discovery::SNMP3Credential> - SNMPv3 credential.

L<Infoblox::Grid::Discovery::SNMPCredential|Infoblox::Grid::Discovery::SNMPCredential> - SNMPv1 and SNMPv2 credential.

L<Infoblox::Grid::Discovery::SeedRouter|Infoblox::Grid::Discovery::SeedRouter> - The seed router structure.

L<Infoblox::Grid::Discovery::Status|Infoblox::Grid::Discovery::Status> - the discovery status of discovered data.

L<Infoblox::Grid::Discovery::StatusInfo|Infoblox::Grid::Discovery::StatusInfo> - the discovery status information.

L<Infoblox::Grid::Discovery::TestCredential|Infoblox::Grid::Discovery::TestCredential> - 

L<Infoblox::Grid::Discovery::VLANInfo|Infoblox::Grid::Discovery::VLANInfo> - VLAN information associated with the discovery interface.

L<Infoblox::Grid::Discovery::VRFMappingRule|Infoblox::Grid::Discovery::VRFMappingRule> - VRF mapping rule.

L<Infoblox::Grid::DistributionSchedule|Infoblox::Grid::DistributionSchedule> - Information about the Grid's distribution schedule.

L<Infoblox::Grid::EAExpressionOp|Infoblox::Grid::EAExpressionOp> - A extensible attribute expression operand object.

L<Infoblox::Grid::ExpressionOp|Infoblox::Grid::ExpressionOp> - An expression operand object.

L<Infoblox::Grid::Extattr|Infoblox::Grid::Extattr> - an extensible attribute representation for an attribute.

L<Infoblox::Grid::ExtensibleAttributeDef|Infoblox::Grid::ExtensibleAttributeDef> - Extensible Attribute Definition object.

L<Infoblox::Grid::ExtensibleAttributeDef::Descendants|Infoblox::Grid::ExtensibleAttributeDef::Descendants> - an action for the extensible attributes that exist on descendants.

L<Infoblox::Grid::ExtensibleAttributeDef::ListValue|Infoblox::Grid::ExtensibleAttributeDef::ListValue> - Extensible Attribute Definition List Value object.

L<Infoblox::Grid::FileDistribution|Infoblox::Grid::FileDistribution> - Grid FileDistribution object.

L<Infoblox::Grid::FileDistributionDir|Infoblox::Grid::FileDistributionDir> - Grid FileDistributionDir object.

L<Infoblox::Grid::GlobalSmartFolder|Infoblox::Grid::GlobalSmartFolder> - Global Smart Folder object.

L<Infoblox::Grid::HSM::AllGroup|Infoblox::Grid::HSM::AllGroup> - All HSM groups.

L<Infoblox::Grid::HSM::SafeNet|Infoblox::Grid::HSM::SafeNet> - SafeNet HSM (Hardware Security Module) Server object

L<Infoblox::Grid::HSM::SafeNet::Group|Infoblox::Grid::HSM::SafeNet::Group> - SafeNet HSM (Hardware Security Module) Group object

L<Infoblox::Grid::HSM::Thales|Infoblox::Grid::HSM::Thales> - Thales HSM (Hardware Security Module) Server object

L<Infoblox::Grid::HSM::Thales::Group|Infoblox::Grid::HSM::Thales::Group> - Thales HSM Group object

L<Infoblox::Grid::HTTPProxyServerSetting|Infoblox::Grid::HTTPProxyServerSetting> - An Infoblox Grid HTTP Proxy Server Setting object.

L<Infoblox::Grid::HostNameRewritePolicy|Infoblox::Grid::HostNameRewritePolicy> - a structure for storing hostname rewrite policies.

L<Infoblox::Grid::IPValidationInfo|Infoblox::Grid::IPValidationInfo> - IP Validation information

L<Infoblox::Grid::InformationalBannerSetting|Infoblox::Grid::InformationalBannerSetting> - The informational banner setting.

L<Infoblox::Grid::KerberosKey|Infoblox::Grid::KerberosKey> - Grid kerberos key object.

L<Infoblox::Grid::LOM::User|Infoblox::Grid::LOM::User> - User information for the Lights Out Management functionality.

L<Infoblox::Grid::LicenseGridWide|Infoblox::Grid::LicenseGridWide> - a Grid-wide license object.

L<Infoblox::Grid::LicensePool|Infoblox::Grid::LicensePool> - License Pool object.

L<Infoblox::Grid::LicensePoolContainer|Infoblox::Grid::LicensePoolContainer> - License Pool Container object.

L<Infoblox::Grid::LicenseSubPool|Infoblox::Grid::LicenseSubPool> - a license subpool object.

L<Infoblox::Grid::MSServer|Infoblox::Grid::MSServer> - Microsoft (r) Grid Server object.

L<Infoblox::Grid::MSServer::AdSites|Infoblox::Grid::MSServer::AdSites> - the Active Directory Site object.

L<Infoblox::Grid::MSServer::AdSites::Domain|Infoblox::Grid::MSServer::AdSites::Domain> - the Active Directory Domain object.

L<Infoblox::Grid::MSServer::AdSites::Site|Infoblox::Grid::MSServer::AdSites::Site> - object that represents Active Directory Site. 

L<Infoblox::Grid::MSServer::AdUser|Infoblox::Grid::MSServer::AdUser> - the Active Directory User object.

L<Infoblox::Grid::MSServer::AdUser::Data|Infoblox::Grid::MSServer::AdUser::Data> - the Active Directory User Data object.

L<Infoblox::Grid::MSServer::DCNSRecordCreation|Infoblox::Grid::MSServer::DCNSRecordCreation> - An Infoblox Active Directory Domain Controller object 

L<Infoblox::Grid::MSServer::DHCP|Infoblox::Grid::MSServer::DHCP> - Grid Microsoft (r) Server DHCP object.

L<Infoblox::Grid::MSServer::DNS|Infoblox::Grid::MSServer::DNS> - Grid Microsoft (r) Server DNS object.

L<Infoblox::Grid::MaxMindDBInfo|Infoblox::Grid::MaxMindDBInfo> - an MaxMind Database information object.

L<Infoblox::Grid::Member|Infoblox::Grid::Member> - Grid Member object.

L<Infoblox::Grid::Member::BGP::AS|Infoblox::Grid::Member::BGP::AS> - BGP (Border Gateway Protocol) Autonomous System (AS) object.

L<Infoblox::Grid::Member::BGP::Neighbor|Infoblox::Grid::Member::BGP::Neighbor> - BGP (Border Gateway Protocol) neighbor object

L<Infoblox::Grid::Member::CapacityReport|Infoblox::Grid::Member::CapacityReport> - Capacity report for a specified member.

L<Infoblox::Grid::Member::CaptivePortal|Infoblox::Grid::Member::CaptivePortal> - Captive Portal object.

L<Infoblox::Grid::Member::CaptivePortal::File|Infoblox::Grid::Member::CaptivePortal::File> - Captive Portal File object

L<Infoblox::Grid::Member::Capture::Control|Infoblox::Grid::Member::Capture::Control> - Traffic capture control object

L<Infoblox::Grid::Member::Capture::Status|Infoblox::Grid::Member::Capture::Status> - Traffic capture status object

L<Infoblox::Grid::Member::DHCP|Infoblox::Grid::Member::DHCP> - DHCP member object.

L<Infoblox::Grid::Member::DNS|Infoblox::Grid::Member::DNS> - Grid Member DNS object.

L<Infoblox::Grid::Member::Discovery::CiscoAPICConfig|Infoblox::Grid::Member::Discovery::CiscoAPICConfig> - The Cisco APIC controller configuration structure.

L<Infoblox::Grid::Member::Discovery::ScanInterface|Infoblox::Grid::Member::Discovery::ScanInterface> - The scan interfaces structure.

L<Infoblox::Grid::Member::Discovery::VRF|Infoblox::Grid::Member::Discovery::VRF> - Object represents the relation between network view and the virtual network membership.

L<Infoblox::Grid::Member::DiscoveryProperties|Infoblox::Grid::Member::DiscoveryProperties> - Grid member discovery properties.

L<Infoblox::Grid::Member::FileDistribution|Infoblox::Grid::Member::FileDistribution> - Grid Member FileDistribution object.

L<Infoblox::Grid::Member::IPv6StaticRoute|Infoblox::Grid::Member::IPv6StaticRoute> - Static route member object

L<Infoblox::Grid::Member::Interface|Infoblox::Grid::Member::Interface> - Interface member object.

L<Infoblox::Grid::Member::License|Infoblox::Grid::Member::License> - License object.

L<Infoblox::Grid::Member::OSPF|Infoblox::Grid::Member::OSPF> - OSPF (Open Shortest Path First) member object.

L<Infoblox::Grid::Member::PNodeToken|Infoblox::Grid::Member::PNodeToken> - Physical Node Token object.

L<Infoblox::Grid::Member::PreProvisioning|Infoblox::Grid::Member::PreProvisioning> - Pre-Provisioned member object.

L<Infoblox::Grid::Member::PreProvisioning::Hardware|Infoblox::Grid::Member::PreProvisioning::Hardware> - PreProvisioning hardware info object.

L<Infoblox::Grid::Member::QueryFQDNParameter|Infoblox::Grid::Member::QueryFQDNParameter> - A FQDN query parameters.

L<Infoblox::Grid::Member::QueryFQDNResponse|Infoblox::Grid::Member::QueryFQDNResponse> - A FQDN query response.

L<Infoblox::Grid::Member::RestartServiceStatus|Infoblox::Grid::Member::RestartServiceStatus> - The restart status for member services.

L<Infoblox::Grid::Member::ServiceStatus|Infoblox::Grid::Member::ServiceStatus> - Service Status object.

L<Infoblox::Grid::Member::StaticRoute|Infoblox::Grid::Member::StaticRoute> - Static route member object

L<Infoblox::Grid::Member::Taxii|Infoblox::Grid::Member::Taxii> - A Taxii Member object.

L<Infoblox::Grid::Member::Taxii::RPZConfig|Infoblox::Grid::Member::Taxii::RPZConfig> - A Taxii Member RPZ Configuration object.

L<Infoblox::Grid::Member::ThreatProtection|Infoblox::Grid::Member::ThreatProtection> - Member Threat Protection object.

L<Infoblox::Grid::Member::ThreatProtection::Rule|Infoblox::Grid::Member::ThreatProtection::Rule> - Member Threat Protection Rule object.

L<Infoblox::Grid::NTPAccess|Infoblox::Grid::NTPAccess> - Grid Network Time Protocol (NTP) access object.

L<Infoblox::Grid::NTPKey|Infoblox::Grid::NTPKey> - Grid Network Time Protocol (NTP) key object.

L<Infoblox::Grid::NTPServer|Infoblox::Grid::NTPServer> - Grid Network Time Protocol (NTP) server object.

L<Infoblox::Grid::NamedACL|Infoblox::Grid::NamedACL> - Named ACL object.

L<Infoblox::Grid::NatGroup|Infoblox::Grid::NatGroup> - NAT Group object.

L<Infoblox::Grid::ObjectsChangesTrackingSetting|Infoblox::Grid::ObjectsChangesTrackingSetting> - the object changes tracking setting.

L<Infoblox::Grid::PersonalSmartFolder|Infoblox::Grid::PersonalSmartFolder> - Personal Smart Folder object.

L<Infoblox::Grid::RIR|Infoblox::Grid::RIR> - Regional Internet Registry (RIR) object.

L<Infoblox::Grid::RIR::Organization|Infoblox::Grid::RIR::Organization> - Regional Internet Registry (RIR) organization object.

L<Infoblox::Grid::RPZ::ThreatDetails|Infoblox::Grid::RPZ::ThreatDetails> - RPZ ThreatDetails object.

L<Infoblox::Grid::RecordNamePolicy|Infoblox::Grid::RecordNamePolicy> - Manages the DNS record name policies defined at the grid level.

L<Infoblox::Grid::RestartBannerSetting|Infoblox::Grid::RestartBannerSetting> - The restart banner setting.

L<Infoblox::Grid::RootNameServer|Infoblox::Grid::RootNameServer> - Custom root name server object.

L<Infoblox::Grid::SNMP::Admin|Infoblox::Grid::SNMP::Admin> - Manages a SNMP Admin object.

L<Infoblox::Grid::SNMP::IPAMThreshold|Infoblox::Grid::SNMP::IPAMThreshold> - IPAM Utilization SNMP Threshold object.

L<Infoblox::Grid::SNMP::IPAMTrap|Infoblox::Grid::SNMP::IPAMTrap> - IPAM Utilization SNMP Trap object.

L<Infoblox::Grid::SNMP::QueriesUser|Infoblox::Grid::SNMP::QueriesUser> - Grid SNMP QueriesUser object.

L<Infoblox::Grid::SNMP::ThresholdTrap |Infoblox::Grid::SNMP::ThresholdTrap > - Threshold Trap object.

L<Infoblox::Grid::SNMP::TrapNotification |Infoblox::Grid::SNMP::TrapNotification > - Trap Notification object.

L<Infoblox::Grid::SNMP::TrapReceiver|Infoblox::Grid::SNMP::TrapReceiver> - Grid SNMP TrapReceiver object.

L<Infoblox::Grid::SNMP::User|Infoblox::Grid::SNMP::User> - Grid SNMP User object

L<Infoblox::Grid::ScheduleSetting|Infoblox::Grid::ScheduleSetting> - a schedule setting object.

L<Infoblox::Grid::ScheduledBackup|Infoblox::Grid::ScheduledBackup> - Scheduled Backup object.

L<Infoblox::Grid::ScheduledTask|Infoblox::Grid::ScheduledTask> - scheduled task object.

L<Infoblox::Grid::ScheduledTask::ChangedObject|Infoblox::Grid::ScheduledTask::ChangedObject> - Scheduled Task Changed Object.

L<Infoblox::Grid::ServiceRestart|Infoblox::Grid::ServiceRestart> - a Grid Service Restart setting object.

L<Infoblox::Grid::ServiceRestart::Group|Infoblox::Grid::ServiceRestart::Group> - a Grid Service Restart Group object.

L<Infoblox::Grid::ServiceRestart::Group::Order|Infoblox::Grid::ServiceRestart::Group::Order> - A Grid Service Restart Group Order object.

L<Infoblox::Grid::ServiceRestart::Group::Schedule|Infoblox::Grid::ServiceRestart::Group::Schedule> - A Grid Service Restart Group Schedule object.

L<Infoblox::Grid::ServiceRestart::Request|Infoblox::Grid::ServiceRestart::Request> - A Grid Service Restart Request object.

L<Infoblox::Grid::ServiceRestart::Request::ChangedObject|Infoblox::Grid::ServiceRestart::Request::ChangedObject> - A Grid service restart request changed object.

L<Infoblox::Grid::ServiceRestart::Status|Infoblox::Grid::ServiceRestart::Status> - A Grid Service Restart Status object.

L<Infoblox::Grid::SmartFolder::GroupBy|Infoblox::Grid::SmartFolder::GroupBy> - Smart Folder Group By object

L<Infoblox::Grid::SmartFolder::GroupByValue|Infoblox::Grid::SmartFolder::GroupByValue> - Smart Folder Group By Value object

L<Infoblox::Grid::SmartFolder::QueryItem|Infoblox::Grid::SmartFolder::QueryItem> - Smart Folder Query Item object

L<Infoblox::Grid::SmartFolderChildren|Infoblox::Grid::SmartFolderChildren> - Smart Folder retrieval item.

L<Infoblox::Grid::SyslogBackupServer|Infoblox::Grid::SyslogBackupServer> - Syslog Backup Server object.

L<Infoblox::Grid::SyslogServer|Infoblox::Grid::SyslogServer> - Syslog server object.

L<Infoblox::Grid::TestResult|Infoblox::Grid::TestResult> - A result object returned by various test functions.

L<Infoblox::Grid::ThreatAnalytics|Infoblox::Grid::ThreatAnalytics> - Grid Threat Analytics object.

L<Infoblox::Grid::ThreatAnalytics::Member|Infoblox::Grid::ThreatAnalytics::Member> - Member Analytics object.

L<Infoblox::Grid::ThreatAnalytics::ModuleSet|Infoblox::Grid::ThreatAnalytics::ModuleSet> - A Grid Threat Analytics moduleset object.

L<Infoblox::Grid::ThreatAnalytics::WhiteList|Infoblox::Grid::ThreatAnalytics::WhiteList> - a Grid Threat Analytics White List object

L<Infoblox::Grid::ThreatInsight::CloudClient|Infoblox::Grid::ThreatInsight::CloudClient> - Grid Threat Insight Cloud Client object.

L<Infoblox::Grid::ThreatProtection|Infoblox::Grid::ThreatProtection> - Grid Threat Protection object.

L<Infoblox::Grid::ThreatProtection::NATPort|Infoblox::Grid::ThreatProtection::NATPort> - a NAT Threat Protection Port object.

L<Infoblox::Grid::ThreatProtection::NATRule|Infoblox::Grid::ThreatProtection::NATRule> - a NAT Threat Protection Rule object.

L<Infoblox::Grid::ThreatProtection::Profile|Infoblox::Grid::ThreatProtection::Profile> - Threat Protection profile object.

L<Infoblox::Grid::ThreatProtection::Profile::Rule|Infoblox::Grid::ThreatProtection::Profile::Rule> - Threat Protection profile rule object.

L<Infoblox::Grid::ThreatProtection::Rule|Infoblox::Grid::ThreatProtection::Rule> - Grid Threat Protection Rule object.

L<Infoblox::Grid::ThreatProtection::RuleCategory|Infoblox::Grid::ThreatProtection::RuleCategory> - The rule category settings.

L<Infoblox::Grid::ThreatProtection::RuleConfig|Infoblox::Grid::ThreatProtection::RuleConfig> - The rule configuration.

L<Infoblox::Grid::ThreatProtection::RuleParam|Infoblox::Grid::ThreatProtection::RuleParam> - A Grid Threat Protection Rule parameter object.

L<Infoblox::Grid::ThreatProtection::RuleTemplate|Infoblox::Grid::ThreatProtection::RuleTemplate> - Grid Threat Protection Rule Template object.

L<Infoblox::Grid::ThreatProtection::Ruleset|Infoblox::Grid::ThreatProtection::Ruleset> - A Grid Threat Protection Ruleset object.

L<Infoblox::Grid::ThreatProtection::StatInfo|Infoblox::Grid::ThreatProtection::StatInfo> - Statistics information.

L<Infoblox::Grid::ThreatProtection::Statistics|Infoblox::Grid::ThreatProtection::Statistics> - Threat protection statistics.

L<Infoblox::Grid::TimeZone|Infoblox::Grid::TimeZone> - Grid time zone object.

L<Infoblox::Grid::UpdatesDownloadMemberConfig|Infoblox::Grid::UpdatesDownloadMemberConfig> - An Updates Download Member Configuration object.

L<Infoblox::Grid::UpgradeGroup|Infoblox::Grid::UpgradeGroup> - Upgrade Group object.

L<Infoblox::Grid::UpgradeGroup::Member|Infoblox::Grid::UpgradeGroup::Member> - Upgrade Group Member object

L<Infoblox::Grid::UpgradeSchedule|Infoblox::Grid::UpgradeSchedule> - Information about the Grid's upgrade schedule.

L<Infoblox::Grid::UpgradeStatus|Infoblox::Grid::UpgradeStatus> - Information about the Grid's upgrade status.

L<Infoblox::Grid::VDiscoveryTask|Infoblox::Grid::VDiscoveryTask> - the vDiscovery task.

L<Infoblox::Grid::X509Certificate|Infoblox::Grid::X509Certificate> - An X509Certificate object.

L<Infoblox::IFMap::CACertificate|Infoblox::IFMap::CACertificate> - IF-MAP CA Certificate object.

L<Infoblox::IFMap::Client::Credentials|Infoblox::IFMap::Client::Credentials> - IF-MAP Credentials object

L<Infoblox::IPAM::Address|Infoblox::IPAM::Address> - IPAM address object

L<Infoblox::IPAM::DiscoveryTask|Infoblox::IPAM::DiscoveryTask> - Network discovery configuration

L<Infoblox::IPAM::DiscoveryTask::VServer |Infoblox::IPAM::DiscoveryTask::VServer > - VMWare discovery server object.

L<Infoblox::IPAM::Statistics|Infoblox::IPAM::Statistics> - Manages IPAM statistics.

L<Infoblox::IPAM::TCPPort|Infoblox::IPAM::TCPPort> - Network discovery TCP port

L<Infoblox::LDAP::AuthService|Infoblox::LDAP::AuthService> - An LDAP Authentication Service object.

L<Infoblox::LDAP::EA_Mapping|Infoblox::LDAP::EA_Mapping> - An LDAP Extensible Attribute Mapping object.

L<Infoblox::LDAP::Server|Infoblox::LDAP::Server> - An LDAP Server object.

L<Infoblox::MasterGrid::Grid|Infoblox::MasterGrid::Grid> - Manages the Master Grid settings.

L<Infoblox::Notification::REST::Endpoint|Infoblox::Notification::REST::Endpoint> - A REST API endpoint object.

L<Infoblox::Notification::REST::Template|Infoblox::Notification::REST::Template> - REST API template object.

L<Infoblox::Notification::REST::TemplateInstance|Infoblox::Notification::REST::TemplateInstance> - A REST API template instance.

L<Infoblox::Notification::REST::TemplateParameter|Infoblox::Notification::REST::TemplateParameter> - A REST API template parameter.

L<Infoblox::Notification::Rule|Infoblox::Notification::Rule> - A notification rule object.

L<Infoblox::Notification::RuleExpressionOp|Infoblox::Notification::RuleExpressionOp> - A notification rule expression operand object.

L<Infoblox::OCSP::Responder|Infoblox::OCSP::Responder> - an OCSP authentication responder.

L<Infoblox::Session|Infoblox::Session> - Session object to manipulate data within a grid.

