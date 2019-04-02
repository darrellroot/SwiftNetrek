# SwiftNetrek

SwiftNetrek - 2 April 2019

Netrek is the original Internet team game, originally implemented in C in 1989 by Kevin Smith and Scott Silvey for UNIX Workstations running X-windows.  Netrek was based on XTrek, written by Chris Guthrie in 1986.  XTrek used XWindow remote displays to allow one host to run several clients on a LAN.  Netrek was open sourced with very lenient copyright notices.

Netrek is a client-server application.  As of April 2019, Netrek servers remain implemented in C and run on UNIX/Linux computers.  There are many Netrek clients in several languages, including C, Java, Python, Objective C and even HTML5!

This project is a Netrek client reimplementation using Swift for MacOS.  It does not use any source code from prior implementations, but (of course) uses the original Netrek network API to talk to the remote Netrek server over TCP.  Because we do not use any prior source code, we are going to switch from the historic copyright.h and copyright2.h licenses to the standard MIT license.  They licenses are equivalent (granting full programmer permission, but with an "AS IS" legal disclaimer).

Credits:

Netrek Servers
This client is only part of Netrek.  Playing the game would not be possible without the Netrek servers which are still running on the Internet.  As of April 2019, this includes pickled.netrek.org, continuum.us.netrek.org, and netrek.beesenterprises.com.

Programmer
This Swift Netrek Client is written by Darrell Root for Network Mom LLC.  Check out https://networkmom.net/netrek for more information.  While the client and source code are free, please considering thanking the developer with a positive review in the MacOS App Store or by leaving “tipping the developer” via in-app purchase.

Programming Language and Environment
This Swift Netrek client is written in……Swift!  The new programming language from Apple.  Chris Lattner was the originator and leader of the Swift project.  Thank you Chris!  We love this language.
Netrek uses the new “Network” framework from Apple.  This is a new API for handling TCP and UDP sockets.  It is noticeably easier to use than the old BSD socket API.
Netrek uses SpriteKit for displaying graphics in the tactical map.

Sounds
Our main sound collection is the “Dartoxian Space Weapons” sounds by jonccox from freesound.org under the Creative Commons Attribution License:

• 175262__jonccox__gun-cannon.wav

• 175265__jonccox__gun-thumper.wav (used for laser)

• 175266__jonccox__gun-spark.wav

• 175267__jonccox__gun-plasma.wav (used for plasma)

• 175269__jonccox__gun-zap2.wav (used for torpedo)

• 175270__jonccox__gun-zap.wav (used for detonate)

The following other sounds were used from freesound.org under the Creative Commons Attribution License or the Creative Commons 0 License:

• Explosion from deleted user  399303__deleted-user-5405837__explosion-012.mp3

• Shield sound from ludvique   71852__ludvique__digital-whoosh-soft.wav

Graphics
The planet icons were made by Darrell Root (Network Mom LLC) based on screenshots of the original COW Netrek Client from the 1990’s.

The Roman (red fleet), Kazari (green fleet), and Orion (blue fleet) ship icons came original from the artist Pascal Gagnon via the Gytha Netrek Client under the Creative Commons Attribution License.

The Federation (outline fleet) and Independent (also outline fleet) ship icons came from the MacTrek 1.5 client (written in Objective C in 2006) by Chris and Judith Lukassen.  Judith did the artwork.

Prior Netrek Client: MacTrek

Chris and Judith Lukassen wrote Mac Trek in Objective C around 2006.  While the Swift Netrek Client does not use any of their source code, I learned much about both Netrek and programming from their code. 

Prior Netrek Client: Gytha

James Cameron (aka Quozl) wrote the Gytha netrek client in 2012.  Implemented in Python, we used the code as a resource during our development.  James Cameron helpfully answered several questions during our development.

Prior Netrek Client: BRMH

Developed in c in the 1990’s we also used this client as a resource during development.  There are too many developers of BRMH so we refer you to http://www.netrek.org/files/archive/BRMH/BRMH.html for more information.

Netrek Vanilla Server

We used the Netrek Vanilla Server (written in C, maintained by James Cameron) as a reference during development.  See https://github.com/quozl/netrek-server for more information.

Swift Local Receipt Validator

We used SwiftyLocalReceiptValidator by Andrew Bancroft for in-app purchase processing.  It is licensed under the MIT license.  Copyright message in next section.

OpenSSL

We use OpenSSL for in-app purchase receipt validation, which requires the following message: “This product includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit (http://www.openssl.org/)”

Netrek Hints

Many of the advanced hints on the tactical screen came from the Windows netrek client courtesy of Bill Balcerski.

Historic copyright notices, although no source code from the original Netrek implementation is included in this project.

Xtrek - Copyright (c) 1986 Chris Guthrie
Permission to use, copy, modify, and distribute this software and its documentation
for any purpose and without fee is hereby granted, provided that the above copyright
notice appear in all copies and that both that copyright notice and this permission
notice appear in supporting documentation.  No representations are made about the
suitability of this software for any purpose.  It is provided "as is" without
express or  implied warranty.

Netrek (Xtrek II) - Copyright 1989 Kevin P. Smith
Permission to use, copy, modify, and distribute this software and its documentation
for any purpose and without fee is hereby granted, provided that the above copyright
notice appear in all copies and that both that copyright notice and this permission
notice appear in supporting documentation.  No representations are made about the
suitability of this software for any purpose.  It is provided "as is" without express
or  implied warranty. COW (BRM) authors (including but not limitted to: Kevin Powell
Nick Trown Jeff Nelson Kurt Siegl) Permission to use, copy, modify, and distribute
this software and its documentation, or any derivative works thereof,  for any
NON-COMMERCIAL purpose and without fee is hereby granted, provided that this copyright
notice appear in all copies.  No representations are made about the suitability of
this software for any purpose.  This software is provided "as is" without express
or implied warranty.
