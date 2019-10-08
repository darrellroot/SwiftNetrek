# SwiftNetrek

SwiftNetrek - 2 April 2019

In XCode there are two targets: Netrek and Netrek-public-domain.

1) You should build the Netrek-public-domain target.  That app does not use in-app-purchases and allows building the application without code signing.

2) Any files you add to the project should be added to _both_ targets: Netrek and Netrek-public-domain.  The only exception is edits to the TipController.  We have 2 versions: TipController for Netrek, and TipController-public-domain for Netrek-public-domain.

HELP BUNDLE NOTE: Do not directly modify files under Netrek/Resources/Netrek.help.  That directory is built from Netrek.pchelp by the HelpCrafter application.

Binary version now in the MacOS App Store.  Requires MacOS 10.14 Mojave to run.  If all you need is a binary, I suggest you get it there.

Netrek is the original Internet team game, originally implemented in C in 1989 by Kevin Smith and Scott Silvey for UNIX Workstations running X-windows.  Netrek was based on XTrek, written by Chris Guthrie in 1986.  XTrek used XWindow remote displays to allow one host to run several clients on a LAN.  Netrek was open sourced with very lenient copyright notices.

Netrek is a client-server application.  As of April 2019, Netrek servers remain implemented in C and run on UNIX/Linux computers.  There are many Netrek clients in several languages, including C, Java, Python, Objective C and even HTML5!

This project is a Netrek client reimplementation using Swift for MacOS.  It does not use any source code from prior implementations, but (of course) uses the original Netrek network API to talk to the remote Netrek server over TCP.  Because we do not use any prior source code, we are going to switch from the historic copyright.h and copyright2.h licenses to the standard MIT license.  They license are equivalent (granting full programmer permission, but with an "AS IS" legal disclaimer).
