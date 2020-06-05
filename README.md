# SwiftNetrek

SwiftNetrek - 2 April 2019 - Updated 4 May 2020

This is an OBSOLETE VERSION using SpriteKit.  Compatible with MacOS 10.14.  For the latest MacOS 10.15 SpriteKit version, go to https://github.com/darrellroot/Netrek-SwiftUI/

If you just want to grab a MacOS 10.15 SwiftUI binary to play Netrek, download "Netrek" from the MacOS App Store.  Free download.

For a MacOS 10.14 binary (of this version), go to http://networkmom.net/netrek/

Netrek is the original Internet team game, originally implemented in C in 1989 by Kevin Smith and Scott Silvey for UNIX Workstations running X-windows.  Netrek was based on XTrek, written by Chris Guthrie in 1986.  XTrek used XWindow remote displays to allow one host to run several clients on a LAN.  Netrek was open sourced with very lenient copyright notices.

Netrek is a client-server application.  As of April 2019, Netrek servers remain implemented in C and run on UNIX/Linux computers.  There are many Netrek clients in several languages, including C, Java, Python, Objective C and even HTML5!

This project is a Netrek client reimplementation using Swift for MacOS.  It does not use any source code from prior implementations, but (of course) uses the original Netrek network API to talk to the remote Netrek server over TCP.  Because we do not use any prior source code, we are going to switch from the historic copyright.h and copyright2.h licenses to the standard MIT license.  The licenses are equivalent (granting full programmer permission, but with an "AS IS" legal disclaimer).

HELP BUNDLE NOTE: Do not directly modify files under Netrek/Resources/Netrek.help.  That directory is built from Netrek.pchelp by the HelpCrafter application.
