<h1>PorTRON 0.4 Developer tools - alpha</h1>
<h4>(C) 2018 Rodolfo Lopez Pintor - Nebular Streams</h4>

This is the source linux distribution that wraps your electron application. The provided scripts would build and
install a new distribution image  to Portron Library. You then can select any of the installed distribution images
to use as your Electron application wrapper.


Package structure:

    ./portron/

        ./src

            ./modules
                        Source of all modules. Modules can be compiled with the "make.modules.sh" command.

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

            ./initrd

                    source initrd for linux boot. InitRd can be compiled and installed
                    into a existing distribution image withh the script "make.init.sh"

            ./template

                    root filesystem for the installation media.


<h2>Usage</h2>
---------------

    make.sh newdistro

        -> will compile all modules and initrd and create a new distribution image with the
           name "newdistro".

    make.init.sh newdistro

        -> will only compile initrd and install it into the spedified existing distro image.

    make.modules.sh newdistro

        -> will compile all modules and copy them to the specified existing distro image.

License
-------

GNU GPL 2.0
Please see attached <a href="../GNU_GPL">file</a>.


TO-DO
------

- Have more life

