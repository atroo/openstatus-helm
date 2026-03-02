# OpenStatus

Open-source monitoring platform and status pages.

OpenStatus lets you monitor your websites, APIs, and services with:

- **Uptime Monitoring** - Check endpoints from multiple locations
- **Status Pages** - Beautiful, public status pages for your users
- **Alerting** - Get notified via Slack, PagerDuty, Telegram, and email
- **Analytics** - Response time charts and uptime statistics

## Components

| Service | Description |
|---------|-------------|
| **LibSQL** | SQLite-based application database (Turso) |
| **Tinybird** | Real-time analytics engine (optional) |
| **Workflows** | Background job processing |
| **Server** | API backend |
| **Checker** | Health check executor |
| **Private Location** | Internal network probe |
| **Dashboard** | Web UI for managing monitors |
| **Status Page** | Public-facing status pages |

## Prerequisites

- A [Resend](https://resend.com) API key (for magic link emails)
- Generate an auth secret: `openssl rand -base64 32`

## Links

- [OpenStatus GitHub](https://github.com/openstatusHQ/openstatus)
- [OpenStatus Website](https://www.openstatus.dev)
