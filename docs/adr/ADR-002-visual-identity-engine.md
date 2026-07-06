# ADR-002: Companion Visual Identity Engine

**Date**: 2026-07-06  
**Status**: Proposed / Pending User Approval  
**Context**: Replaces inconsistent, visibly artificial placeholder images with a persistent Companion Visual Identity Engine capable of generating photorealistic, believable human companions who maintain recognizable facial features, age, body proportions, and style across ordinary everyday photography without deceiving users into believing they are real humans.

---

## 1. Executive Summary & Selected Strategy

To maintain persistent visual identity across thousands of generated everyday photos (e.g., gym selfies, coffee shop snapshots, starlight penthouse portraits), we reject relying on text prompts or random seeds alone. 

We select **Reference-Image Conditioning via API-Managed Character Consistency (e.g., Midjourney / Flux-Dev with IP-Adapter via Replicate / OpenAI DALL-E 3 Reference)** orchestrated by our FastAPI backend.

---

## 2. Technical Evaluation of Consistency Approaches

| Approach | Consistency Quality | Operational Complexity | GPU Req. | Pros & Cons |
| :--- | :--- | :--- | :--- | :--- |
| **1. Seed Reuse Only** | Very Low | Low | No | **Fail**: Changing location, outfit, or aspect ratio causes total facial identity drift. |
| **2. Text Prompt Engineering** | Low | Low | No | **Fail**: Describing facial features in text produces generic, varying faces every time. |
| **3. Face Embeddings Only (InsightFace)** | N/A (Eval Only) | Medium | No | **Rule**: Face embeddings will be used *only* as an automated quality evaluation metric before serving images to users, not as a primary generation mechanism. |
| **4. LoRA / Fine-Tuning per Companion** | Extreme | Very High | Yes | **Fail for MVP**: Training a dedicated LoRA model per user companion requires dedicated GPU clusters, 5–15 minutes training delay, and high storage costs. |
| **5. Reference-Image Conditioning (Selected)** | **Very High** | **Medium** | **No (Managed API)** | **Selected**: Passing 1–3 approved reference portraits (`VisualIdentityProfile`) into image-to-image or IP-Adapter endpoints guarantees strict facial and structural identity preservation. |

---

## 3. Provider Comparison & Commercial Matrix

| Criterion | Replicate (Flux-Dev + IP-Adapter) | Midjourney API (via GoAPI/BFL) | OpenAI DALL-E 3 (Prompt + Ref) |
| :--- | :--- | :--- | :--- |
| **Commercial API Availability** | Generally Available | Third-party / Beta | Generally Available |
| **Flutter / Backend Path** | FastAPI -> Replicate Webhook -> Supabase Storage | FastAPI -> Polling -> Supabase Storage | FastAPI -> Direct REST -> Supabase Storage |
| **Need for GPU Infra** | No (Managed Serverless) | No (Managed) | No (Managed) |
| **Cost per Generated Image** | ~$0.025 – $0.035 | ~$0.040 – $0.060 | ~$0.040 (Standard) / $0.080 (HD) |
| **Expected Latency** | 4 – 8 seconds | 15 – 30 seconds | 8 – 14 seconds |
| **Identity Consistency Quality**| **9/10 (High structural control)** | 9.5/10 (Cinematic quality) | 7/10 (Struggles with strict facial consistency) |
| **Customization Depth** | High (ControlNet / Pose support) | Medium (Style references) | Medium (Prompt based) |
| **Moderation Support** | Automated NSFW filtering | Enforced strict filtering | Enforced strict safety prompts |
| **Data Retention Policy** | Configurable zero-retention | Standard 30-day | Zero retention after 30 days |
| **Commercial-Use Terms** | Full commercial rights | Requires Pro tier | Full commercial rights |
| **Deletion Support** | Immediate REST asset deletion | Standard deletion | Immediate REST asset deletion |
| **Vendor Lock-In Risk** | Low (Open-weights Flux architecture) | High | Medium |

### Selected Provider Architecture
- **Primary Provider**: **Replicate (Flux-Dev with IP-Adapter & ControlNet)**.
- **Why**: Offers the best balance of low cost (~$0.03/img), fast generation (4–8s), zero-retention commercial rights, and open-weights architecture preventing lock-in.
- **Fallback Provider Strategy**: If Replicate experiences downtime, the backend automatically fails over to **OpenAI DALL-E 3** or **Google Imagen 3** via Vertex AI.

---

## 4. Multi-Dimensional Consistency Requirements

To achieve believable everyday photography, the backend `VisualIdentityService` constructs structured generation requests enforcing:
1. **Facial Feature Consistency**: Always injects the companion's canonical reference portrait embedding (`VisualIdentityProfile.referencePortraitUrl`).
2. **Age & Skin Consistency**: Explicit negative prompts against "oversmoothed skin, plastic texture, airbrushed studio lighting, extreme beauty filters." Explicit positive prompts for "natural indoor lighting, phone camera snapshot, visible skin pores, subtle expression variation, candid framing."
3. **Wardrobe & Body Proportion Consistency**: Pulls equipped items directly from `DigitalLifeAsset` (e.g., "wearing cyberpunk techwear jacket over black hoodie") and enforces canonical body frame parameters.
4. **Transparent AI Labeling**: All media returned to the client includes metadata flag `isAiGenerated: true` and renders a subtle visual badge in the UI.

---

## 5. Decision Gate

**DO NOT IMPLEMENT THE VISUAL IDENTITY ENGINE UNTIL THE USER OFFICIALLY APPROVES THIS ADR-002.**
