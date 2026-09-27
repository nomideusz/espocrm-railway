# Deploy and Host CRM (EspoCRM) on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/crm?utm_medium=integration&utm_source=button&utm_campaign=crm)

[EspoCRM](https://www.espocrm.com/) is an open-source CRM: accounts, contacts, leads, opportunities with a sales pipeline, cases, calendar, tasks, email, reports and a portal for customers. You can add your own fields, entities and layouts without code. This template runs EspoCRM 10.0.8 on the official image with Postgres. The admin account is created on first boot, and live updates run over WebSocket, so it works as soon as the deploy finishes.

## About Hosting CRM (EspoCRM)

There are two services: EspoCRM and Postgres.

- **One EspoCRM service.** The web app, the job daemon (reminders, email fetching, workflows) and the WebSocket server run together in one container on the official 10.0.8 image. Upstream's Docker setup runs them as three containers that share volumes, which Railway can't do.
- **Admin ready on boot.** Log in as `admin` with a generated password. There is no installer page left open.
- **Your changes persist.** Uploads, config, and the custom fields, entities, layouts and extensions you add are all kept on the one volume. Upgrading the image doesn't lose them.
- **Live updates.** Notifications, the activity stream and open records refresh as they change, without polling.
- **Upgrades that migrate themselves.** Each boot runs EspoCRM's database migrations before it starts serving.

## Common Use Cases

- Sales pipeline and lead tracking for a small team, replacing Salesforce, HubSpot or Pipedrive
- Customer support cases with a customer portal
- A contact database with email, calendar and tasks, extended with your own fields and entities

## Dependencies for CRM (EspoCRM) Hosting

- Postgres 17 (included, private network only)

### Deployment Dependencies

- [EspoCRM documentation](https://docs.espocrm.com/)
- [EspoCRM Docker guide](https://docs.espocrm.com/administration/docker/installation/)
- [Template source on GitHub](https://github.com/nomideusz/espocrm-railway)

### Implementation Details

**Sign in** at the EspoCRM service's Railway domain. The username is `admin` and the password is `ESPOCRM_ADMIN_PASSWORD` from the EspoCRM service's Variables tab. The first boot takes under a minute. Change the password afterwards under your profile, because the variable is only read on first boot. Add your team under Administration → Users.

**Email.** Railway only allows outbound SMTP on the Pro plan. On Pro, set the SMTP server under Administration → Outbound Emails. On other plans EspoCRM can't send email, but it can still fetch mail over IMAP: set up personal email accounts or group inboxes under Administration.

**Memory.** Around 250 MB at idle for EspoCRM and 80 MB for Postgres.

**Files and backups.** Uploads, config and customizations are on the EspoCRM volume, and records are in Postgres, so turn on Railway's volume backups for both services.

**Custom domain.** Add it in the EspoCRM service's Settings → Networking. Then set `ESPOCRM_SITE_URL` to `https://` followed by your domain. EspoCRM picks it up on the next boot, and live updates follow.

## Why Deploy CRM (EspoCRM) on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying CRM (EspoCRM) on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
