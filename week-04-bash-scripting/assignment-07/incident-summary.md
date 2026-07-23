# Nginx Incident Summary

**Full Name:** Olajide Kuti

**Date:** 23/07/2026

## 1. Reported Symptom

The web application became unavailable after the Nginx service was intentionally stopped during the incident simulation. Local HTTP requests failed, indicating that the web server was no longer serving traffic.

## 2. Evidence Collected

The Bash health-check script identified three failed checks:

- Nginx service was not active.
- Port 80 was not listening for HTTP traffic.
- The local HTTP health check returned status code 000.

These results confirmed that the web service was unavailable.

## 3. Most Likely Cause

Based on the collected evidence, the most likely cause was that the Nginx service had been stopped. Because the service was inactive, it could not listen on port 80 or respond to HTTP requests.

## 4. Human-Approved Recovery Action

After reviewing Claude's recommendation, I manually executed the following command:

```bash
sudo systemctl start nginx
