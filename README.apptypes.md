Portron Features

Portron wraps your electron application with a tight minimalistic yet
super-efficient linux system you will barely notice. The real star here
is your electron application, that will be launched full screen after a
splash screen you provide.

Your electron application is run on Kiosk mode and is impossible to escape.
Portron provides an optional "POWER MENU" that you access with the power key,
that allows to configure the settings, the network, shutdown or reboot the system.
This power menu blends beautifully with your application.

You can generate several types of Portron systems, depending on if your
application requires network and/or persistence.

    Type 1) No Network, No Persistence

        This will be a live-only system, with no wizards, installers or
        anything. You insert the media on a computer, a splash screen is
        shown and your electron application starts full-screen, period.

        Your electron application will not have a working network connection
        or store persistent data.

        This is useful for simple signage applications that use local
        content.

        TYPICAL USE FLOW:
        - First runs: Splash Screen -> (Optional) Configurator -> Electron App
        - All runs: Splash Screen -> Electron App

        POWER MENU options: ShutDown, Configuration, Reboot

    Type 2) Network without persistence.

        This will also be a live-only system. The first time it is run,
        a network wizard will be shown to configure the network.

        You can choose wether to write the settings to the live media
        so your application will automatically boot next


        USEFUL FOR: Electron applications that do not need persistent local
        storage but need a network connection.

        TYPICAL USE FLOW:
        - First Run: Splash Screen -> Network Wizard -> Electron App
        - Next runs: Splash Screen -> Electron App (if settings were saved)

        POWER MENU options: Network Wizard, Write settings, ShutDown, Reboot


    Type 3) No Network, with persistence

        This will require the user to install the application the first
        time it is run.

        Your application can be installed to any hard-disk or writable
        removable media (including the same one used to boot).

        Mind that The WHOLE SELECTED DEVICE is then used for your
        application (Portron uses 3 partitions and UEFI boot). YOU
        CANNOT SHARE PORTRON WITH OTHER OPERATING SYSTEMS ON THE SAME
        DEVICE (ie. HARD DISK) If you need multi-boot, you will need
        more than 1 ssd (one for your Portron App, and more for the
        rest of your OSs)


        With this application model, you can store files at your will
        from your electron application.

        Additionally, all electron internal files are also kept persistent,
        so cached files, browser sessions, cookies, localstorage, etc...
        work across reboots.

        Useful for: Electron applications that need persistent storage.
        As a bonus, electron is also configured to keep the cache files,
        localstorage, browser sessions, etc. in the persistent storage.

        TYPICAL USE FLOW:
        - First Run: Splash Screen -> Installer -> reboot
        - Next runs: Splash Screen -> Electron App

        POWER MENU: Shutdown, Reboot, Configuration



    Type 4) Network and Persistence

        Just like the former, but network wizard is also run automatically
        if a network connection is not configured.

        Useful for: Electron applications that need a working network connection
        and persistent storage.

        TYPICAL USE FLOW:
        - First Run: Splash Screen -> Network Wizard -> Installer -> reboot
        - Next runs: Splash Screen -> Electron App

        POWER MENU: Shutdown, Reboot, Network Wizard, Configuration

- Multi-Monitor Hotplug
- Audio and HDMI audio
- Removable Media