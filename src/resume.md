# Tushar Pandey
+919380611436 | tusharpandey13@gmail.com | [linkedin.com/in/tusharpandey13](https://www.linkedin.com/in/tusharpandey13/) | [github.com/tusharpandey13](https://github.com/tusharpandey13)

## Profile Summary

Software Engineer with **4+ years** building **identity and authentication infrastructure**. Primary maintainer of open-source SDKs with **21M+ monthly installs**. Shipped security-critical features across **11 repositories**, released **31 SDK versions**, and built a **new SDK from scratch**. Previously scaled token services to **4,000 TPS** for **40M+ users** at ZEE5.

## Experience

### Software Development Engineer 2, Authn-SDKs | Auth0 (Okta) | July 2024 -- Present
_Primary maintainer of nextjs-auth0 (21M+ monthly downloads, 141% growth in tenure) | Bangalore, India_

- **Multi-Factor Auth (MFA)**: Shipped full MFA step-up support for Next.js SDK. Users can now challenge, verify, and enroll factors natively. First server-side Auth0 SDK with this capability. Design to production in 5 weeks.
- **Multi-Domain Support**: Rewired SDK from single-domain to dynamic per-request domain resolution. Customers with multiple brands now use one SDK instance. Zero breaking changes, sessions auto-migrate.
- **New SDK (auth0-hono)**: Built and shipped a new authentication SDK for the Hono framework. 8,100+ lines of code, 291 tests, runs on Node, Cloudflare Workers, Deno, and Bun. Gap analysis to shipping in 4 weeks.
- **Cross-SDK Features**: Delivered DPoP (proof-of-possession tokens), token exchange, and organization-scoped auth across Next.js, SPA, and Node SDKs. Cut 31 releases across 3 packages in 16 months.
- **Security**: Patched critical Next.js cache poisoning vulnerability (affected all Next.js users globally) across Auth0 SDK ecosystem. Owned and resolved auth parameter injection bugs and coordinated fixes with security team.
- **Technical Direction**: Authored 15+ design docs adopted across teams. Proposed and got approval for 10+ architecture decisions in cross-team reviews. Unblocked stalled features by building working prototypes instead of writing longer docs.

### Software Development Engineer 1, B2B-Subscriptions | ZEE5 | August 2022 -- July 2024
_Scaling video streaming platform for 65M+ monthly active users | Bangalore, India_

- **Mirage**: Built high-throughput token exchange service handling 4,000 requests/sec, powering cross-platform streaming for 40M+ B2B users (60% of ZEE5's revenue base).
- **Cloud Migration**: Led zero-downtime AWS to GCP migration including PostgreSQL to Cloud Spanner for 5M+ daily auth events. Cut DB latency to under 10ms.
- **Subscription Engine**: Built async subscription orchestrator with automatic failover. Hit 99.9% uptime on revenue-critical B2B flows while cutting cloud spend.
- **Platform Rewrite**: Moved Node.js services to Java WebFlux. 10x throughput, zero regressions, zero customer-facing downtime.

## Key Projects

### **Forge: AI Development Workflow Engine** | _Claude Code, TypeScript, State Machines_

- Built a multi-phase AI orchestrator that automates the full software lifecycle: requirements, design, implementation, review, and documentation.
- Used to ship two major SDK features (MFA and Multi-Domain). Adopted by team for AI-assisted development.

### **OPAL: Real-time Log Analytics (Auth0 Hackathon Finalist)** | _ClickHouse, S3, Benthos, Cube.js_

- Built analytics engine ingesting **13k events/sec** for customer usage insights. Estimated **$70k/month savings** over existing solution.
- Column-oriented storage with 130:1 write-read efficiency. Live dashboards and log search integrated into product.

## Technical Skills

- **Languages**: TypeScript, Java, Python, Go, Rust (learning)
- **Auth/Identity**: OAuth 2.0/2.1, OIDC, DPoP, MFA, PKCE, Token Exchange, Session Management
- **Frameworks**: Next.js, React, Hono, Node.js, Spring WebFlux, Vitest
- **Infrastructure**: ClickHouse, PostgreSQL, Cloud Spanner, Redis, Kafka, Cloudflare Workers, Docker
- **AI/Tooling**: Claude Code, LLM-driven automation, RAG pipelines, prompt engineering
- **Practices**: Design-doc-driven delivery, security review, release management, open-source maintenance

## Education

### BMSIT, Bangalore | 2018 -- 2022
_Bachelor of Technology, Computer Science | Bangalore, India_
