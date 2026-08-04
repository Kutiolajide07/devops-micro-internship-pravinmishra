---
name: linux-triage
description: Diagnose Linux system health for DevOps engineers. Use when a host is slow, unresponsive, running out of resources, or when a service/network/disk issue needs investigating. Walks through CPU, memory, disk, services, networking, and logs, collecting evidence before recommending fixes. Triggers on "server is slow", "high load", "out of memory", "disk full", "service down", "why is this host unhealthy", "triage this Linux box".
---

# Linux Triage

A structured workflow for diagnosing the health of a Linux host. Follow it top to bottom: **collect evidence first, form a hypothesis, then recommend a fix.** Never guess before you have data.

## Operating principles

- **Read-only first.** Every command in the checklist below is non-destructive. Run these freely to gather evidence.
- **Evidence before recommendations.** Do not propose a fix until you can point to the specific output that supports it (a PID, a mount point, a log line, a metric).
- **Ask for human approval before any destructive or state-changing action.** See [Destructive changes](#destructive-changes). This includes killing processes, restarting/stopping services, deleting files, changing configs, unmounting, or rebooting.
- **Note privileges.** Some commands need `sudo`. If a command fails with permission denied, say so rather than silently skipping it. Do not assume root.
- **Capture, don't just glance.** Save meaningful output to `reports/` (e.g. `reports/triage-<host>-<date>.md`) so findings are reproducible.

## Troubleshooting workflow

1. **Scope the problem.** What's the symptom (slow, down, errors), which host, since when, what changed recently (deploy, config, traffic)?
2. **Baseline the system.** Uptime, load, who's logged in, recent boots.
3. **Work the checklist** below (CPU → memory → disk → services → networking → logs). Stop and go deep whenever a signal looks abnormal.
4. **Correlate.** Line up the timeline: does a log spike, an OOM kill, or a disk-full event match when the symptom started?
5. **Form a hypothesis** naming the specific resource/process/service and the evidence for it.
6. **Recommend.** Propose the least-invasive fix first. If it's destructive, request approval (see below).
7. **Verify & document.** After an approved change, re-run the relevant checks to confirm recovery, and record what was done in `reports/`.

## Evidence-collection checklist

Run these to gather data. All are read-only.

### Baseline
```bash
uname -a                      # kernel / arch
uptime                        # load averages, uptime
w                             # who's logged in + load
last reboot | head            # recent reboots
cat /etc/os-release           # distro / version
```

### CPU
```bash
top -b -n1 | head -25         # snapshot: load + top CPU consumers
mpstat 1 3                    # per-core utilization over time (sysstat)
uptime                        # 1/5/15-min load vs. core count
nproc                         # core count (compare against load)
ps -eo pid,ppid,user,%cpu,cmd --sort=-%cpu | head -15   # top CPU processes
```
Look for: load average >> core count, a single process pegging a core, high `%wa` (I/O wait) or `%sy` (kernel) time.

### Memory
```bash
free -h                       # total/used/free/available + swap
ps -eo pid,ppid,user,%mem,rss,cmd --sort=-%mem | head -15   # top memory processes
cat /proc/meminfo | head -20  # detailed breakdown
vmstat 1 3                    # si/so = swapping activity
dmesg -T | grep -i -E 'oom|killed process'   # OOM killer events
```
Look for: low `available` memory, active swapping (`si`/`so` nonzero), OOM kills.

### Disk
```bash
df -h                         # filesystem usage — watch for 100%
df -i                         # inode usage — a full inode table looks like "no space" with free bytes
lsblk                         # block devices / mounts
du -xh / --max-depth=1 2>/dev/null | sort -rh | head   # biggest dirs on root
iostat -xz 1 3                # per-device I/O + %util (sysstat)
mount | grep -i 'ro,\|read-only'   # filesystems remounted read-only (often a disk error)
```
Look for: any mount at/near 100% (bytes or inodes), high `%util` / await, read-only remounts.

### Services
```bash
systemctl --failed            # units that failed
systemctl list-units --type=service --state=running
systemctl status <service>    # state, recent logs, restart count
journalctl -u <service> --since "1 hour ago" --no-pager
systemctl is-enabled <service>
```
Look for: failed units, services flapping/restart-looping, recently-changed units.

### Networking
```bash
ip -brief addr                # interfaces + IPs, up/down state
ip route                      # default route / routing table
ss -tulpn                     # listening sockets + owning process
ss -s                         # socket summary (established, time-wait)
ping -c3 <gateway_or_host>    # basic reachability
resolvectl status || cat /etc/resolv.conf   # DNS config
curl -sS -o /dev/null -w '%{http_code} %{time_total}s\n' <url>   # endpoint health/latency
```
Look for: interface down, missing/wrong default route, expected port not listening, DNS failures, packet loss.

### Logs
```bash
journalctl -p err --since "1 hour ago" --no-pager   # recent errors (all units)
journalctl -k --since "1 hour ago" --no-pager       # kernel ring buffer (disk/network/OOM errors)
dmesg -T | tail -50
tail -n 100 /var/log/syslog 2>/dev/null || tail -n 100 /var/log/messages 2>/dev/null
ls -lt /var/log | head        # which logs changed most recently
```
Look for: error bursts, stack traces, segfaults, hardware/I/O errors, timestamps that line up with the symptom.

## Destructive changes

Before running anything that changes system state, **stop and ask a human to approve it.** Present:

1. **What** you want to run (the exact command).
2. **Why** — the evidence that justifies it.
3. **Blast radius** — what it affects and how to roll back.

Actions that require approval include (non-exhaustive):

- `kill` / `pkill` / `systemctl kill` a process
- `systemctl restart|stop|disable` a service
- `rm`, `truncate`, log rotation/deletion to reclaim disk
- editing configs, `sysctl -w`, changing firewall rules (`iptables`/`nft`/`ufw`)
- `mount` / `umount`, resizing or repairing filesystems (`fsck`)
- `reboot` / `shutdown`

Prefer the least-invasive option (e.g. reload over restart, rotate over delete) and confirm you have a rollback path.

## Example prompts

- "The web server at 10.0.2.15 is responding slowly. Triage it and tell me what's wrong before changing anything."
- "`df` says the disk is full but I deleted a bunch of files. Figure out what's actually consuming space."
- "Load average is 40 on an 8-core box. Which processes are responsible?"
- "nginx keeps restarting every few minutes. Diagnose the crash loop from the logs."
- "This host got OOM-killed last night. Walk the memory and log evidence and tell me the culprit."
- "Do a full health check of this server and write a report to reports/."
