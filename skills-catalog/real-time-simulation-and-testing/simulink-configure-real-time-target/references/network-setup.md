# Network Setup

Use this reference when `connect(tg)`, `load(tg, app)`, or `slrealtime.testSetup(tg)` fails for a reachable-looking target computer. Start with the host link, IP address, Windows firewall profile, and the Simulink Real-Time port table below. Do not use `setipaddr` as a troubleshooting step; it changes the target NIC configuration and is normally appropriate only during initial setup or an intentional subnet migration.

## R2026a Port and Protocol Requirements

R2026a and newer Simulink Real-Time targets use a 64-bit Linux-based RTOS on Speedgoat hardware, with these host-target ports:

| Protocol | Transport Protocol | Target PC (Remote Port) | Host PC (Local Port) |
| --- | --- | --- | --- |
| FTP | TCP | 20-21 | Ports assigned by host OS |
| SSH, SFTP* | TCP | 22 | Ports assigned by host OS |
| XCP** | UDP | 5555 | Ports assigned by host OS |
| MQTT | TCP | 1883 | Ports assigned by host OS |
| MQTT over TLS (Secure MQTT)*** | TCP | 8883 | Ports assigned by host OS |
| HTTP / HTTPS*** | TCP | 8080 | Ports assigned by host OS |

* By default, the host-target connection in MATLAB uses FTP. SFTP can be enabled separately when the workflow requires it.

** Since R2026a, XCP is no longer used by the host-target connection in MATLAB. It is required only when third-party calibration tools such as Vector CANape or ETAS INCA connect to the target computer as an XCP server.

*** Use `setupTLSCertificate(tg)` to configure TLS material for MQTT and HTTP.

## When `slrealtime.testSetup` Diagnoses the Issue

`slrealtime.testSetup` runs eight tests against a connected target. Use it early after basic reachability is established because the failing test usually narrows the cause:

| Test failure | Likely cause |
| --- | --- |
| Test 1 - system ping fails | Cable, target IP, target powered off |
| Test 1 OK but Test 2 - SSH hangs/fails | Host firewall profile, wrong username/password |
| Test 3 - file transfer fails | FTP/SFTP service on target, host firewall on outbound file transfer |
| Test 4 - target image version | RTOS image too old; consider `update(tg)` after user approval |
| Test 5 - target environment file | `~/.slrt/TargetOptions.env` missing or malformed |
| Test 6 - MQTT connectivity | Mosquitto broker on target inactive; firewall on port 1883/8883 |
| Test 7 - HTTP(S) connectivity | `slrtd` REST service inactive; HTTPS without TLS material |
| Test 8 - basic workflow (build/load/start) | Toolchain, model issue, or running app already loaded |

For Tests 6 and 7, helper functions probe `systemctl is-active mosquitto` and `systemctl is-active slrtd` over root SSH, so a Test-2 failure cascades.

`slrealtime.testSetup` will not always surface a firewall issue clearly. Test 1 (system ping) bypasses MATLAB entirely, so it can pass while Test 2 (SSH from MATLAB's process) hangs. If the user reports `testSetup` stuck on Test 2 or Test 6, check firewall classification before changing target settings.

## Static IPs on Direct Host-to-Target Links

The target computer must be configured with a static IP.

Static IP addresses are recommended for both sides of a direct host-to-target connection. Configure the target computer's Host Link interface with a static IP address, and configure the development computer's dedicated Ethernet adapter with a nonroutable static IPv4 address on the same subnet, such as `192.168.x.x` or `10.x.x.x` with subnet mask `255.255.255.0`. Do not use DHCP for the dedicated host adapter.

## Speedgoat Host Link Port

On Speedgoat hardware, the Ethernet port labeled **Host Link** is the one that talks to MATLAB. Other Ethernet ports on the target computer are for I/O networks such as CAN-over-Ethernet or EtherCAT, and are configured separately by the target application.

When the user reports "I plugged it in and `connect(tg)` says target unreachable," confirm the cable is on the Host Link port before debugging IP or firewall.

## Windows Firewall - Public vs. Private

When MATLAB or Simulink Real-Time services first try to open a socket on Windows, the OS asks whether to allow the app on Public networks, Private networks, or both. The default selection is Private only. If the host-target Ethernet is classified as Public, MATLAB can fail with little useful diagnostic text.

Two common fixes:

1. Reclassify the lab Ethernet as Private: Settings -> Network & Internet -> Ethernet -> Private.
2. Allow the relevant executable on Public and Private networks: Control Panel -> Windows Defender Firewall -> Allowed apps.

Programs that may need allowance include **MATLAB.exe**, any antivirus-bundled FTP filter that blocks outbound file transfer, and any standalone application `.exe` produced with MATLAB Compiler that communicates with the Simulink Real-Time target. A compiled app is a separate executable from MATLAB, so firewall allowance for MATLAB.exe does not automatically cover it.

With explicit user approval and an administrator PowerShell, the common lab-Ethernet profile fix is:

```powershell
Get-NetConnectionProfile
Set-NetConnectionProfile -Name "Unidentified network" -NetworkCategory Private
```

Use `Get-NetConnectionProfile` to find the network profile used for development-host to target-computer communication. If the profile name differs, use that exact `Name` value instead of `"Unidentified network"`.

If ping works but `connect(tg)` or `load(tg, app)` fails, prioritize host firewall rules and network classification before changing the target IP.

## Changing the Target IP from MATLAB - Initial Setup Only

Use `setipaddr` only when the user intentionally wants to reconfigure the target NIC, usually during first setup or an approved move to a different subnet. Do not call it to "fix" a connection problem after a failed `connect` or `testSetup` run.

`tg = setipaddr(tg, addr, netmask)` is the programmatic equivalent of the Simulink Real-Time Explorer **Change IP Address** dialog. It returns a refreshed Target object; always capture the return value. The original `tg` is stale after the call because the target NIC has changed and the session has disconnected.

It:

1. Disconnects the current session.
2. SSHes into the target as root and rewrites the network config.
3. Reboots the target NIC, functionally equivalent to a target reboot for connectivity.
4. Notifies `SetIPAddressBegin` / `SetIPAddressCompleted` events.

The `netmask` argument is optional and defaults to `255.255.255.0`. Both inputs are validated as IPv4 dotted-quad strings; bad values raise `slrealtime:target:badipaddr` or `slrealtime:target:badnetmask` before any target-side change.

`setipaddr` updates the persistent host-side `TargetSettings.address` record in addition to reconfiguring the target NIC, so the next `tg = slrealtime("<name>")` binds to the new address automatically:

```matlab
tg = setipaddr(tg, "10.0.0.5", "255.255.255.0");   % capture the refreshed Target
% No removeTarget/addTarget needed; the host record was already updated.
```

If the agent ignores the return value and reuses the original `tg`, the next call goes to the old address. Flag that failure mode when reviewing existing code.

## Detecting Missing Speedgoat Tooling

A connection failure on Speedgoat hardware is often a missing **Speedgoat I/O Blockset**, not a network fault. Check for the tooling before working through the host-link, IP, and firewall steps above, and say which of the two you are looking at.

The Speedgoat library is **not a MATLAB support package**: `matlabshared.supportpkg.getInstalled` returns empty on a host where it is installed and working. It ships as a MATLAB path folder, `C:\ProgramData\Speedgoat\speedgoatlib\<release>\<library-version>\sg_functions`, added by the Speedgoat installer.

Probe it with `which`, and report the version:

```matlab
hasSpeedgoat = ~isempty(which("speedgoat.version"));
if hasSpeedgoat
    fprintf("Speedgoat I/O Blockset %s\n", speedgoat.version);
else
    disp("Speedgoat I/O Blockset not on the MATLAB path.");
end
```

**Do not use `exist` for this.** `exist("speedgoat.version")` returns `0` on a host where the function resolves and runs — `exist` does not look up dotted package-qualified function names — and `exist(name,"package")` is not a valid call at all; the only accepted second inputs are `var`, `builtin`, `class`, `dir` and `file`. Verified on MATLAB 26.1.0.3276743 (R2026a) with Speedgoat library 10.0.0.2 installed. An agent that reaches for `exist` here reports the tooling missing when it is present.

When it is genuinely absent, say so and stop rather than guessing at the network: the Speedgoat installer is the remedy, and the release-specific folder name means a library installed for a different MATLAB release will also not be on the path. Neither is something this skill can fix from MATLAB.

Once the library is present, its inventory helpers query the **target machine**, not the host: `speedgoat.showInstalledIoModules` and `speedgoat.getIoInterfaces` enumerate the I/O modules and Ethernet interfaces on the box and therefore need a reachable target, so a failure there is a connection problem again, not a tooling problem. One Speedgoat-specific symptom worth recognizing: a `failed target authentication` message is neither network nor blockset — `speedgoat.getTargetAuthentication` produces the info file Speedgoat Support needs in order to issue a serial file, and only Support can resolve it.

## What This Skill Does Not Do

- Change the development computer's IP address, firewall rules, or network classification without explicit user action and appropriate permissions. Recommend collaboration with the user's IT or system administrator when elevated privileges or corporate policy are involved.
- Configure I/O networks on the target (CAN, EtherCAT). Those are a target-side concern out of scope.
- Diagnose Speedgoat hardware faults such as link-light or NIC failures. Recommend Speedgoat support when hardware symptoms remain after the host-link, IP, and firewall checks.

----

Copyright 2026 The MathWorks, Inc.

----
