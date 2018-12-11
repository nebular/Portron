<h1>initial commit - please do not use yer - project is not ready </h1>

<h1>PorTRON 0.4</h1>
<h4>(C) 2018 Rodolfo Lopez Pintor - Nebular Streams</h4>

<h2>PorTRON: Where Porteus meets Electron,</h2>

Portron is a minimalistic, Super-Slim wrapper Linux distribution for your electron
application.

A One-line script will transform your electron application into an installable ISO
with a super-slim linux system fine-tuned to launch your electron application in kiosk
mode, and provide all network and multimedia services.

Portron is based on Porteus-Kiosk distribution, a proven technology that features the
latest Linux kernel and relevant video, audio, network and multimedia drivers to match
today's embedded and desktop devices.

The bootable system includes graphical wizards to configure the system from a fresh run:
network, screen resolution, sound, microphone, keyboard layout ... as well as an option
to install the system persistently to the Hard Disk, SD-Card or the same USB Key.

<h2>How to use PorTron?</h2>

<li>unpack PorTron-builder in eg. /opt/portron and run the installation script for
    linux or OSX. It should install the dependencies.</li>

<li>use electron-builder to build your electron application. Select "linux" and
    "tar.gz" as application output type. NOTE: ONLY applications generated by
    eletron-builder will work. Also, please make sure your application filename is
    just as provided by electronbuilder (do not rename it), like: mycoolapplication-1.0.3.tar.gz or
    mycoolapplication-1.0.3-xxx.tar.gz, as the scripts depend on that format and version info to strip
    the application filename, executable, etc. Likewise, that name should also be the name of your
    electron package. If it sounds confusing remember it boils down to a simple rule: Use the tar.gz
    as-is. Do not rename or change anything.

3 - <li>invoke the builder:</li>

    /opt/portron/bin/electron-tgz2iso [input.tar.gz] [splashscreen.jpg] [output.iso] [

        ie. /opt/portron/bin/electron-tgz2iso yourapplication.1.0.tar.gz yourapplication.jpg yourapplication.iso

            - first parameter: Your app in .tar.gz format as provided by eletron-builder
            - second parameter: A Splash screen to be displayed while your application is loading
            - third parameter: Name of the resulting ISO file


    ... and that's it. You will get an ISO file that will be like 70Mb bigger than your
    original application. It's all self-contained, run it on a Virtual Machine to
    test it, or ...


<li> optional - Create a bootable USB or CD. For example, to create a bootable USB:</li>

    dd bs=1m if=yourapplication.iso of=/dev/xxx
    (set XX to your unix USB device, eg. /dev/rdisk2 or /dev/sdd, etc. Be careful, you know)



<h2>PorTron dependencies and requirements</h2>

    The scripts are still a little rough, and if this dependencies are not met
    they can fail unpredictably.

    mksquashfs (debian package squashfs-tools)
    isohybrid (included, compiles on installation)
    sh
    write permissions to /tmp/ directory
    enough space on hard disk, like 3 times the original .tar.gz file, for intemediate files


    Isohybrid source code is provided, as it is a very small program, you can compile
    it yourself with gcc if not able to install it from your repository.

Considerations
--------------

    Package structure:

    <pre>
    ./portron/

        ./bin           portron command-line utilities. Here are the scripts
                        you want to use, specifically electron-tgz2iso. You
                        can also generate the electron XZM module only with
                        electron-tgz2xzm and include it on custom porteus systems.

        ./src           source distrinution packages, not needed for building normally,
                        but provided just in case you need to modify the core modules.

                        000-kernel
                            Contains the linux kernel
                        001-core
                            Contains the base linux system programs
                        002-system
                            Contains the base linux system structure
                        003-theme
                            All files related to UI theming
                        004-wifi
                            WIFI subsystem
                        100-portron
                            Core portron files and libraries
                        101-portron-wizard
                            Install wizard, Runtime Configuration Wizard,
                            Network Wizard, Screen Wizard ...
                         90-xterm
                            Optionalg: An X-Term
                         08-sshd
                            Optional: SSH server
                         09-httpd
                            Optional: micro HTTP server


        ./lib           build support files

            ./portron.default/
                    Source Portron Distribution (4.7.0)

            ./xzm.fs
                    root filesystem that is packed with your electron app. It basically
                    includes native linux dependencies for Electron, and some scripts.
                    You can tweak values or include additional native libraries here.

            ./src.initrd
                    source initrd. contains low level system startup scripts.

    </pre>


<h2>Troubleshooting</h2>
---------------

    This script is guaranteed to work in Mac OS-X Mojave, but it should
    work in any Linux meeting the dependencies.

    Mac OSX:
        brew install squashfs-tools
        compile isohybrid in bin/isohybrid (make.sh provided, needs a basic gcc)

    Linux:
        apt-get install cdrtools squashfs-tools


License
-------

    This work is based on Porteus that is protected under a GPL License. So we
    also release it under the same license terms.


TO-DO
------

    The install wizards are recycled from the original Porteus. The original distro
    uses a pretty elaborate and obfuscate encryption system to keep the settings. This
    is not used here, but there might be some code remaining as it is deep buried into
    Porteus codebase.


    Our decision is to keep most settings unencrypted at the persistent partition,
    so values like the screen can be changed without the n



