# Home Server Project Budget Breakdown

This file provides a clear, up-to-date breakdown of all major hardware costs for the home server project. Each item includes an estimated price and a direct link to a reputable product page for easy reference or purchase. Prices are approximate and may vary by region or over time.

## Core Components (Listed by Priority)

| Item                                 | Description/Model                        | Estimated Price (USD) | Product Link | Priority |
|--------------------------------------|------------------------------------------|----------------------|--------------|----------|
| **Application/NAS Server**           | GMKtec NucBox G9 Mini PC (12GB DDR5/512GB SSD/4-bay NAS)| $210               | [Amazon](https://www.amazon.com/GMKtec-G9-Desktop-Computer-Attached/dp/B0DSLH4127) / [GMKtec](https://www.gmktec.com/products/intel-twin-lake-n150-dual-system-4-bay-nas-mini-pc-nucbox-g9) | Phase 1 (Immediate) |
| **Storage Expansion** (Optional)     | M.2 NVMe SSDs for NAS bays               | $80-300              | Varies by capacity | As needed |
| **UPS (Battery Backup)**              | Amazon Basics Standby UPS 800VA          | $76                  | [Amazon](https://www.amazon.com/Amazon-Basics-Standby-800VA-450W/dp/B07FQ4DJ7X/) | Phase 2 (Optional) |
| **Accessories**                       | Ethernet cables, power strips, misc.     | $20                  | —            | As needed |
| **Unmanaged Gigabit Switch (8-port)** | TP-Link/Netgear/UGREEN (Media Center) | $25–$30 | [Amazon](https://a.co/d/gJWiib8) | Purchased (2025) |

|                                      |                                          |                      |              |
| **Total Estimated Cost**              |                                          | **$306-526**         |              |

## Phased Purchase Plan

### Phase 1: Combined Application & NAS Server (~$210)
1. **GMKtec NucBox G9 Mini PC** ($210) - All-in-one application server and NAS
   - Implement Paperless-ngx for document management
   - Configure remote access via Tailscale
   - Take advantage of built-in 4-bay NAS functionality with dual boot Windows/Ubuntu
   - Add storage drives to NAS bays as needed when document volume grows

### Phase 2: Additional Components (Based on Need)
1. **Storage Expansion** ($80-300) - Add M.2 NVMe SSDs to available bays as storage needs increase
2. **UPS Battery Backup** ($76) - Add after core system is set up and working successfully
3. **Accessories** ($20) - Purchase as needed during implementation

### Phase 3: Future Expansion (Not currently budgeted)
1. **Additional storage** - Only if initial storage capacity proves insufficient
2. **Improved networking** - If remote access performance needs enhancement
3. **Hardware for specialized services** - Based on usage patterns and needs

## Purchase Decision Criteria

### When to Purchase Phase 1 Items
- Purchase immediately to establish both document management functionality and storage
- GMKtec NucBox G9 enables running Paperless-ngx and provides local redundant storage
- Initial 512GB SSD allows immediate document storage with room for expansion

### When to Purchase Phase 2 Items
- Additional NVMe drives: When document volume exceeds existing storage capacity
- UPS: After complete system is operational and stable (at least 2-4 weeks of testing)
- Consider UPS sooner if local power conditions are unstable

## Existing Hardware Utilization
- **iCloud Storage** - Current file backup solution, will supplement local NAS storage
- **Mac Mini** (7 years old) - Will be used as a client/utility machine only
- **Raspberry Pi** - Optional for Pi-hole/network services (if already owned)
- **External Hard Drives** - Can be used for temporary/offsite backups

---

**Notes:**
- Prices are estimates as of mid-2024 and may fluctuate.
- Links are for reference; shop around for best deals!
- This budget covers core hardware only; all software implementations utilize free/open-source options.
- The G9 NucBox replaces both the originally planned G6 NucBox and separate Synology NAS, offering significant savings.
- The integrated solution simplifies setup and maintenance while providing better connectivity (dual 2.5GbE ports).

**Purchased in 2025:** Unmanaged 8-port gigabit switch for media center expansion (see [Amazon link](https://a.co/d/gJWiib8)). 