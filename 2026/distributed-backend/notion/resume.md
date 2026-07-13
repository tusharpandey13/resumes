# Tushar Pandey
+919380611436 | tusharpandey13@gmail.com | [linkedin.com/in/tusharpandey13](https://www.linkedin.com/in/tusharpandey13/) | [github.com/tusharpandey13](https://github.com/tusharpandey13)

## Profile Summary

Software Engineer with **4+ years** building **high-throughput distributed systems and infrastructure**. Designed and operated async task services handling **4,000 TPS** for **40M+ users**, led zero-downtime cloud migrations, and maintained **99.9% uptime** on revenue-critical flows. Currently at Auth0 (Okta) owning production reliability and architecture across SDK infrastructure with **21M+ monthly installs**. Experienced in on-call incident response, distributed system design, and cross-team platform ownership.

## Experience

### Software Development Engineer 2, Authn-SDKs | Auth0 (Okta) | July 2024 -- Present
_Primary maintainer of nextjs-auth0 (21M+ monthly downloads, 141% growth in tenure) | Bangalore, India_

- **Technical Direction**: Authored 15+ design docs adopted across teams. Proposed and got approval for 10+ architecture decisions in cross-team reviews. Unblocked stalled features by building working prototypes instead of writing longer docs.
- **Security**: Patched critical Next.js cache poisoning vulnerability (affected all Next.js users globally) across Auth0 SDK ecosystem. Owned and resolved auth parameter injection bugs and coordinated fixes with security team.
- **Cross-SDK Features**: Delivered DPoP (proof-of-possession tokens), token exchange, and organization-scoped auth across Next.js, SPA, and Node SDKs. Cut 31 releases across 3 packages in 16 months.
- **Multi-Domain Support**: Rewired SDK from single-domain to dynamic per-request domain resolution. Customers with multiple brands now use one SDK instance. Zero breaking changes, sessions auto-migrate.
- **New SDK (auth0-hono)**: Built and shipped a new authentication SDK for the Hono framework. 8,100+ lines of code, 291 tests, runs on Node, Cloudflare Workers, Deno, and Bun. Gap analysis to shipping in 4 weeks.
- **Multi-Factor Auth (MFA)**: Shipped full MFA step-up support for Next.js SDK. Design to production in 5 weeks.

### Software Development Engineer 1, B2B-Subscriptions | ZEE5 | August 2022 -- July 2024
_Scaling video streaming platform for 65M+ monthly active users | Bangalore, India_

- **Mirage**: Built high-throughput async token exchange service handling **4,000 requests/sec**, powering cross-platform streaming for 40M+ B2B users (60% of ZEE5's revenue base).
- **Subscription Engine**: Built async subscription orchestrator with automatic failover. Hit **99.9% uptime** on revenue-critical B2B flows while cutting cloud spend. Designed for graceful degradation under load.
- **Cloud Migration**: Led zero-downtime AWS to GCP migration including PostgreSQL to Cloud Spanner for 5M+ daily auth events. Cut DB latency to **under 10ms**.
- **Platform Rewrite**: Moved Node.js services to Java WebFlux. **10x throughput**, zero regressions, zero customer-facing downtime.

## Key Projects

### **OPAL: Real-time Log Analytics (Auth0 Hackathon Finalist)** | _ClickHouse, S3, Benthos, Cube.js_

- Built analytics engine ingesting **13k events/sec** for customer usage insights. Estimated **$70k/month savings** over existing solution.
- Column-oriented storage with 130:1 write-read efficiency. Live dashboards and log search integrated into product.

### **Forge: AI Development Workflow Engine** | _Claude Code, TypeScript, State Machines_

- Built a multi-phase AI orchestrator that automates the full software lifecycle: requirements, design, implementation, review, and documentation.
- Used to ship two major SDK features at Auth0. Adopted by team for AI-assisted development.

## Technical Skills

- **Infrastructure**: ClickHouse, PostgreSQL, Cloud Spanner, Redis, Kafka, Cloudflare Workers, Docker
- **Languages**: TypeScript, Java, Python, Go, Rust (learning)
- **Frameworks**: Node.js, Spring WebFlux, Next.js, Hono, Vitest
- **Auth/Identity**: OAuth 2.0/2.1, OIDC, DPoP, Token Exchange, Session Management
- **AI/Tooling**: Claude Code, LLM-driven automation, RAG pipelines, prompt engineering
- **Practices**: Distributed systems design, on-call incident response, zero-downtime migrations, release management

## Education

### BMSIT, Bangalore | 2018 -- 2022
_Bachelor of Technology, Computer Science | Bangalore, India_
